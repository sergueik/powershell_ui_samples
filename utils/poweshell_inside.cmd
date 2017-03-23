@REM Embedded PowerShell script
@REM starting WITH '@REM' and '@@' will be removed
@REM based on: https://blogs.msdn.microsoft.com/jaybaz_ms/2007/04/26/powershell-polyglot/
@REM  
@@setlocal
@@set ARGS=%*
@REM escape quotes
@@if defined ARGS set ARGS=%ARGS:"=\"%
@@powershell.exe -command invoke-expression $('$args=@(^&{$args} %ARGS%);'+[String]::Join(';', ((Get-Content '%~f0' ) -notmatch '(?:^^@@^|^@REM)')))
@@goto :EOF
@REM LEAVE THE NEXT LINE BLANK

@REM DONE


write-output 'Poweshell script'
