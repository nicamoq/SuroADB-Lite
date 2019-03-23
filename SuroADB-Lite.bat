@echo off

:start
set MYFILES=%USERPROFILE%\AppData\Local\Temp\afolder
cd "%MYFILES%"
set ver=2.0
title SuroADB Lite %ver%
color 3F
set bcol=F3
set hcolor=3F
set uicol=3F

:: counters
set entries=0
set trost=0
set sessionid=%random%
set exports=0
:: color
set diode=3f
:: logging
set logst=ON
:: custom startup
set startupcmd=menu
:: configs
set sdconfig=/sdcard
set exsdconfig=NOT_SET
:: wifi mode
set deviceip=NOT_SET

:: (PATH VARIABLES)
:: working directory
set wdre=%MYFILES%
set audir=%MYFILES%\SuroADB
set tempdir=%MYFILES%\sroadbtemp
:: for apk install
set instal=%tempdir%\Apk
:: for package list
set exportpackage=no
:: for file push and pullf
set pullf=/sdcard
set pushf=/sdcard

:: for screenrecord
set dur=30
set size=Default
set spath=/sdcard


rem CursorHide

:daemon
cls
adb devices

:menu
cls
echo What would you like to do?
goto menubuttons

:menubuttons
color %uicol%
echo.
echo.
echo  ADB Commands :
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo  Advanced :
call Button 3 5 %bcol% "Check for devices" 26 5 %bcol% "Install apk" 43 5 %bcol% "Uninstall app" 62 5 %bcol% "Package list" 3 9 %bcol% "Pull file/folder from device" 37 9 %bcol% "Push file/folder to device" 3 13 %bcol% "Take a screenshot" 26 13 %bcol% "Record screen" 45 13 4F "Power controls" 3 21 %bcol% "Custom mode" 20 21 %bcol% "ADB Shell mode" 62 21 %bcol% "?" 68 21 %bcol% "@" 74 21 %bcol% "X" X _Box _hover
GetInput /M %_Box% /H %hcolor%
cls
IF %ERRORLEVEL%==1 goto devices
IF %ERRORLEVEL%==2 goto install
IF %ERRORLEVEL%==3 goto uninstall
IF %ERRORLEVEL%==4 goto packages
IF %ERRORLEVEL%==5 goto pull
IF %ERRORLEVEL%==6 goto push
IF %ERRORLEVEL%==7 goto screenshot
IF %ERRORLEVEL%==8 goto screenrecord
IF %ERRORLEVEL%==9 goto powercontrols
IF %ERRORLEVEL%==10 goto custom
IF %ERRORLEVEL%==11 goto shell
IF %ERRORLEVEL%==12 start "%SysRoot%\notepad.exe" "%MYFILES%\suroadb!lite-readme.txt"
IF %ERRORLEVEL%==13 goto start
IF %ERRORLEVEL%==14 goto exitpr
goto menu

:devices
cls
color %uicol%
adb devices
call Button 2 21 FC "                               Back                               " 74 21 %bcol% "@" X _Box _hover
GetInput /M %_Box% /H 4F
IF %ERRORLEVEL%==1 goto menu
IF %ERRORLEVEL%==2 goto devices

:install
cls
color %uicol%
echo Select the APK for install. Make sure the file name does not contain any spaces.
rem BrowseFiles
IF "%result%"=="0" goto menu

call :pkgt %result%
exit /b

:pkgt
set pkgname=%~nx1

call :pkgv %result%
exit /b

:pkgv
set pkgex=%~x1

IF NOT %pkgex%==.apk echo Error: File is not an APK!

echo Selected : %pkgname%
echo Installing ...
adb install "%result%"

call Button 2 21 FC "                               Back                               " 74 21 %bcol% "@" X _Box _hover
GetInput /M %_Box% /H 4F
IF %ERRORLEVEL%==1 goto menu
IF %ERRORLEVEL%==2 goto install
goto install

:uninstall
cls
color %uicol%
echo Enter the package name
echo ex. com.facebook.katana
echo.
echo Enter MENU to go back.
:unin
echo.
set /p un= : 
IF /i "%un%"=="MENU" goto menu
adb uninstall %un%
call Button 2 21 FC "                               Back                               " 74 21 %bcol% "@" X _Box _hover
GetInput /M %_Box% /H 4F
IF %ERRORLEVEL%==1 goto menu
IF %ERRORLEVEL%==2 goto uninstall
goto uninstall

:packages
cls
color %uicol%
(
adb shell pm list packages
) > "%MYFILES%\packages.txt"
cls
start "%SysRoot%\notepad.exe" "%MYFILES%\packages.txt"
echo Package list saved to "%MYFILES%\packages.txt"
call Button 2 17 %bcol% "Export to text file" 2 21 FC "                               Back                               " 74 21 %bcol% "@" X _Box _hover
GetInput /M %_Box% /H 4F
IF %ERRORLEVEL%==1 goto package-2
IF %ERRORLEVEL%==2 goto menu
IF %ERRORLEVEL%==3 goto packages
goto packages
:package-2
color %uicol%
set sessionid=%random%
cls
echo Where to save?
REM BrowseFolder
IF "%result%"=="0" goto menu
(
adb shell pm list packages
) > "%result%\adbpackagelist-%sessionid%.txt"
start "%SysRoot%\notepad.exe" "%result%\adbpackagelist-%sessionid%.txt"
goto menu

:pull
cls
color %uicol%
echo Enter the path to the file/folder that you want to copy to your computer.
echo.
echo ex. /sdcard/video.mp4
echo.
echo Enter menu to go back to menu.
echo.
set /p pullf= : 
cls
IF /i "%pullf%"=="MENU" goto menu
cls
echo Select the folder where "%pullf%" will be copied to.
rem BrowseFolder
IF "%result%"=="0" goto menu
echo Copying : %pullf%
echo To : %result%
echo.
adb pull "%pullf%" "%result%"

call Button 2 21 FC "                               Back                               " 74 21 %bcol% "@" X _Box _hover
GetInput /M %_Box% /H 4F
IF %ERRORLEVEL%==1 goto menu
IF %ERRORLEVEL%==2 goto pull
goto pull


:push
cls
color %uicol%
echo What would you like to copy?
call Button 5 5 %bcol% "          FILE          " 45 5 %bcol% "          FOLDER         " 2 21 FC "                               Back                               " 74 21 %bcol% "@" X _Box _hover
GetInput /M %_Box% /H 4F
IF %ERRORLEVEL%==1 goto push-file
IF %ERRORLEVEL%==2 goto push-folder
IF %ERRORLEVEL%==3 goto menu
IF %ERRORLEVEL%==4 goto push
goto push
:push-file
cls
color %uicol%
echo Select the file
:pushf33
rem BrowseFiles
IF %result%=="0" goto menu
goto push-file2
:push-file2
cls
echo Selected: %result%
echo.
echo Enter the path to where the folder should go.
echo ex. /sdcard/files
echo.
set /p pushf= : 
cls
goto push-file3
:push-file3
cls
echo Copying: %result%
echo To: %pushf%
echo.
adb push "%result%" "%pushf%"
call Button 2 21 FC "                               Back                               " 74 21 %bcol% "@" X _Box _hover
GetInput /M %_Box% /H 4F
IF %ERRORLEVEL%==1 goto menu
IF %ERRORLEVEL%==2 goto push-file

:push-folder
color %uicol%
cls
set pushff1=folder
echo Select the folder.
echo.
rem BrowseFolder
IF "%result%"=="0" goto menu
goto pushffo

:: FOLDER PUSH
:pushffo
cls
echo Selected : %result%
echo.
echo Enter the path to where the folder should go.
echo ex. /sdcard/folders
echo.
set /p pushf= : 
cls
echo Copying : %result%
echo To : %pushf%
echo.
adb push "%result%" "%pushf%"
call Button 2 21 FC "                               Back                               " 74 21 %bcol% "@" X _Box _hover
GetInput /M %_Box% /H 4F
IF %ERRORLEVEL%==1 goto menu
IF %ERRORLEVEL%==2 goto push-folder
goto push-folder

:screenshot
cls
color %uicol%
set sessionid=%random%
echo Saving screenshot to /sdcard ...
adb shell screencap "/sdcard/adbscreenshot-%sessionid%.png"
echo Copying to %USERPROFILE%\Desktop ...
adb pull "/sdcard/adbscreenshot-%sessionid%.png" "%USERPROFILE%\Desktop"
IF EXIST "%USERPROFILE%\Desktop\adbscreenshot-%sessionid%.png" start "%SysRoot%\explorer.exe" "%USERPROFILE%\Desktop\adbscreenshot-%sessionid%.png"
cls
goto menu



:screenrecord
cls
color %uicol%
batbox /c 0x3F /d "Screenrecord settings" /c 0x3F /d "   " /c 0xF /d " Duration: " /c 0xF3 /d "%dur%" /c 0xF /d " Size: " /c 0xF3 /d "%size%" /c 0xF /d " Save path: " /c 0xF3 /d "%spath%" /c 0xf /d " " /c 0x3F
echo.
echo.
echo.
echo  Duration (seconds) :
echo.
echo.
echo.
echo.
echo.
echo  Resolution : 
echo.
echo.
echo.
echo.
echo.
echo  Save path : 
echo.
echo.
echo.
echo.
call Button 3 5 %bcol% "10" 11 5 %bcol% "30" 19 5 %bcol% "1 Minute" 33 5 %bcol% "2 Minutes" 48 5 %bcol% "3 Minutes (Maximum)" 3 11 %bcol% "Device default" 23 11 %bcol% "480x800" 36 11 %bcol% "720x1280" 50 11 %bcol% "1080x1920" 3 17 %bcol% "/sdcard" 16 17 F4 "Configure" 60 17 A0 "START RECORDING" 2 21 FC "                               Back                               " 74 21 %bcol% "@" X _Box _hover
GetInput /M %_Box% /H %hcolor%

cls

:duration-button
IF %ERRORLEVEL%==1 set dur=10
IF %ERRORLEVEL%==2 set dur=30
IF %ERRORLEVEL%==3 set dur=60
IF %ERRORLEVEL%==4 set dur=120
IF %ERRORLEVEL%==5 set dur=180

:resolution-button
IF %ERRORLEVEL%==6 set size=Default
IF %ERRORLEVEL%==7 set size=480x800
IF %ERRORLEVEL%==8 set size=720x1280
IF %ERRORLEVEL%==9 set size=1080x1920

:spath
IF %ERRORLEVEL%==10 set spath=/sdcard
IF %ERRORLEVEL%==11 goto spath-configure

:sr-ui-buttons
IF %ERRORLEVEL%==12 goto screenrecord-start
IF %ERRORLEVEL%==13 goto menu
IF %ERRORLEVEL%==14 goto screenrecord
goto screenrecord

:spath-configure
color %uicol%
cls
echo Enter the path where the screen recording should go (avoid spaces!)
echo ex. /sdcard/videos
echo.
echo.
set /p spathui= : 
IF "%spathui%"=="menu" goto screenrecord
set spath=%spathui%
cls
goto screenrecord

:screenrecord-start
cls
set sessionid=%random%
IF %size%==Default goto screenrecord-default
goto screenrecord-custom

:screenrecord-default
color %uicol%
cls
echo Recording the screen for %dur% seconds. Press CTRL+C to stop.
echo File will be saved to %spath%/adbscr-%sessionid%.mp4
adb shell screenrecord --time-limit %dur% --verbose "%spath%/adbscr-%sessionid%.mp4"
call Button 2 17 %bcol% "Pull video from device" 2 21 FC "                               Back                               " 74 21 %bcol% "@" X _Box _hover
GetInput /M %_Box% /H 4F
IF %ERRORLEVEL%==1 goto screenrecord-pull
IF %ERRORLEVEL%==2 goto menu
IF %ERRORLEVEL%==3 goto screenrecord

:screenrecord-custom
color %uicol%
cls
echo Recording the screen for %dur% seconds. Press CTRL+C to stop.
echo File will be saved to %spath%/adbscr-%sessionid%.mp4
adb shell screenrecord --size %size% --time-limit %dur% --verbose "%spath%/adbscr-%sessionid%.mp4"
call Button 2 17 %bcol% "Pull video from device" 2 21 FC "                               Back                               " 74 21 %bcol% "@" X _Box _hover
GetInput /M %_Box% /H 4F
IF %ERRORLEVEL%==1 goto screenrecord-pull
IF %ERRORLEVEL%==2 goto menu
IF %ERRORLEVEL%==3 goto screenrecord


:screenrecord-pull
color %uicol%
cls
echo Where to save?
REM BrowseFolder
cls
IF "%result%"=="0" goto menu
adb pull "%spath%/adbscr-%sessionid%.mp4" "%result%"
start "%SysRoot%\explorer.exe" "%result%\adbscr-%sessionid%.mp4"
goto menu

:powercontrols
color %uicol%
cls
echo Power controls
echo.
echo.
echo.
echo  Choose an option :
call Button 3 6 %bcol% "Shutdown" 17 6 %bcol% "Reboot" 29 6 F4 "Recovery" 43 6 F4 "Bootloader" 2 21 FC "                               Back                               " 74 21 %bcol% "@" X _Box _hover
GetInput /M %_Box% /H 3F
IF %ERRORLEVEL%==1 adb shell reboot -p
IF %ERRORLEVEL%==2 adb shell reboot
IF %ERRORLEVEL%==3 adb shell reboot recovery
IF %ERRORLEVEL%==4 adb shell reboot bootloader
IF %ERRORLEVEL%==5 goto menu
IF %ERRORLEVEL%==6 goto powercontrols
goto powercontrols






:custom
title SuroADB Lite %ver% : custom mode
color %uicol%
set /p sndbx=Enter a command : 
echo.
%sndbx%
goto custom


:shell
color %uicol%
cls
title SuroADB Lite %version% : adb shell mode
adb shell
goto shell


:exitpr
cls
exit


