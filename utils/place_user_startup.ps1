param (
  [String] $script_dir = (get-location),
  [String] $script_name = 'dummy.cmd',
  [String] $user_name = $null,
  [switch] $remove
)
if (($user_name -ne $null) -and ([Security.Principal.WindowsIdentity]::GetCurrent().Name  -ne $user_name) ) {
  write-output ('This script is supposed to run by user {0}' -f $user_name)
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
