@echo off
:unin-1
cd
set MYFILES=%USERPROFILE%\AppData\Local\Temp\afolder
title SuroADB Lite Uninstaller
cls
:unin-2
cls
echo Killing SuroADB processes (1/3)
taskkill /F /IM adb.exe <nul
taskkill /F /IM GetInput.exe <nul
ping localhost -n 3 >nul
:unin-3
cls
echo Deleting associated files (2/3)
DEL /Q "%MYFILES%\adb.exe"
DEL /Q "%MYFILES%\AdbWinApi.dll"
DEL /Q "%MYFILES%\AdbWinUsbApi.dll
DEL /Q "%MYFILES%\batbox.exe"
DEL /Q "%MYFILES%\Box.bat"
DEL /Q "%MYFILES%\Button.bat"
DEL /Q "%MYFILES%\fastboot.exe"
DEL /Q "%MYFILES%\GetInput.exe"
DEL /Q "%MYFILES%\Getlen.bat"
DEL /Q "%MYFILES%\license (suroadb).txt"
DEL /Q "%MYFILES%\license (button).txt"
DEL /Q "%MYFILES%\suroadblite-config.bat"
IF EXIST "%MYFILES%\packages.txt" DEL /Q "%MYFILES%\packages.txt"
IF EXIST "%MYFILES%\devices.txt" DEL /Q "%MYFILES%\devices.txt"
DEL /Q "%MYFILES%\suroadb!lite-readme.txt
RMDIR /S /Q "%USERPROFILE%\AppData\Local\Temp\ytmp"
goto unin-4
:unin-4
cls
echo Checking uninstall status (3/3)
IF EXIST "%MYFILES%\adb.exe" goto fail
IF EXIST "%MYFILES%\AdbWinApi.dll" goto fail
IF EXIST "%MYFILES%\AdbWinUsbApi.dll" goto fail
IF EXIST "%MYFILES%\batbox.exe" goto fail
IF EXIST "%MYFILES%\box.bat" goto fail
IF EXIST "%MYFILES%\Button.bat" goto fail
IF EXIST "%MYFILES%\fastboot.exe" goto fail
IF EXIST "%MYFILES%\GetInput.exe" goto fail
IF EXIST "%MYFILES%\Getlen.bat" goto fail
IF EXIST "%MYFILES%\license (suroadb).txt" goto fail
IF EXIST "%MYFILES%\license (button).txt" goto fail
IF EXIST "%MYFILES%\suroadblite-config.bat" goto fail
IF EXIST "%MYFILES%\packages.txt" goto fail
IF EXIST "%MYFILES%\devices.txt" goto fail
IF EXIST "%MYFILES%\suroadb!lite-readme.txt" goto fail
IF EXIST "%USERPROFILE%\AppData\Local\Temp\ytmp" goto fail-2
goto success

:success
cls
echo SuroADB Lite has been uninstalled succesfully.
echo.
echo Press any key to close.
pause >nul
cls
goto done

:fail
start "%SysRoot%\explorer.exe" "%MYFILES%"
cls
echo One or more files were unsuccesfully deleted.
echo.
echo Please delete remaining files in the temp folder.
echo.
echo Press any key to close.
pause >nul
cls
goto done

:fail-2
start "%SysRoot%\explorer.exe" "%USERPROFILE%\AppData\Local\Temp\ytmp"
cls
echo SuroADB Compiler temp folder unsuccesfully deleted.
echo.
echo "%USERPROFILE%\AppData\Local\Temp\ytmp"
echo.
echo Please close any SuroADB related processes.
echo.
echo Press any key to close.
pause >nul
cls
goto done

:done
cls
DEL /Q uninstaller.bat && exit