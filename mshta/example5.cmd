@echo off
REM This example exercises XML processing in mshta.exe
SETLOCAL
REM Set DEBUG to true to print additional innformation to the console
set DEBUG=false

REM NOTE: mshta.exe fail when inline script exceeds certain size:
REM 495 chars is OK
REM 519 chars is not OK


REM This script counts child nodes
set "SCRIPT=mshta.exe "javascript:{"
set "SCRIPT=%SCRIPT% var fso = new ActiveXObject('Scripting.FileSystemObject');"
set "SCRIPT=%SCRIPT% var out = fso.GetStandardStream(1);"
set "SCRIPT=%SCRIPT% var fh = fso.OpenTextFile('pom.xml', 1, true);"
set "SCRIPT=%SCRIPT% var xd = new ActiveXObject('Msxml2.DOMDocument.6.0');"
set "SCRIPT=%SCRIPT% xd.async = false;"
set "SCRIPT=%SCRIPT% data = fh.ReadAll();"
set "SCRIPT=%SCRIPT% xd.loadXML(data);"
set "SCRIPT=%SCRIPT% root = xd.documentElement;"
set "SCRIPT=%SCRIPT% var tag = 'artifactId';"
set "SCRIPT=%SCRIPT% var xmlnodes = root.childNodes;"
set "SCRIPT=%SCRIPT% if (xmlnodes.length != null) {"
set "SCRIPT=%SCRIPT%   out.Write(xmlnodes.length + ' child nodes\n');"
set "SCRIPT=%SCRIPT% } else {"
set "SCRIPT=%SCRIPT%   out.Write('ERROR');"
set "SCRIPT=%SCRIPT% }"
set "SCRIPT=%SCRIPT% close();}""

if /i "%DEBUG%"=="true" echo %SCRIPT%

REM the next line demonstrates how to collect the response from mstha.exe
for /F "delims=" %%_ in ('%SCRIPT% 1 ^| more') do echo %%_
ENDLOCAL
exit /b