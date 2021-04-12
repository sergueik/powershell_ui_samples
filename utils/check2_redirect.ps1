param (
  [String]$script =  'check_redirect.ps1'
)

$arg = '-noprofile -file ' + ( (get-location ).path + '\' + $script )
$app = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
# $process = [Diagnostics.Process]::new()
$err = $null
$out = $null
$process =  new-object System.Diagnostics.Process
$process.StartInfo.FileName  = $app
$process.StartInfo.Arguments = $arg
$process.StartInfo.RedirectStandardOutput = $true
$process.StartInfo.RedirectStandardError  = $true
$process.StartInfo.StandardOutputEncoding = [Text.Encoding]::UTF8
$process.StartInfo.UseShellExecute = $false

if($process.Start()){
  $out = $process.StandardOutput.ReadToEnd()
  $err = $process.StandardError.ReadToEnd()
  $process.WaitForExit()
  write-output ('STDERR: ' + $err)
  write-output ('STDOUT: ' + $out)
} else { 
  write-output: ('Failed to run script: "{0}"' -f $script)
}



