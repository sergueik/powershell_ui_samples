set filename=%~n1
set filesize=%~z1

set linelength=2076
REM I want to be able to set the number of processors here, and have it create that many concurrent jobs below.

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
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%21.extZ >%filename%21.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%22.extZ >%filename%22.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%23.extZ >%filename%23.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%24.extZ >%filename%24.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%25.extZ >%filename%25.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%26.extZ >%filename%26.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%27.extZ >%filename%27.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%28.extZ >%filename%28.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%29.extZ >%filename%29.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%30.extZ >%filename%30.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%31.extZ >%filename%31.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%32.extZ >%filename%32.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%33.extZ >%filename%33.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%34.extZ >%filename%34.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%35.extZ >%filename%35.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%36.extZ >%filename%36.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%37.extZ >%filename%37.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%38.extZ >%filename%38.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%39.extZ >%filename%39.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%40.extZ >%filename%40.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%41.extZ >%filename%41.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%42.extZ >%filename%42.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%43.extZ >%filename%43.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%44.extZ >%filename%44.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%45.extZ >%filename%45.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%46.extZ >%filename%46.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%47.extZ >%filename%47.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%48.extZ >%filename%48.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%49.extZ >%filename%49.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%50.extZ >%filename%50.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%51.extZ >%filename%51.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%52.extZ >%filename%52.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%53.extZ >%filename%53.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%54.extZ >%filename%54.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%55.extZ >%filename%55.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%56.extZ >%filename%56.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%57.extZ >%filename%57.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%58.extZ >%filename%58.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%59.extZ >%filename%59.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%60.extZ >%filename%60.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%61.extZ >%filename%61.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%62.extZ >%filename%62.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%63.extZ >%filename%63.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%64.extZ >%filename%64.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%65.extZ >%filename%65.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%66.extZ >%filename%66.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%67.extZ >%filename%67.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%68.extZ >%filename%68.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%69.extZ >%filename%69.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%70.extZ >%filename%70.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%71.extZ >%filename%71.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%72.extZ >%filename%72.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%73.extZ >%filename%73.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%74.extZ >%filename%74.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%75.extZ >%filename%75.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%76.extZ >%filename%76.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%77.extZ >%filename%77.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%78.extZ >%filename%78.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%79.extZ >%filename%79.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%80.extZ >%filename%80.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%81.extZ >%filename%81.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%82.extZ >%filename%82.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%83.extZ >%filename%83.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%84.extZ >%filename%84.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%85.extZ >%filename%85.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%86.extZ >%filename%86.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%87.extZ >%filename%87.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%88.extZ >%filename%88.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%89.extZ >%filename%89.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%90.extZ >%filename%90.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%91.extZ >%filename%91.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%92.extZ >%filename%92.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%93.extZ >%filename%93.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%94.extZ >%filename%94.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%95.extZ >%filename%95.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%96.extZ >%filename%96.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%97.extZ >%filename%97.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%98.extZ >%filename%98.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%99.extZ >%filename%99.csvZ 
start /B c:/cygwin64/bin/gawk.exe --file=unloadtocsv.awk -b %filename%.cxfd %filename%00.extZ >%filename%00.csvZ 
  
) | set /P = 
rm %filename%*.extZ
echo starting merge %time%
REM should get a much more efficient way of concatenating files
head -1 --quiet %filename%01.csvZ >%filename%-p2.csv
tail -n +2 --quiet %filename%*.csvZ >>%filename%-p2.csv

rm %filename%*.csvZ

echo finished at %time%


