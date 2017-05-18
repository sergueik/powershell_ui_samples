# http://techibee.com/powershell/powershell-script-to-copy-powershell-command-output-to-clipboard/1316
# http://poshcode.org/5329 
# see also
# http://poshcode.org/4981 - uses
# https://msdn.microsoft.com/en-us/library/system.management.automation.scriptblock.getsteppablepipeline(v=vs.85).aspx
Function Get-ClipboardText
{
    [CmdletBinding()]
    [OutputType([String])]

    Param() # No parameters

    [System.Windows.Forms.Clipboard]::GetText( 'UnicodeText' ) | Write-Output
}

function Set-Clipboard {

<#
    .Example
        Example 1:
        Get-Process | Set-Clipboard
        Example 2:
        Set-Clipboard -Text "Copy this string to clipboard"

#>
 param (
  $Text
 )

 if($text) {
  $Clipboardtext = $text
  [Windows.Forms.Clipboard]::SetText($clipboardtext)
 } else {
  $prompt = prompt
  $clipboardtext = $prompt + $($myinvocation.line) + $($input | out-string)
 }
 [Windows.Forms.Clipboard]::SetText($clipboardtext)
 $null = [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
}