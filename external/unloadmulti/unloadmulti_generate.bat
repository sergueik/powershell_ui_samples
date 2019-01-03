@echo OFF


REM This script below is a generator of the specifically constructed batch file for parallel processing
REM the gennerated script relies on cmd's pause / wait features when a group of commands is enclosed in parenthesis
echo. Usage:
echo. call %~nx0 BATCH_GENERATED_SCRIPT NUMBER_OF_PROCESSORS
echo. for example
echo. call %~nx0 dummy.bat 4
echo will produce the scipt named dummy.bat with a 4 processes.

setlocal enableextensions enabledelayedexpansion

set BATCH_GENERATED_SCRIPT=%1

set PROCESSORS=%2

rem Protect against empty input
if "%PROCESSORS%" neQ "" goto :CONTINUE
set PROCESSORS=4
:CONTINUE

copy unloadmulti_part1.txt %BATCH_GENERATED_SCRIPT%


echo. >> %BATCH_GENERATED_SCRIPT%
echo ^( >> %BATCH_GENERATED_SCRIPT%

REM  using delayed expansion here

echo rem these jobs all run concurrently >> %BATCH_GENERATED_SCRIPT%
FOR /L %%a in  (1 1 !PROCESSORS!) do @ (
rem convert loop parameter %%a into a script parameter COUNT
  echo "Doing %%a" ; 
  echo "Doing %%a" ; 
  echo Padding with zeros %%a
  set /A COUNT=1000+%%a
  set COUNT=!COUNT:~2!
  set INPUTFILE=%%%%filename%%%%!COUNT!.extZ
  set OUTPUTFILE=%%%%filename%%%%!COUNT!.csvZ
  call :GENERATE_PROCESS !COUNT! !INPUTFILE! !outputfile!
)

echo.  >> %BATCH_GENERATED_SCRIPT%
echo ^) ^| set /P ^= >> %BATCH_GENERATED_SCRIPT%

type unloadmulti_part3.txt |more >> %BATCH_GENERATED_SCRIPT%

goto :EOF

:GENERATE_PROCESS 

set TASK=%1
set INPUTFILE=%2
set OUTPUTFILE=%3
echo Starting task process # %TASK%
echo It will process %INPUTFILE% 
echo It will proceduce %OUTPUTFILE%
echo start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %%filename%%.cxfd %INPUTFILE% ^>%OUTPUTFILE% 
echo start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %%filename%%.cxfd %INPUTFILE% ^>%OUTPUTFILE% >> %BATCH_GENERATED_SCRIPT%

goto :EOF

REM the following is unused: the concurrency is hurt.
REM
:PROCESS

set TASK=%1
set INPUTFILE=%2
set OUTPUTFILE=%3
REM Starting task process # %TASK%
REM It will process %INPUTFILE% 
REM It will proceduce %OUTPUTFILE%
start /wait /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %INPUTFILE% >%OUTPUTFILE%

echo Complete task process # %TASK%

goto :EOF

