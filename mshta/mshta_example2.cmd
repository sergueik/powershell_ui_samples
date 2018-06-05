@echo off
REM this example exercises basic coding
SETLOCAL

REM Set DEBUG to true to print additional innformation to the console
set DEBUG=false

set "SCRIPT=mshta.exe "javascript:{"

set "SCRIPT=%SCRIPT% var fso = new ActiveXObject('Scripting.FileSystemObject');"
set "SCRIPT=%SCRIPT% var out = fso.GetStandardStream(1);"
set "SCRIPT=%SCRIPT%   var tags = ['groupId','artifactId','version'];"
set "SCRIPT=%SCRIPT%   for (var cnt in tags ) {"
set "SCRIPT=%SCRIPT%     var tag = tags[cnt];"
set "SCRIPT=%SCRIPT%     out.write(tag + '\n');"
set "SCRIPT=%SCRIPT% }"
set "SCRIPT=%SCRIPT% close();}""

if /i "%DEBUG%"=="true" echo %SCRIPT%

REM the next line demonstrates how to consume the response from mstha.exe
for /F "delims=" %%_ in ('%SCRIPT% 1 ^| more') do echo %%_
ENDLOCAL
exit /b
