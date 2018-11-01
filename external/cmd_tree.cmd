@echo OFF
REM origin: http://forum.oszone.net/thread-337338.html
cls
	if "%~1"=="" (echo No Input Folder &pause &exit /B 2)
	if not Exist "%~1" (echo Folder not found "%~1" &pause &exit /B 1)

	set "BoxIn=%~1"
	if "%BoxIn:~-1%"=="\" set "BoxIn=%BoxIn:~0,-1%"

	set "Def="
	set "Marg=   "
REM   set "Marg="

	echo %BoxIn%
	for /F "usebackq delims=" %%d IN (`2^>nul Dir "%BoxIn%" /B /A:D`) DO call :OUT "%BoxIn%\%%d" %Def%- "%Marg%" 
REM pause
goto :EOF

:OUT
	echo %~3%2%~nx1
	for /F "usebackq delims=" %%d IN (`2^>nul Dir %1 /B /A:D`) DO call :OUT "%~1\%%d" %2- "%~3%Marg%"
goto :EOF