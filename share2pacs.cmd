@REM =============================env=====================================
@set env.version=2018.04.30
@echo off
SETLOCAL ENABLEEXTENSIONS
cd /D "%~dp0"
call :env.path %~dp0

set scriptname=%~n0
if EXIST "%scriptname%.logo.ini" (
	FOR /f "tokens=1 delims=" %%a IN (%scriptname%.logo.ini) DO echo %%a
)
echo.
echo %scriptname% - environment version %env.version%
echo.


FOR /f "tokens=1,2* delims==" %%a IN (%scriptname%.properties) DO SET %%a=%%b
if not exist "%temp.dir%" mkdir "%temp.dir%"
echo %debug%
for /R "%source.dir%" %%a in (*.*) do call :extract.send "%%a" %%~na%%~xa
goto end 



:env.path
for /D %%i in (%1\*)  do   call :env.path %%i
if EXIST %1\*.exe set PATH=%1;%PATH%
if EXIST %1\*.bat set PATH=%1;%PATH%
if EXIST %1\*.cmd set PATH=%1;%PATH%
goto end

:extract.send
if not exist "%temp.dir%\%2" mkdir "%temp.dir%\%2"
echo process file %1  
DEL /Q "%temp.dir%\%2\FAILED*.*"
echo syn2std %1 "%temp.dir%\%2"  
syn2std %1 "%temp.dir%\%2"   
echo Clean "%temp.dir%\%2\FAILED*.*" 
DEL /Q "%temp.dir%\%2\FAILED*.*"  
echo /Q Send From %device% %pacs% "%temp.dir%\%2" 
call dcmsnd   -L %device% %pacs% "%temp.dir%\%2"   
echo Delete "%temp.dir%\%2" 
rmdir /S /Q "%temp.dir%\%2" 
goto end
:end