param (
  [String] $script_dir = (get-location),
  [String] $script_name = 'dummy.cmd',
  [String] $user_name = '',
  # NOTE: $null is a bad default value for $user_name parameter:
  # when launched without an user_name argument, the $user_name -ne $null check is failing
  # Alternatively,
  # [String] $user_name = ('{0}\{1}'  -f $env:userdomain, $env:username ),
  [switch] $remove
)
# NOTE: WindowsIdentity.Name returns the user's Windows logon name in the form DOMAIN\USERNAME
# (together with domain)
# https://docs.microsoft.com/en-us/dotnet/api/system.security.principal.windowsidentity.getcurrent?view=netframework-2.0
# https://docs.microsoft.com/en-us/dotnet/api/system.security.principal.windowsidentity.name?view=netframework-2.0
if (($user_name -ne '') -and ([Security.Principal.WindowsIdentity]::GetCurrent().Name  -ne $user_name) ) {
  write-output ('This script is supposed to run by user {0}, and is attempted by {1}' -f $user_name,[Security.Principal.WindowsIdentity]::GetCurrent().Name)
  return
}
$script_path = "${script_dir}\${script_name}"
if ($remove){
  $full_path = "${env:USERPROFILE}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\${script_name}"
  if (test-path -path $full_path ) {
    remove-item -literalpath $full_path -force
  }
} else {
  if (test-path -path $script_path ) {
    copy-item -destination "${env:USERPROFILE}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -force -path $script_path
  }
}
