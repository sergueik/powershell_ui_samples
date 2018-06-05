@echo off

SETLOCAL
set REGKEY="HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
for /F "tokens=3" %%_ in ('reg.exe query %REGKEY% /v InstallDate') do (
call :CALL_JAVASCRIPT "new Date(parseInt(%%_) * 1000)"
)
ENDLOCAL
exit /b

:CALL_JAVASCRIPT
set "SCRIPT=mshta.exe "javascript:{"

set "SCRIPT=%SCRIPT% var fso = new ActiveXObject('Scripting.FileSystemObject');"
set "SCRIPT=%SCRIPT% var out = fso.GetStandardStream(1);"
set "SCRIPT=%SCRIPT% out.write(%~1);"
set "SCRIPT=%SCRIPT% close();}""
echo %SCRIPT%
for /F "delims=" %%_ in ('%SCRIPT% 1 ^| more') do echo %%_
exit /b