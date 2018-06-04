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
set "SCRIPT=mshta.exe "javascript:new ActiveXObject("
set "SCRIPT=%SCRIPT%'Scripting.FileSystemObject')"
set "SCRIPT=%SCRIPT%.GetStandardStream(1).Write("
set "SCRIPT=%SCRIPT%%~1);close();""
echo %SCRIPT%
for /F "delims=" %%_ in ('%SCRIPT% 1 ^| more') do echo %%_
exit /b