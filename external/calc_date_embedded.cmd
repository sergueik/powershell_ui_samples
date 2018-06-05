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
REM https://msdn.microsoft.com/en-us/library/ms759095(v=vs.85).aspx
REM reading files
REM https://www.powerobjects.com/2008/09/02/69/
set "SCRIPT=mshta.exe "javascript:{"
set "SCRIPT=%SCRIPT% var fso = new ActiveXObject('Scripting.FileSystemObject');"
set "SCRIPT=%SCRIPT% var out = fso.GetStandardStream(1);"
set "SCRIPT=%SCRIPT% var fh = fso.OpenTextFile('pom.xml', 1, true);"
set "SCRIPT=%SCRIPT% var xd = new ActiveXObject('Msxml2.DOMDocument');"
REM Microsoft.XMLHTTP
REM Msxml2.DOMDocument.3.0
set "SCRIPT=%SCRIPT% xd.async = false;"
set "SCRIPT=%SCRIPT% data = fh.ReadAll();"
set "SCRIPT=%SCRIPT% xd.loadXML(data);"
set "SCRIPT=%SCRIPT% root = xd.documentElement;"
set "SCRIPT=%SCRIPT%out.Write(root.childNodes.length);"

REM set "SCRIPT=%SCRIPT% try { "
set "SCRIPT=%SCRIPT% var xmlnode = root.childNodes.item(1);"

set "SCRIPT=%SCRIPT% out.Write(xmlnode.xml + '\n');"
REM set "SCRIPT=%SCRIPT% } catch(err) { out.Write('error: ' + err); }"
REM set "SCRIPT=%SCRIPT%  finally {}"  
REM set "SCRIPT=%SCRIPT% xmlnode = root.childNodes.item(2);"
REM set "SCRIPT=%SCRIPT% out.Write(xmlnode.text + '\n');"
set "SCRIPT=%SCRIPT% xmlnode = root.childNodes.item(3);"
rem set "SCRIPT=%SCRIPT% if (xmlnode.nodeName.match(/version/g) ){"
set "SCRIPT=%SCRIPT% out.Write(xmlnode.nodeName + '\n');"
rem set "SCRIPT=%SCRIPT% } else { out.Write('x'); } "


REM set "SCRIPT=%SCRIPT% xmlnode = root.childNodes.item(10);"
REM set "SCRIPT=%SCRIPT% out.Write(xmlnode.nodeName + '\n');"


REM 

REM set "SCRIPT=%SCRIPT% var tag = 'version'"
REM set "SCRIPT=%SCRIPT% var node = root.selectSingleNode('/project/' + tag );"

REM set "SCRIPT=%SCRIPT% if (xmlDoc.parseError.errorCode != 0) {"
REM set "SCRIPT=%SCRIPT% var myErr = xmlDoc.parseError;"
REM set "SCRIPT=%SCRIPT% out.GetStandardStream(1).Write('You have error ' + myErr.reason);"
REM set "SCRIPT=%SCRIPT% }" 


set "SCRIPT=%SCRIPT% for (var i = 0; i != 3; i++ ) {"
REM set "SCRIPT=%SCRIPT% var xmlnode = xd.documentElement.childNodes.item(i);"
REM set "SCRIPT=%SCRIPT% out.Write(xmlnode.text + '\n');"
set "SCRIPT=%SCRIPT% }"


REM set "SCRIPT=%SCRIPT% for (var i = 0; i != root.childNodes.length; i++ ) {"
REM set "SCRIPT=%SCRIPT%      out.Write(root.childNodes.item(0).text);"
REM set "SCRIPT=%SCRIPT% out.Write('x');"
REM set "SCRIPT=%SCRIPT% }"


REM The following line breaks script silently
REM set "SCRIPT=%SCRIPT% try {var nodeList = xd.getElementsByTagName('groupId'); } catch(err) {out.Write('error'); }  finally {}"  
REM set "SCRIPT=%SCRIPT%var nodeList = root.getElementsByTagName('groupId');"
REM set "SCRIPT=%SCRIPT%      fso.GetStandardStream(1).Write(root.childNodes.item(1).text);"

REM set "SCRIPT=%SCRIPT%   for (var i = 0; i != root.childNodes.length; i++ ) {"
REM set "SCRIPT=%SCRIPT%      fso.GetStandardStream(1).Write(root.childNodes.item(0).text);"
REM set "SCRIPT=%SCRIPT%   }"
REM set "SCRIPT=%SCRIPT%fso.GetStandardStream(1).Write(data);fh.Close();"
set "SCRIPT=%SCRIPT% close();}""
echo %SCRIPT%
for /F "delims=" %%_ in ('%SCRIPT% 1 ^| more') do echo %%_
exit /b