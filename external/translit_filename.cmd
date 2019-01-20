@echo off
setlocal enableDelayedexpansion
REM origin: http://forum.oszone.net/thread-252100.html
REM

REM Путь к обрабатываемой папке
set FOLDER=e:\Temp\3 3

REM При замене командой set (как выяснилось) заглавные и маленькие буквы не различаются
REM Всвязи с этим не смысла использовать полный список (с маленькими и заглавными буквами), достаточно любой половины
REM Здесь использована половина с маленькими буквами, поэтому после транслитерации новые имена окажутся в нижнем регистре
REM Если требуются имена в верхнем регистре, то следует использовать половину с заглавными буквами

REM Список замен
REM set preset=а_a б_b в_v г_g д_d е_e ё_yo ж_zh з_z и_i й_i к_k л_l м_m н_n о_o п_p р_r с_s т_t у_u ф_f х_kh ц_c ч_ch ш_sh щ_sh ъ_. ы_y ь_. э_e ю_yu я_ya А_A Б_B В_V Г_G Д_D Е_E Ё_Yo Ж_Zh З_Z И_I Й_I К_K Л_L М_M Н_N О_O П_P Р_R С_S Т_T У_U Ф_F Х_Kh Ц_C Ч_Ch Ш_Sh Щ_Sh Ъ_. Ы_Y Ь_. Э_E Ю_Yu Я_Ya
set preset=а_a б_b в_v г_g д_d е_e ё_yo ж_zh з_z и_i й_i к_k л_l м_m н_n о_o п_p р_r с_s т_t у_u ф_f х_kh ц_c ч_ch ш_sh щ_sh ъ_. ы_y ь_. э_e ю_yu я_ya

REM NOTE: script needs to be saved in custom ACP
REM AKA Кодировка Кириллица DOC (866)
REM which makes is fragile and prone to copy paste damage
REM in the part
REM set preset=а_a б_b в_v г_g ґ_g ѓ_gj д_d ђ_dj е_e є_ie ё_yo ж_zh з_z и_i і_i ї_ji й_i к_k л_l љ_lj м_m н_n њ_nj о_o п_p р_r с_s т_t ќ_c ћ_c у_u ф_f х_kh ц_c ч_ch џ_dz ш_sh щ_shch ъ_. ы_y ь_' э_e ю_yu я_ia А_A Б_B В_V Г_G Ґ_G Ѓ_Gj Д_D Ђ_Dj Е_E Є_Ye Ё_Yo Ж_Zh З_Z И_I І_I Ї_Ji Й_I К_K Л_L Љ_Lj М_M Н_N Њ_Nj О_O П_P Р_R С_S Т_T Ќ_C Ћ_C У_U Ф_F Х_Kh Ц_C Ч_Ch Џ_Dz Ш_Sh Щ_Shch Ъ_. Ы_Y Ь_' Э_E Ю_Yu Я_Ya
REM

REM После проверки слово ECHO удалить
for /F "tokens=* delims=" %%A in ('dir /S /B /A:-D "%FOLDER%"') do (
	call :translate1 "%%~nA"
	echo ren "%%A" "!DATA!%%~xA"
)
pause
exit

:translate1
set DATA=%~1
set DATA=%DATA: =_%
for %%I in (%preset%) do for /F "tokens=1,2 delims=_" %%A in ("%%I") do set DATA=!DATA:%%A=%%B!
goto :EOF

:translate2
REM Первый аргумент служит в качестве входящих данных.
set DATA=%~1

REM Проверяем на то, передан ли аргумент и заменяем пробелы на нижнее
REM подчеркивание.
if defined DATA (set DATA=!DATA: =_!) else (exit /B 1)
for %%I in (a_a б_b в_v г_g д_d е_e ё_yo ж_zh з_z и_i й_i к_k л_l м_m н_n о_o п_p р_r с_s т_t у_u ф_f х_kh ц_c ч_ch ш_sh щ_sh ъ_. ы_y ь_. э_e ю_yu я_ya А_A Б_B В_V Г_G Д_D Е_E Ё_Yo Ж_Zh З_Z И_I Й_I К_K Л_L М_M Н_N О_O П_P Р_R С_S Т_T У_U Ф_F Х_Kh Ц_C Ч_Ch Ш_Sh Щ_Sh Ъ_. Ы_Y Ь_. Э_E Ю_Yu Я_Ya) do for /F "tokens=1,2 delims=_" %%A in ("%%I") do set DATA=!DATA:%%A=%%B!
echo !DATA!
exit /B 0

