@echo Off
REM based on http://forum.oszone.net/thread-337897.html

echo:
call :sub "/project/artifactId" "ARTIFACT_ID"
echo ARTIFACT_ID=%ARTIFACT_ID%

call :sub "/project/groupId" "GROUP_ID"
echo GROUP_ID=%GROUP_ID%

call :sub  "/project/version" "APP_VERSION"
echo  APP_VERSION=%APP_VERSION%

pause

goto :EOF

:sub
call :get_result %~1
set "%~2=%RESULT%"
exit /b

:get_result
set PARAM=%~1
echo calling  mshta.exe with %PARAM%
call :CALL_JAVASCRIPT %PARAM%

set "RESULT=result(%VALUE%)"
exit /b

:CALL_JAVASCRIPT

REM This script extracts project g.a.v a custom property from pom.xml using mshta.exe and DOM selectSingleNode method
set "SCRIPT=mshta.exe "javascript:{"
set "SCRIPT=%SCRIPT% var fso = new ActiveXObject('Scripting.FileSystemObject');"
set "SCRIPT=%SCRIPT% var out = fso.GetStandardStream(1);"
set "SCRIPT=%SCRIPT% var fh = fso.OpenTextFile('pom.xml', 1, true);"
set "SCRIPT=%SCRIPT% var xd = new ActiveXObject('Msxml2.DOMDocument');"
set "SCRIPT=%SCRIPT% xd.async = false;"
set "SCRIPT=%SCRIPT% data = fh.ReadAll();"
set "SCRIPT=%SCRIPT% xd.loadXML(data);"
set "SCRIPT=%SCRIPT% root = xd.documentElement;"
set "SCRIPT=%SCRIPT% var xpath = '%~1';"
set "SCRIPT=%SCRIPT% var xmlnode = root.selectSingleNode( xpath);"
set "SCRIPT=%SCRIPT% if (xmlnode != null) {"
set "SCRIPT=%SCRIPT%   out.Write(xpath + '=' + xmlnode.text);"
set "SCRIPT=%SCRIPT% } else {"
set "SCRIPT=%SCRIPT%   out.Write('ERR');"
set "SCRIPT=%SCRIPT% }"
set "SCRIPT=%SCRIPT% close();}""

for /F "tokens=2 delims==" %%_ in ('%SCRIPT% 1 ^| more') do set VALUE=%%_
ENDLOCAL
exit /b
