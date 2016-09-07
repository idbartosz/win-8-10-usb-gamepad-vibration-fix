@echo OFF
set apptitle=Windows 8/10 Gamepad vibration fix
title %apptitle%
mode con:cols=39 lines=16
color 3F

echo    https://github.com/idbartosz
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ~ %apptitle% ~
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo NOTE: Drivers with vibration
echo       support must be installed!
echo.
echo +------------------------------------+

<nul set /p=^| Integrity test............
set syswow64=SysWOW64
set system32=system32
set filesyswow64=%windir%\%syswow64%\joy.cpl
set filesystem32=%windir%\%system32%\joy.cpl
if exist %filesyswow64% if exist %filesystem32% goto pass
set error=Couldn't find 'joy.cpl'.
goto fail

:pass
<nul set /p=[ PASS ]
echo  ^|

PUSHD %~dp0
set backup=.\backup_gamepad
<nul set /p=^| Backing up files..........
if not exist %backup% MKDIR %backup% 2>nul

PUSHD %backup%
if not exist .\%syswow64% MKDIR %syswow64% 2>nul
PUSHD .\%syswow64%
1>NUL COPY %filesyswow64% .\

PUSHD ..\
if not exist .\%system32% MKDIR %system32% 2>nul
PUSHD .\%system32%
1>NUL COPY %filesystem32% .\

PUSHD ..\..\

<nul set /p=[ PASS ]
echo  ^|

<nul set /p=^| Patching..................
DEL %filesystem32% > nul 2>&1
if exist %filesystem32% (
set error=Admin permission required.
goto fail
)
1>NUL COPY %filesyswow64% %filesystem32% 2>nul
<nul set /p=[ PASS ]
echo  ^|
goto exit

:fail
color CF
<nul set /p =^< FAIL ^>
echo  ^|

:exit
echo +------------------------------------+
if DEFINED error echo ERROR: %error%
echo.
set /p=Hit ENTER to exit...