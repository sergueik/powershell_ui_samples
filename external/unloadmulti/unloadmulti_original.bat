echo off
REM setlocal ENABLEDELAYEDEXPANSION


set linelength=2076
REM I want to be able to set the number of processors here, and have it create that many concurrent jobs below.
set processors=20
set filename=%~n1

echo starting vutil unload %time%
\datatrax\uni66\live\vutil32.exe -unload -b \datatrax\uni66\live\%filename% %filename%.ext
echo starting split %time%

set filesize=%~z1
REM --Batch math needs an external script to calculate values over 2GB
REM set /A splitbytes=(%filesize%/%linelength%/%processors%+1)*%linelength%

for /f "delims=" %%a in ('gawk ^'BEGIN{print int^(%filesize%/%linelength%/%processors%+1^)*%linelength%}^'') do @set splitbytes=%%a 

split --bytes=%splitbytes% --additional-suffix=".extZ" --numeric-suffixes=1 %1 %filename%
echo starting unloadtocsv %time%

(
rem these jobs all run concurrently
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%01.extZ >%filename%01.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%02.extZ >%filename%02.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%03.extZ >%filename%03.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%04.extZ >%filename%04.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%05.extZ >%filename%05.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%06.extZ >%filename%06.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%07.extZ >%filename%07.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%08.extZ >%filename%08.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%09.extZ >%filename%09.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%10.extZ >%filename%10.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%11.extZ >%filename%11.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%12.extZ >%filename%12.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%13.extZ >%filename%13.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%14.extZ >%filename%14.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%15.extZ >%filename%15.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%16.extZ >%filename%16.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%17.extZ >%filename%17.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%18.extZ >%filename%18.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%19.extZ >%filename%19.csvZ
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%20.extZ >%filename%20.csvZ
	
) | set /P =

rm %filename%*.extZ
echo starting merge %time%
REM should get a much more efficient way of concatenating files
head -1 --quiet %filename%01.csvZ >%filename%-p2.csv
tail -n +2 --quiet %filename%*.csvZ >>%filename%-p2.csv

rm %filename%*.csvZ

echo finished at %time%

