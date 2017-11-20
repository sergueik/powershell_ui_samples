@echo off
REM  origin: http://www.cyberforum.ru/powershell/thread2124072.html
REM check if elevation is necessary
net session >nul 2>&1 && goto :run
if /i "%~1"=="yes" goto :run
>"%temp%\uac.vbs" echo set objShell = CreateObject^("Shell.Application"^)
>> "%temp%\uac.vbs" echo objShell.ShellExecute "%~0", "yes", , "runas", 1
cscript /nologo /e:vbscript "%temp%\uac.vbs"
exit /b 0
 
:run
del "%temp%\uac.vbs"
cd /d "%~dp0"
title %cd%
powershell.exe -executionpolicy bypass -command "&{cd '%~dp0';.\script.ps1}"
echo Done.
pause
