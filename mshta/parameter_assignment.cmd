@echo Off
REM based on http://forum.oszone.net/thread-337897.html	
REM cls
set "MODE=Man"
if not "%MODE%"=="Man" goto :skip_parameter_loading
call :parameter_loading_sub
echo Parameters:
call :SHOW_VARIABLE APP_VERSION
call :SHOW_VARIABLE APP_NAME
call :SHOW_VARIABLE APP_PACKAGE

:skip_parameter_loading
echo Done
pause
goto :EOF

:parameter_loading_sub
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
REM actially define parameters
set APP_VERSION=42
set APP_NAME=foo
set APP_PACKAGE=com.bar
REM the value disappears after ENDLOCAL, but there is a trick against that..
ENDLOCAL &set APP_VERSION=%APP_VERSION% &set APP_NAME=%APP_NAME% &set APP_PACKAGE=%APP_PACKAGE%
exit /b

:SHOW_VARIABLE
SETLOCAL ENABLEDELAYEDEXPANSION
set VAR=%1
if /i "%DEBUG%"=="true" echo>&2 VAR=!VAR!
set RESULT=!VAR!
call :SHOW_VARIABLE_VALUE !%VAR%!
set RESULT=!RESULT!="!DATA!"
echo>&2 !RESULT!
ENDLOCAL
goto :EOF

:SHOW_VARIABLE_VALUE
set VAL=%1
if /i "%DEBUG%"=="true" echo>&2 %1
set DATA=%VAL%
if /i "%DEBUG%"=="true" echo>&2 VALUE=%VAL%
goto :EOF
