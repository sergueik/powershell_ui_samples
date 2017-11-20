# origin: https://github.com/gregzakh/alt-ps/blob/master/tools/Get-Clipboard.ps1#requires -version 2function Get-Clipboard {
  [CmdletBinding()]  param()
  begin {    $user32 = New-DllImport user32 -Signature @{      CloseClipboard = [Boolean], @(), $true      EnumClipboardFormats = [UInt32], @([UInt32]), $true      GetClipboardData = [IntPtr], @([UInt32]), $true      OpenClipboard = [Boolean], @([IntPtr]), $true    }
    function private:Test-Format([UInt32]$Format) {      $query = $true
      for ($i = 0; $query -bor $i -ne 0; $i = $user32::EnumClipboardFormats($i)) {        $query = $false        if ($i -eq $Format) { return $true }      }      return $false    }  }  process {}  end {    if ($user32::OpenClipboard([IntPtr]::Zero)) {      Write-Verbose 'clipboard has been successfully opened'
      if (!(Test-Format 13)) { # CF_UNICODETEXT = 13        Write-Verbose 'clipboard does not contain any textual data'        if ($user32::CloseClipboard()) {          Write-Verbose 'clipboard has been successfully closed'        }        return      }
      [Marshal]::PtrToStringAuto($user32::GetClipboardData(13))      if ($user32::CloseClipboard()) {        Write-Verbose 'clipboard has been successfully closed'      }    }  }}
