@echo OFF
setlocal
REM origin: https://www.codeproject.com/Tips/5255355/How-to-Put-Color-on-Windows-console

reg.exe add HKEY_CURRENT_USER\Console /v VirtualTerminalLevel /t REG_DWORD /d 0x00000001 /f

echo [34mThis is blue[0m
PATH=%PATH%;c:\Python27;c:\Python27\scripts
echo print("\033[31mThis is red\033[0m") > %TEMP%\demo.py
python %TEMP%\demo.py
reg.exe add HKEY_CURRENT_USER\Console /v VirtualTerminalLevel /t REG_DWORD /d 0x00000000 /f
endlocal
