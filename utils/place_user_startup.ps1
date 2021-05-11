param (
  [String] $script_path = 'dummy.cmd'
)

if (test-path -path $script_path ) {
  copy-item -destination "${env:USERPROFILE}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -force -path $script_path
}
