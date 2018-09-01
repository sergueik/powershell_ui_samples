@echo off
REM this example uses basic coding exercise to illustrate commandline size limitation of inline scripting
SETLOCAL

REM Set DEBUG to true to print additional innformation to the console
set DEBUG=false

set "SCRIPT=mshta.exe "javascript:{"
REM Copied code a number of times to make itfail and illustrate the suspected script size limitaiton,
REM which likely is te command line size limitation of cmd
set "SCRIPT=%SCRIPT% var fso = new ActiveXObject('Scripting.FileSystemObject');"
set "SCRIPT=%SCRIPT% var out = fso.GetStandardStream(1);"
set "SCRIPT=%SCRIPT%   var tags = ['groupId','artifactId','version'];"
set "SCRIPT=%SCRIPT%   for (var cnt in tags ) {"
set "SCRIPT=%SCRIPT%     var tag = tags[cnt];"
set "SCRIPT=%SCRIPT%     out.write(tag + ' 1\n');"
set "SCRIPT=%SCRIPT% }"
set "SCRIPT=%SCRIPT%   for (var cnt in tags ) {"
set "SCRIPT=%SCRIPT%     var tag = tags[cnt];"
set "SCRIPT=%SCRIPT%     out.write(tag + ' 2\n');"
set "SCRIPT=%SCRIPT% }"
set "SCRIPT=%SCRIPT%   for (var cnt in tags ) {"
set "SCRIPT=%SCRIPT%     var tag = tags[cnt];"
set "SCRIPT=%SCRIPT%     out.write(tag + ' 3\n');"
set "SCRIPT=%SCRIPT% }"
set "SCRIPT=%SCRIPT%   for (var cnt in tags ) {"
set "SCRIPT=%SCRIPT%     var tag = tags[cnt];"
set "SCRIPT=%SCRIPT%     out.write(tag + '4\n');"
REM uncomment the next line to make the script silently fail
REM set "SCRIPT=%SCRIPT%     out.write(tag + '4\n');"
set "SCRIPT=%SCRIPT% }"
set "SCRIPT=%SCRIPT% close();}""

if /i "%DEBUG%"=="true" echo %SCRIPT%

REM the next line demonstrates how to collect the response from mstha.exe
for /F "delims=" %%_ in ('%SCRIPT% 1 ^| more') do echo %%_
ENDLOCAL
exit /b
