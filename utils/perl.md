@rem = "Embedded Perl script.
@SETLOCAL
@set RSP_FILE=%TMP%\queryjob.%RANDOM%.txt
@echo > %RSP_FILE%
@for /f "tokens=3" %%. in (%RSP_FILE%) do @echo %%. > NUL& set IS_ECHO=%%.
@del /q %RSP_FILE%
@rem = won't work if the ACP is 65001 (UTF8)  or 65000 (UTF16) - sorry.
@echo off
set SELF=%~f0
shift
set ARGS=%*
call :RUNME %SELF% %ARGS%
if /i "%IS_ECHO%" == "on." echo on
@goto :EOF
: RUNME 
set SELF=%~$PATH:1
set HOMEDIR=%~dp1
if %SELF%.==. set SELF=%1
if NOT "%DEBUG%" == "" echo Running %SELF% %ARGS%
call :DISCOVER_CDEV
for /F %%. in ('perl.exe -e "{print $]}" ') do call :TESTVERSION %%. 5.006
if ERRORLEVEL 1 goto :UNSUPPORTED
perl.exe -I%HOMEDIR% -x %SELF% %ARGS%
if %errorlevel% == 9009 echo You do not have Perl in your PATH&goto :UNSUPPORTED
ENDLOCAL
goto :EOF
:TESTVERSION
set PERL_VERSION=%1
set REQUIRED_PERL_VERSION=%2
set NOTICE=This script requires Perl at least of %REQUIRED_PERL_VERSION%
set PERL_VERSION=%PERL_VERSION:.=%
set REQUIRED_PERL_VERSION=%REQUIRED_PERL_VERSION:.=%
set PERL_VERSION=%PERL_VERSION:~0,4%
if "%PERL_VERSION%" lss "%REQUIRED_PERL_VERSION%" echo %NOTICE% & exit /b 1
goto :EOF 
:DISCOVER_CDEV
if not  "%_CDTTOOLSDIR%"  == "" set PATH=%_CDTTOOLSDIR%\PERL\BIN;%PATH%
goto :EOF 
@rem = ";
#! perl
require 5.004;
die "Unsupported OS ($^O), sorry.\n" if $^O eq "dos";

# Your script here

$ENV{DEBUG} and print "successfully launched Perl script!\n";