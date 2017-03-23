#If B49717DE_9144_4CE8_87A6_9A8B9BF126CF Then
@REM Multiline comments in Visual Basic .Net
@for /f "tokens=3" %%. in ('echo') do @set IS_ECHO=%%.
@goto :COMPILE
@REM Embedded VB.Net Script
:COMPILE
echo OFF
setlocal
REM Everett.
set ORIGINAL_PATH=%PATH%
PATH=%PATH%;%SYSTEMROOT%\Microsoft.NET\Framework\v1.1.4322
PATH=%ORIGINAL_PATH%
REM Whidbey 
set ORIGINAL_PATH=%PATH%
PATH=%PATH%;%SYSTEMROOT%\Microsoft.NET\Framework\v2.0.50727
REM if %1. == . goto :USAGE
vbc.exe /NOLOGO  -r:System.dll -r:System.Design.dll -r:System.Windows.Forms.dll -r:System.Drawing.dll /out:%TEMP%\%~n0.exe %~dpf0
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto :UNSUPPORTED
if %errorlevel% == 9009 echo You do not have Managed Tools in your PATH&goto :UNSUPPORTED
for /F "tokens=*" %%. in ('where System.dll') do copy /y "%%." %TEMP%

%TEMP%\%~n0.exe %*
endlocal
if %DEBUG%. == .  del /q %TEMP%\%~n0.exe
if /i %IS_ECHO% == "on." echo on
goto :EOF
:USAGE
echo. Sample Usage:
echo.
echo. %~nx0 /input:^<INPUT^> /output:^<OUTPUT^> /inputACP:65000 /outputACP:1251 /debug:[true^|false]
REM WINDIFF  %INPUT% %OUTPUT%
goto :EOF
#End If