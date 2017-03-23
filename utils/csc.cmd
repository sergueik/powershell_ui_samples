/* 2> NUL|| goto :COMPILE
:COMPILE
@REM Embedded C# Script
@for /f "tokens=3" %%. in ('echo') do @set IS_ECHO=%%.
@echo OFF
setlocal
goto :NOCOMPLUSQUERY
echo COMPLUS_INSTALLROOT=^>
reg.exe query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework" /v InstallRoot
echo COMPLUS_VERSION=^>
REM the below query is Product-GUID dependend and will fail ol AMD64.
reg.exe query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{CB2F7EDD-9D1F-43C1-90FC-4F52EAE172A1}" /v DisplayVersion
:NOCOMPLUSQUERY
if %1. == . goto :USAGE
PATH=%PATH%;%SYSTEMROOT%\Microsoft.NET\Framework\v1.1.4322
csc.exe /NOLOGO  -r:system.dll /out:%TEMP%\%~n0.exe %~dpf0
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto :UNSUPPORTED
if %errorlevel% == 9009 echo You do not have Managed Tools in your PATH&goto :UNSUPPORTED
for /F "tokens=*" %%. in ('where System.dll') do copy /y "%%." %TEMP% >NUL

%TEMP%\%~n0.exe %*
endlocal
if %DEBUG%. == .  del /q %TEMP%\%~n0.exe
if /i %IS_ECHO% == "on." echo on
goto :EOF
:USAGE
echo. Sample Usage:
echo.
echo. %~nx0 /job:^<JOBNUMBER^> /server:^<PLANB SERVER^>
goto :EOF


*/
