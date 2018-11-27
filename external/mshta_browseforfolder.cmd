@echo off
REM origin: http://forum.oszone.net/thread-337893.html

setlocal

for /f "tokens=2 delims=:" %%i in ('chcp') do (
set sPrevCP=%%i
chcp 65001 >nul
)


for /f "usebackq delims=" %%i in (
`@"%systemroot%\system32\mshta.exe" "javascript:var objShellApp = new ActiveXObject('Shell.Application');var Folder = objShellApp.BrowseForFolder(0, 'SELECT FOLDER',1, '::{20D04FE0-3AEA-1069-A2D8-08002B30309D}');try {new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).Write(Folder.Self.Path)};catch (e){};close();" ^
1^|more`
) do set sFolderName=%%i

if defined sFolderName (
echo Selected: %sFolderName%
) else (
echo Quit.
)
chcp %sPrevCP% >nul
