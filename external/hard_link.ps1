# origin https://github.com/gregzakh/alt-ps/blob/master/New-HardLink.ps1

function New-HardLink {
  <#
    .SYNOPSIS
        Establishes a hard link between an existing file and a new file.
    .DESCRIPTION
        This function is only supported on the NTFS file system, and
        only for files, not directories.
    .PARAMETER Source
        The name of the existing file.
    .PARAMETER Destination
        The name of the new file.
    .OUTPUTS
        If the function succeeds, the return value is $true.
    .EXAMPLE
        PS C:\> New-HardLink C:\proj\source.c C:\test\current.c
  #>
  param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateScript({Test-Path $_})]
    [ValidateNotNullOrEmpty()]
    [String]$Source,
    
    [Parameter(Mandatory=$true, Position=1)]
    [ValidateNotNullOrEmpty()]
    [String]$Destination
  )
  
  begin {
    @(
      [Runtime.InteropServices.CallingConvention],
      [Runtime.InteropServices.HandleRef],
      [Reflection.Emit.OpCodes]
    ) | ForEach-Object {
      $keys = ($ta = [PSObject].Assembly.GetType(
        'System.Management.Automation.TypeAccelerators'
      ))::Get.Keys
      $collect = @()
    }{
      if ($keys -notcontains $_.Name) {
        $ta::Add($_.Name, $_)
      }
      $collect += $_.Name
    }
    
    function private:Set-Delegate {
      param(
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [String]$Module,
        
        [Parameter(Mandatory=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [String]$Function,
        
        [Parameter(Mandatory=$true, Position=2)]
        [ValidateNotNullOrEmpty()]
        [String]$Delegate
      )
      
      begin {
        [Regex].Assembly.GetType(
          'Microsoft.Win32.UnsafeNativeMethods'
        ).GetMethods() | Where-Object {
          $_.Name -cmatch '\AGet(ProcA|ModuleH)'
        } | ForEach-Object {
          Set-Variable $_.Name $_
        }
        
        $ptr = $GetProcAddress.Invoke($null, @(
          [HandleRef](New-Object HandleRef(
            (New-Object IntPtr), $GetModuleHandle.Invoke($null, @($Module))
          )), $Function
        ))
      }
      process { $proto = Invoke-Expression $Delegate }
      end {
        $method = $proto.GetMethod('Invoke')
        
        $returntype = $method.ReturnType
        $paramtypes = $method.GetParameters() |
                                        Select-Object -ExpandProperty ParameterType
        
        $holder = New-Object Reflection.Emit.DynamicMethod(
          'Invoke', $returntype, $paramtypes, $proto
        )
        $il = $holder.GetILGenerator()
        0..($paramtypes.Length - 1) | ForEach-Object {
          $il.Emit([OpCodes]::Ldarg, $_)
        }
        
        switch ([IntPtr]::Size) {
          4 { $il.Emit([OpCodes]::Ldc_I4, $ptr.ToInt32()) }
          8 { $il.Emit([OpCodes]::Ldc_I8, $ptr.ToInt64()) }
        }
        $il.EmitCalli(
          [OpCodes]::Calli, [CallingConvention]::StdCall, $returntype, $paramtypes
        )
        $il.Emit([OpCodes]::Ret)
        
        $holder.CreateDelegate($proto)
      }
    }
    
    $CreateHardLink = Set-Delegate kernel32 CreateHardLinkW `
                                      '[Func[[Byte[]], [Byte[]], IntPtr, Boolean]]'
  }
  process {
    $CreateHardLink.Invoke(
      [Text.Encoding]::Unicode.GetBytes($Destination),
      [Text.Encoding]::Unicode.GetBytes($Source),
      [IntPtr]::Zero
    )
  }
  end {
    $collect | ForEach-Object { [void]$ta::Remove($_) }
  }
}
