# server.ps1
$pipe = New-Object IO.Pipes.NamedPipeServerStream('\\.\pipe\MyCustomPipe')
$pipe.WaitForConnection()
 
$sr = New-Object IO.StreamReader($pipe)
while (($res = $sr.ReadLine()) -ne 'exit') {
  $res
}
$sr.Dispose()
$pipe.Dispose()
# client.ps1

$pipe = New-Object IO.Pipes.NamedPipeClientStream('\\.\pipe\MyCustomPipe')
$pipe.Connect()
 
$sw = New-Object IO.StreamWriter($pipe)
$sw.WriteLine((Get-ChildItem | Out-String))
$sw.WriteLine('exit');
$sw.Dispose()
$pipe.Dispose()