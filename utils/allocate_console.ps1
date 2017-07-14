$ErrorActionPreference = 'Stop'
# origin: https://habrahabr.ru/post/321076/
#$VerbosePreference = 'continue'

$consoleAllocated = [Environment]::UserInteractive
function AllocateConsole()
{
    if($Global:consoleAllocated)
    {
        return
    }

    &cmd /c ver | Out-Null
    $a = @' 
[DllImport("kernel32", SetLastError = true)] 
public static extern bool AllocConsole(); 
'@

    $params = New-Object CodeDom.Compiler.CompilerParameters 
    $params.MainClass = 'methods' 
    $params.GenerateInMemory = $true 
    $params.CompilerOptions = '/unsafe' 
 
    $r = Add-Type -MemberDefinition $a -Name methods -Namespace kernel32 -PassThru -CompilerParameters $params

    Write-Verbose 'Allocating console'
    [kernel32.methods]::AllocConsole() | Out-Null
    Write-Verbose 'Console allocated'
    $Global:consoleAllocated = $true
}

