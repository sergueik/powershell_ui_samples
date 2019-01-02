@echo OFF
setlocal enableextensions enabledelayedexpansion

set PROCESSORS=%2

rem Protect against empty input
if "%PROCESSORS%" neQ "" goto :CONTINUE
set PROCESSORS=4
:CONTINUE
set FILENAME=%~n1
set FILESIZE=%~z1


REM my windows 2003 image is 32 bit.
PATH=%PATH%;C:\CYGWIN\BIN


rem I want to be able to set the number of processors  (%PROCESSORS%) here, and have it create that many concurrent jobs below.

echo starting vutil unload %time%
echo \datatrax\uni66\live\vutil32.exe -unload -b \datatrax\uni66\live\%FILENAME% %FILENAME%.ext
echo starting split %time%

set FILESIZE=1000000
REM --Batch math needs an external script to calculate values over 2GB
REM set /A splitbytes=(%FILESIZE%/%linelength%/%processors%+1)*%linelength%
set linelength=100

for /f "delims=" %%a in ('gawk ^'BEGIN{print int^(%FILESIZE%/%linelength%/%processors%+1^)*%linelength%}^'') do @set splitbytes=%%a 
rem may need to change %splitbytes% to !splitbytes!
 
echo Calculated splitbytes  %splitbytes%
echo split --bytes=%splitbytes% --additional-suffix=".extZ" --numeric-suffixes=1 %1 %FILENAME%
echo starting unloadtocsv %time%


REM  using delayed expansion here
FOR /L %%a in  (1 1 !PROCESSORS!) do @ (
rem convert loop parameter %%a into a script parameter COUNT
  echo "Doing %%a" ; 
  set COUNT=%%a
  set INPUTFILE=%FILENAME%!COUNT!.extZ
  set OUTPUTFILE=%FILENAME%!COUNT!.csvZ
  call :PROCESS !COUNT! !INPUTFILE! !outputfile!
)

rem rm %FILENAME%*.extZ

echo starting merge %time%
REM should get a much more efficient way of concatenating files
head -1 --quiet %FILENAME%01.csvZ >%FILENAME%-p2.csv
tail -n +2 --quiet %FILENAME%*.csvZ >>%FILENAME%-p2.csv
echo Temporary fies:
dir  %FILENAME%*.csvZ
echo Removing temporary files
echo rm %FILENAME%*.csvZ
rem rm %FILENAME%*.csvZ

echo finished at %time%



goto :EOF

:PROCESS

set TASK=%1
set INPUTFILE=%2
set OUTPUTFILE=%3
echo Starting task process # %TASK%
echo It will process %INPUTFILE% 
echo It will proceduce %OUTPUTFILE%
echo start /B gawk.exe --file=unloadtocsv.awk ... %INPUTFILE% %OUTPUTFILE%
echo TASK=%TASK% > %OUTPUTFILE%
echo Was reading %INPUTFILE%  >> %OUTPUTFILE%

echo Complete task process # %TASK%

goto :EOF



