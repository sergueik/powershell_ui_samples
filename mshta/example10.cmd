@echo off

SETLOCAL

REM set DEBUG to TRUE to print additional innformation to the console
set VERBOSE=true
REM TODO: add toggle
REM call :SETUP
REM goto :EOF
REM
set WINDOW_TITLE=Personalization
call :CALL_JAVASCRIPT1 %WINDOW_TITLE%
set HWND=%VALUE%
echo HWND="%HWND%"
call :CALL_JAVASCRIPT2 %WINDOW_TITLE%
set HWND=%VALUE%
echo HWND="%HWND%"
call :CLEANUP

ENDLOCAL
exit /b
goto :EOF

:CALL_JAVASCRIPT1
REM This script illustrates the CreateTextFile method
REM mshta.exe "javascript:{var fso = new ActiveXObject('Scripting.FileSystemObject');var f = fso.CreateTextFile('c:\\temp\\dummy.txt', true); f.Write('x');f.close();close();}"
REM NOTE: the GetStandardStream method is less stable:
REM mshta.exe "javascript:{var fso = new ActiveXObject('Scripting.FileSystemObject');var f = fso.GetStandardStream(1);f.Write('x');f.close();close();}"
REM Does not work:
REM error varies with OS release:
REM Windows 8.1
REM The data necessary to complete this operation is not yet available.
REM Windows 7
REM The handle is invalid.
set "SCRIPT=mshta.exe "javascript:{"
set "SCRIPT=%SCRIPT%o=new ActiveXObject('Shell.Application');"
set "SCRIPT=%SCRIPT%x=o.Windows();"
set "SCRIPT=%SCRIPT%f=new ActiveXObject('Scripting.FileSystemObject');"
set "SCRIPT=%SCRIPT%c=f.CreateTextFile('c:\\temp\\dummy.txt', true);"
set "SCRIPT=%SCRIPT%c.Write(x.Count);c.Close();"
set "SCRIPT=%SCRIPT%close();}""

if /i "%DEBUG%"=="true" echo Script:
if /i "%DEBUG%"=="true" echo %SCRIPT%
call %SCRIPT%
for /F "tokens=1 delims==" %%_ in ('type c:\temp\dummy.txt ^| more') do set VALUE=%%_
ENDLOCAL

exit /b
goto :EOF


:CALL_JAVASCRIPT2
REM This script illustrates the Windows and LoctionName methods
REM C:\Users\sergueik>mshta.exe "javascript:{ var o = new ActiveXObject('Shell.Application'); var x =o.Windows(); var fso = new ActiveXObject('Scripting.FileSystemObject');var f = fso.CreateTextFile('c:\\temp\\dummy.txt', true); f.Write(x.Count); for (var cnt = 0; cnt < x.Count; cnt++) { w = x.item(cnt);  if (w.LocationName.match('Personalization')) {   f.Write('HWND:\t' + w.HWND); w.Quit();}} close();}"

set "SCRIPT=mshta.exe "javascript:{"
set "SCRIPT=%SCRIPT%o=new ActiveXObject('Shell.Application');"
set "SCRIPT=%SCRIPT%x=o.Windows();"
set "SCRIPT=%SCRIPT%f=new ActiveXObject('Scripting.FileSystemObject');"
set "SCRIPT=%SCRIPT%c=f.CreateTextFile('c:\\temp\\dummy.txt', true);"
set "SCRIPT=%SCRIPT%c.Write(x.Count);"
set "SCRIPT=%SCRIPT%if(x.Count==0){close();}for(cnt=0;cnt!=x.Count;cnt++){w =x.item(cnt);"
REM set "SCRIPT=%SCRIPT% if (x.Count == 0) { close(); } for (var cnt = 0; cnt ^< x.Count; cnt++) { w = x.item(cnt);"
set "SCRIPT=%SCRIPT% if (w.LocationName.match('Personalization')) {"
set "SCRIPT=%SCRIPT%c.Write('HWND:\t' + w.HWND);"
set "SCRIPT=%SCRIPT%w.Quit();}}"
set "SCRIPT=%SCRIPT%close();}""

if /i "%DEBUG%"=="true" echo Script:
if /i "%DEBUG%"=="true" echo %SCRIPT%
call %SCRIPT%
for /F "tokens=1 delims==" %%_ in ('type c:\temp\dummy.txt ^| more') do set VALUE=%%_
ENDLOCAL
exit /b
goto :EOF

:SETUP
set THEME=C:\Windows\Resources\Themes\nature.theme
rundll32.exe %SystemRoot%\system32\shell32.dll,Control_RunDLL %SystemRoot%\system32\desk.cpl desk,@Themes /Action:OpenTheme /file:"%THEME%"

goto :EOF

:CLEANUP

1>NUL 2>NUL tasklist.exe /fi "IMAGENAME eq mshta.exe"
REM NOTE errorlevel is not set
1>NUL 2>NUL timeout.exe /T 10 /NOBREAK
1>NUL 2>NUL taskkill.exe /IM mshta.exe /T
goto :EOF
