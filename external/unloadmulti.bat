@echo OFF
setlocal enableextensions enabledelayedexpansion

set POOLSIZE=%~z1
REM ...
REM my windos 2003 image is 32 bit.
PATH=%PATH%;C:\CYGWIN\BIN
FOR /L %%a in  (1 1 10) do @ (
  echo "Doing %%a" ; 
  set count=%%a
  echo Created parameter !count!
  set INPUTFILE=input!count!.txt
  echo input file number !count! !INPUTFILE!
  set OUTPUTFILE=result!count!.txt
  echo Writing file number !count!  !outputfile!
  call :PROCESS !count! !INPUTFILE! !outputfile!
)
goto :EOF
:PROCESS
set DATA=%1
set INPUTFILE=%2
set OUTPUTFILE=%3

echo writing %DATA% from %INPUTFILE% to %OUTPUTFILE%
goto :EOF


