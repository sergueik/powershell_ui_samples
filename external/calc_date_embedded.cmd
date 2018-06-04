@echo off
REM origin: https://github.com/gregzakh/notes/commit/7ad26f7d86996e66823c1c52a79289cc02137a60#diff-cbc7d950b3d9a90762d5544e0ffa5bcd
SETLOCAL
set REGKEY="HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
for /F "tokens=3" %%_ in ('reg.exe query %REGKEY% /v InstallDate') do (
call :CALL_JAVASCRIPT "new Date(parseInt(%%_) * 1000)"
)
ENDLOCAL
exit /b

:CALL_JAVASCRIPT
REM concatenates the argument 
REM representing a valid JS code fragment
REM into the script executed on mshta.exe 
REM output redirected to console
REM the equivalent VBScript example
REM https://stackoverflow.com/questions/28134997/can-i-run-vbscript-commands-directly-from-the-command-line-i-e-without-a-vbs-f?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
REM is harder to modify
set "SCRIPT=mshta.exe "javascript:{"
set "SCRIPT=%SCRIPT%new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).Write("
set "SCRIPT=%SCRIPT%%~1"
set "SCRIPT=%SCRIPT%);close();}""
echo %SCRIPT%
for /F "delims=" %%_ in ('%SCRIPT% 1 ^| more') do echo %%_
exit /b