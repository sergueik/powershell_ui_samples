@echo off
REM This example exercises XML processing in mshta.exe
SETLOCAL
REM Set DEBUG to true to print additional innformation to the console
set DEBUG=false

REM NOTE: mshta.exe fail when inline script exceeds certain size:
REM 495 chars is OK
REM 519 chars is not OK

set "SCRIPT=mshta.exe "javascript:{"
set "SCRIPT=%SCRIPT% var fso = new ActiveXObject('Scripting.FileSystemObject');"
set "SCRIPT=%SCRIPT% var out = fso.GetStandardStream(1);"
set "SCRIPT=%SCRIPT% var fh = fso.OpenTextFile('pom.xml', 1, true);"
set "SCRIPT=%SCRIPT% var xd = new ActiveXObject('Msxml2.DOMDocument.6.0');"
set "SCRIPT=%SCRIPT% xd.async = false;"
set "SCRIPT=%SCRIPT% data = fh.ReadAll();"
REM NOTE: Cannot do xd.load("file path")
set "SCRIPT=%SCRIPT% xd.loadXML(data);"
set "SCRIPT=%SCRIPT% root = xd.documentElement;"
set "SCRIPT=%SCRIPT% var x = 0 ;"
REM change the variable name from 'x' to 'xxx' to cause the script to fail.
REM The other option is to specify COM object as 'Msxml2.DOMDocument.6.0' than 'Msxml2.DOMDocument'
set "SCRIPT=%SCRIPT% out.Write('Number of nodes: ' + root.childNodes.length + '\n');"

set "SCRIPT=%SCRIPT% var node = root.childNodes.item(1);"
set "SCRIPT=%SCRIPT% out.Write(node.xml + '\n');"

set "SCRIPT=%SCRIPT% node = root.childNodes.item(3);"
REM set "SCRIPT=%SCRIPT% out.Write('xxx');"
set "SCRIPT=%SCRIPT% out.Write(node.nodeName + '\n');"

set "SCRIPT=%SCRIPT% close();}""

if /i "%DEBUG%"=="true" echo %SCRIPT%

REM the next line demonstrates how to consume the response from mstha.exe
for /F "delims=" %%_ in ('%SCRIPT% 1 ^| more') do echo %%_
ENDLOCAL
exit /b
