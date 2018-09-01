@echo off

SETLOCAL
REM set DEBUG to TRUE to print additional innformation to the console
set DEBUG=TRUE

call :CALL_JAVASCRIPT artifactId
set ARTIFACTID=%VALUE%

call :CALL_JAVASCRIPT groupId
set GROUPID=%VALUE%

call :CALL_JAVASCRIPT version
set VERSION=%VALUE%

if /i NOT "%DEBUG%"=="true" goto :FINISH

echo VERSION="%VERSION%"
echo ARTIFACTID="%ARTIFACTID%"
echo GROUPID="%GROUPID%"

:FINISH

ENDLOCAL
exit /b

:CALL_JAVASCRIPT
REM This script illustrates browsing the child nodes to extract the gav information from pom.xml
set "SCRIPT=mshta.exe "javascript:{"
set "SCRIPT=%SCRIPT% var fso = new ActiveXObject('Scripting.FileSystemObject');"
set "SCRIPT=%SCRIPT% var out = fso.GetStandardStream(1);"
set "SCRIPT=%SCRIPT% var handle = fso.OpenTextFile('pom.xml',1,1);"
set "SCRIPT=%SCRIPT% var xml = new ActiveXObject('Msxml2.DOMDocument.6.0');"
set "SCRIPT=%SCRIPT% xml.async = false;"
set "SCRIPT=%SCRIPT% xml.loadXML(handle.ReadAll());"
set "SCRIPT=%SCRIPT% root = xml.documentElement;"
set "SCRIPT=%SCRIPT% var tag ='%~1';"
set "SCRIPT=%SCRIPT% nodes = root.childNodes;"
set "SCRIPT=%SCRIPT% for(i = 0; i != nodes .length; i++){"
set "SCRIPT=%SCRIPT%   if (nodes.item(i).nodeName.match(RegExp(tag, 'g'))) {"
set "SCRIPT=%SCRIPT%     out.Write(tag + '=' + nodes.item(i).text + '\n');"
set "SCRIPT=%SCRIPT%   }"
set "SCRIPT=%SCRIPT% }"
set "SCRIPT=%SCRIPT%close();}""

REM if /i "%DEBUG%"=="true" echo %SCRIPT%
REM if /i "%DEBUG%"=="true" for /F "delims=" %%_ in ('%SCRIPT% 1 ^| more') do echo %%_

for /F "tokens=2 delims==" %%_ in ('%SCRIPT% 1 ^| more') do set VALUE=%%_
ENDLOCAL
exit /b
