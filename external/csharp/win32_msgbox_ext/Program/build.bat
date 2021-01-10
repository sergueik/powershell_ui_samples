@echo OFF
set COMPLUSVERSION=v4.0.30319
REM rc.exe error RC2135 : file not found: "ICON1.ICO"
PATH=%PATH%;c:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Bin
PATH=%PATH%;c:\windows\Microsoft.NET\Framework\%COMPLUSVERSION%
csc.exe /NOLOGO -r:%SYSTEMROOT%\Microsoft.NET\Framework\%COMPLUSVERSION%\system.dll -r:%CD%\..\Utils\bin\Debug\Utils.dll -platform:x86 -out:%TEMP%\DemoForm.exe  /target:winexe /win32res:Icon1.ico DemoForm.cs  AssemblyInfo.cs
