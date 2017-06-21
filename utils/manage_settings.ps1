# origin: https://github.com/chaliy/psconfig/blob/master/PsConfig/PsConfig.psm1

function Get-Setting {
  [CmdletBinding()]
  param(
    [Parameter(ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,Mandatory = $true,Position = 0)]
    [string]$Name,
    [switch]$Encrypted,
    $Path = (Join-Path $HOME .Settings),
    [string]$Prompt
  )
  if (Test-Path $Path) {
    $Path = Resolve-Path $Path
    Write-Verbose "Read settings from ${Path}"
    $settings = ConvertFrom-StringData ([IO.File]::ReadAllText($Path))
    if ($Encrypted) {
      $value = [string]$settings[$Name]
      if ($value -ne '') {
        $value = DecryptValue $value
      }
    } else {
      $value = $settings[$Name]
    }
  } else {
    Write-Verbose "Path ${Path} was not found."
  }

  if ($Prompt -ne '' -and ($value -eq '' -or $value -eq $null)) {
    $value = Read-Host $Prompt
    Set-Setting $Name $value -Encripted:$Encripted -Path:$Path
  }

  [string]$value
}

function Set-Setting {
  [CmdletBinding()]
  param(
    [Parameter(ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,Mandatory = $true,Position = 0)]
    [string]$Name,
    [Parameter(ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,Mandatory = $true,Position = 1)]
    $Value,
    [switch]$Encrypted,
    $Path = (Join-Path $HOME .Settings)
  )
  $settings = @{}
  if (Test-Path $Path) {
    $Path = Resolve-Path $Path
    $settings = ConvertFrom-StringData ([IO.File]::ReadAllText($Path))
  }
  if ($Encrypted) {
    $settings[$Name] = EncryptValue $Value
  } else {
    $settings[$Name] = $Value
  }
  Write-Verbose "Write settings to ${Path}"
  Set-Content $Path (ConvertToStringData $settings)
}

function ConvertToStringData ($state) {
  $buffer = New-Object Text.StringBuilder
  foreach ($key in $state.Keys) {
    $buffer.AppendLine($key + '=' + $state[$key]) | Out-Null
  }
  $buffer
}

function EncryptValue ($value) {
  Add-Type -AssemblyName System.Security
  $data = [Text.Encoding]::Default.GetBytes($value)
  $encData = [Security.Cryptography.ProtectedData]::Protect($data,$null,'CurrentUser')
  [convert]::ToBase64String($encData)
}

function DecryptValue ($value) {
  Add-Type -AssemblyName System.Security
  $encData = [convert]::FromBase64String($value)
  $data = [Security.Cryptography.ProtectedData]::Unprotect($encData,$null,'CurrentUser')
  [Text.Encoding]::Default.GetString($data)
}