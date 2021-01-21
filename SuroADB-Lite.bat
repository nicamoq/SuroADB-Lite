@echo off

mode con: cols=80 lines=25
set ver=2.7
set releaseNumber=9
set sessionid=%random%
title SuroADB Lite %ver%
set MYFILES=%USERPROFILE%\AppData\Local\Temp\afolder

:: Gets the current date, format depends on the current system settings.
for /f "tokens=1-3 delims=/" %%A in ("%DATE%")  do set current-date=%%B-%%A-%%C

cd "%MYFILES%"
IF NOT "%cd%" == "%MYFILES%" goto :cd-error
goto :start-op

:cd-error
cls
color 0F
REM CursorHide
echo.
echo.
echo.
echo.
echo.
echo                     Please execute SuroADB Lite anywhere in %HOMEDRIVE%
echo.
echo.
echo.                     SuroADB Lite cannot run in other drives.
echo.
echo.
echo.
echo                                         :(
pause >nul
exit

:incompleteFiles
cls
color 0F
REM CursorHide
echo.
echo.
echo.
echo.
echo.
echo              One or more files are missing from the working directory.
echo.
echo.
echo.                     Try executing SuroADB-Lite.exe again.
echo.
echo.
echo.
echo                                        :(
pause >nul
exit


:start-op
IF NOT EXIST "%MYFILES%\adb.exe" goto :incompleteFiles
IF NOT EXIST "%MYFILES%\Button.bat" goto :incompleteFiles
IF EXIST "%MYFILES%\suroadblite-config.bat" call "%MYFILES%\suroadblite-config.bat" && goto :DaemonStart
IF NOT EXIST "%MYFILES%\suroadblite-config.bat" goto :create-config
echo Weird.. The logic did not work..
pause
exit

:create-config
(
	echo :: GUI Theme
	echo set themename=Dark
	echo set uicolor=0F
	echo set buttoncolor=8F
	echo set highlightcolor=70
	echo set navcolor=8F
	echo set criticalbutton=4F
	echo.
	echo set texthighlight=F0
	echo set textcritical=0C
	echo.
	echo :: Screenrecord last used
	echo set dur=30
	echo set size=Default
	echo set spath=/sdcard
	echo.
	echo :: ADB settings
	echo set killadbonexit=1
	echo.
	echo :: File push last used
	echo set fpush-restore=0
	echo set fpush-type=
	echo set fpush-apath=
	echo set fpush-bpath=
	echo.
	echo exit /b
) > "%MYFILES%\suroadblite-config.bat"
call "%MYFILES%\suroadblite-config.bat"
goto :DaemonStart

:set-config
(
	echo :: GUI Theme
	echo set themename=%themename%
	echo set uicolor=%uicolor%
	echo set buttoncolor=%buttoncolor%
	echo set highlightcolor=%highlightcolor%
	echo set navcolor=%navcolor%
	echo set criticalbutton=%criticalbutton%
	echo.
	echo set texthighlight=%texthighlight%
	echo set textcritical=%textcritical%
	echo.
	echo :: Screenrecord last used
	echo set dur=%dur%
	echo set size=%size%
	echo set spath=%spath%
	echo.
	echo :: ADB Settings
	echo set killadbonexit=%killadbonexit%
	echo.
	echo :: File push last used
	echo set fpush-restore=%fpush-restore%
	echo set fpush-type=%fpush-type%
	echo set fpush-apath=%fpush-apath%
	echo set fpush-bpath=%fpush-bpath%
	echo.
	echo exit /b
) > "%MYFILES%\suroadblite-config.bat"
call "%MYFILES%\suroadblite-config.bat"
goto :EOF


:DaemonStart
cls
echo [%TIME%] Executing "adb devices"
adb devices
echo [%TIME%] Done.
goto :menu

:getDevices
(
adb devices
) > devices.txt
IF NOT EXIST "%MYFILES%\devices.txt" (set deviceInfo=Unable to get device info.)
for /f %%a in ('findstr /E "device" devices.txt ^| find /c /v ""') do set deviceCount=%%a
if "%deviceCount%" GTR "1" (set deviceInfo=%deviceCount% devices connected. ADB may not work properly.)
if "%deviceCount%" LSS "1" (set deviceInfo=No device connected.)
if "%deviceCount%" EQU "1" (goto :deviceConnected)
goto :EOF

:deviceConnected
set adbdevices=adb devices
cls
for /f %%G IN ('%adbdevices% ^|find "device"') do (set deviceInfo=%%G connected)
goto :EOF

:menu
cls
title SuroADB Lite %ver%
color %uicolor%
call :getDevices
goto :menu-2

:menu-2
cls
batbox /c 0x%uicolor% /d "What would you like to do?  " /c 0x%texthighlight% /d " %deviceInfo% " /c 0x%uicolor% /d ""
goto :menu-buttons

:menu-buttons
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
call Button 2 5 %buttoncolor% "Check for devices" 24 5 %buttoncolor% "Install apk" 40 5 %buttoncolor% "Uninstall app" 58 5 %buttoncolor% "Package list" 2 9 %buttoncolor% "Pull file/folder from device" 35 9 %buttoncolor% "Push file/folder to device" 2 13 %buttoncolor% "Take a screenshot" 24 13 %buttoncolor% "Record screen" 42 13 %criticalbutton% "Power controls" 2 21 %buttoncolor% "Custom mode" 18 21 %buttoncolor% "ADB Shell mode" 37 21 %buttoncolor% "Wifi mode" 55 21 %buttoncolor% "*" 61 21 %buttoncolor% "?" 67 21 %buttoncolor% "@" 73 21 %buttoncolor% "X" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
cls
IF %ERRORLEVEL% == 1 goto :devices
IF %ERRORLEVEL% == 2 goto :install
IF %ERRORLEVEL% == 3 goto :uninstall
IF %ERRORLEVEL% == 4 goto :packages
IF %ERRORLEVEL% == 5 goto :pull
IF %ERRORLEVEL% == 6 goto :push
IF %ERRORLEVEL% == 7 goto :screenshot
IF %ERRORLEVEL% == 8 goto :screenrecord
IF %ERRORLEVEL% == 9 goto :powercontrols
IF %ERRORLEVEL% == 10 goto :custom
IF %ERRORLEVEL% == 11 goto :shell
IF %ERRORLEVEL% == 12 goto :wifi
IF %ERRORLEVEL% == 13 goto :settings
IF %ERRORLEVEL% == 14 start "%SysRoot%\notepad.exe" "%MYFILES%\suroadb!lite-readme.txt"
IF %ERRORLEVEL% == 15 goto :DaemonStart
IF %ERRORLEVEL% == 16 goto :exitpr
goto menu

:devices
cls
color %uicolor%
adb devices
call Button 2 17 %buttoncolor% "Cannot find your device?" 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL% == 1 start https://github.com/nicamoq/SuroADB-Lite/wiki
IF %ERRORLEVEL% == 2 goto :menu
IF %ERRORLEVEL% == 3 goto :devices
goto :devices


:install
cls
color %uicolor%
echo Select the APK for install. If errors occur, try renaming short and without spaces.
rem BrowseFiles
cls
IF %result% == "0" goto :menu
color %uicolor%
batbox /c 0x%uicolor% /d "Selected : " /c 0x%texthighlight% /d "%result%" /c 0x%uicolor% /d " "
echo.
echo Installing ...
echo.
adb install "%result%"
call Button 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL% == 1 goto menu
IF %ERRORLEVEL% == 2 goto install
goto install

:uninstall
cls
color %uicolor%
echo Enter the package name to uninstall the app associated with it.
batbox /c 0x%uicolor% /d "Example: " /c 0x%texthighlight% /d "com.facebook.katana"
echo.
echo.
batbox /c 0x%uicolor% /d "Enter " /c 0x%texthighlight% /d "MENU" /c 0x%uicolor% /d " to go back.
:unin
echo.
echo.
set /p un= : 
IF /i "%un%"=="MENU" goto menu
adb uninstall "%un%"
call Button 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL%==1 goto menu
IF %ERRORLEVEL%==2 goto uninstall
goto uninstall

:packages
cls
color %uicolor%
(
	adb shell pm list packages
) > "%MYFILES%\packages.txt"
cls
start "%SysRoot%\notepad.exe" "%MYFILES%\packages.txt"
batbox /c 0x%uicolor% /d "Package list saved to " /c 0x%texthighlight% /d " %MYFILES%\packages.txt "
call Button 2 17 %buttoncolor% "Export to custom path" 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL% == 1 goto :package-2
IF %ERRORLEVEL% == 2 goto :menu
IF %ERRORLEVEL% == 3 goto :packages
goto packages

:package-2
color %uicolor%
set sessionid=%random%
cls
echo Where to save?
REM BrowseFolder
IF "%result%" == "0" goto menu
(
	adb shell pm list packages
) > "%result%\ADBPKG-%current-date%-%sessionid%.txt"
start "%SysRoot%\notepad.exe" "%result%\ADBPKG-%current-date%-%sessionid%.txt"
goto menu

:pull
cls
color %uicolor%
echo Enter the path to the file/folder that you want to copy to your computer.
echo.
echo ex. /sdcard/video.mp4
echo.
batbox /c 0x%uicolor% /d "Enter " /c 0x%texthighlight% /d " MENU " /c 0x%uicolor% /d " to go back to menu."
echo.
echo.
set /p pullf= : 
cls
IF /i "%pullf%" == "MENU" goto :menu
cls
echo Select the folder where "%pullf%" will be copied to.
rem BrowseFolder
IF "%result%" == "0" goto :menu
echo Copying : %pullf%
echo To : %result%
echo.
adb pull "%pullf%" "%result%"

call Button 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL% == 1 goto :menu
IF %ERRORLEVEL% == 2 goto :pull
goto pull


:push
set restore-status=echo.
IF %fpush-restore% == 1 (set restore-status=echo Last used: %fpush-apath% to %fpush-bpath%)
:push-2
cls
color %uicolor%
echo What would you like to copy to your device?
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
%restore-status%
call Button 5 5 %buttoncolor% "          FILE          " 45 5 %buttoncolor% "          FOLDER         " 26 10 %buttoncolor% " RESTORE LAST SESSION " 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL% == 1 goto :push-file
IF %ERRORLEVEL% == 2 goto :push-folder
IF %ERRORLEVEL% == 3 goto :push-restore
IF %ERRORLEVEL% == 4 goto :menu
IF %ERRORLEVEL% == 5 goto :push
goto :push

:push-restore
cls
IF %fpush-restore% == 0 (set restore-status=batbox /c 0x%uicolor% /d "                            " /c 0x%texthighlight% /d " No previous session ") && (goto :push-2)
set result=%fpush-apath%
set pushf=%fpush-bpath%
IF %fpush-type% == file (goto :push-file3) ELSE (goto :pushffo-2)
goto :push



:push-file
cls
color %uicolor%
echo Select the file
:pushf33
rem BrowseFiles
IF %result% == 0 goto :push
set fpush-apath=%result%
call :set-config

goto :push-file2
:push-file2
cls
echo Selected: %result%
echo.
echo Enter the path to where the folder should go.
echo ex. /sdcard/files
echo.
set /p pushf= : 
cls
set fpush-bpath=%pushf%
call :set-config
goto :push-file3

:push-file3
color %uicolor%
cls
echo Copying: %result%
echo To: %pushf%
echo.
adb push %result% "%pushf%"
set fpush-restore=1
set fpush-type=file
call :set-config
call Button 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL% == 1 goto :menu
IF %ERRORLEVEL% == 2 goto :push-file
goto :menu

:push-folder
color %uicolor%
cls
set pushff1=folder
echo Select the folder.
echo.
rem BrowseFolder
IF "%result%" == "0" goto :push
set fpush-apath=%result%
call :set-config
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
set fpush-bpath=%pushf%
call :set-config
goto :pushffo-2

:pushffo-2
color %uicolor%
cls
echo Copying : %result%
echo To : %pushf%
echo.
adb push "%result%" "%pushf%"
set fpush-restore=1
set fpush-type=folder
call :set-config
call Button 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL% == 1 goto :menu
IF %ERRORLEVEL% == 2 goto :push-folder
goto :menu

:screenshot
cls
color %uicolor%
set sessionid=%random%
echo [%TIME%] Saving screenshot (%current-date%-%sessionid%) to /sdcard
adb shell screencap "/sdcard/ADBSC-%current-date%-%sessionid%.png"
echo [%TIME%] Copying to %USERPROFILE%\Desktop
adb pull "/sdcard/ADBSC-%current-date%-%sessionid%.png" "%USERPROFILE%\Desktop"
IF EXIST "%USERPROFILE%\Desktop\ADBSC-%current-date%-%sessionid%.png" start "%SysRoot%\explorer.exe" "%USERPROFILE%\Desktop\ADBSC-%current-date%-%sessionid%.png"
cls
goto menu



:screenrecord
cls
color %uicolor%
batbox /c 0x%uicolor% /d "Screenrecord settings" /c 0x%uicolor% /d "   " /c 0xF /d " Duration: " /c 0x%texthighlight% /d "%dur%" /c 0xF /d " Size: " /c 0x%texthighlight% /d "%size%" /c 0xF /d " Save path: " /c 0x%texthighlight% /d "%spath%" /c 0xF /d " " /c 0x%uicolor% /d " "
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
call Button 3 5 %buttoncolor% "10" 11 5 %buttoncolor% "30" 19 5 %buttoncolor% "1 Minute" 33 5 %buttoncolor% "2 Minutes" 48 5 %buttoncolor% "3 Minutes (Maximum)" 73 5 %criticalbutton% "*" 3 11 %buttoncolor% "Device default" 23 11 %buttoncolor% "480x800" 36 11 %buttoncolor% "720x1280" 50 11 %buttoncolor% "1080x1920" 3 17 %buttoncolor% "/sdcard" 16 17 %criticalbutton% "*" 60 17 A0 "START RECORDING" 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%

cls

:duration-button
IF %ERRORLEVEL% == 1 set dur=10
IF %ERRORLEVEL% == 2 set dur=30
IF %ERRORLEVEL% == 3 set dur=60
IF %ERRORLEVEL% == 4 set dur=120
IF %ERRORLEVEL% == 5 set dur=180
IF %ERRORLEVEL% == 6 goto :duration-button-configure

:resolution-button
IF %ERRORLEVEL% == 7 set size=Default
IF %ERRORLEVEL% == 8 set size=480x800
IF %ERRORLEVEL% == 9 set size=720x1280
IF %ERRORLEVEL% == 10 set size=1080x1920

:spath
IF %ERRORLEVEL% == 11 set spath=/sdcard
IF %ERRORLEVEL% == 12 goto :spath-configure

:sr-ui-buttons
IF %ERRORLEVEL% == 13 goto :screenrecord-start
IF %ERRORLEVEL% == 14 goto :menu
IF %ERRORLEVEL% == 15 goto :screenrecord
call :set-config
goto :screenrecord

:duration-button-configure
color %uicolor%
cls
echo Enter the number of seconds the screen recording will go for
echo Note: Maximum of 180 Seconds, or 3 Minutes.
echo.
batbox /c 0x%uicolor% /d "Enter " /c 0x%texthighlight% /d " MENU " /c 0x%uicolor% /d " to go back to screenrecord settings."
echo.
echo.
echo. %duration-prompt%
echo.
set /p durp= : 
IF /i "%durp%" == "menu" goto :screenrecord
IF /I %durp% LSS 1 (set duration-prompt=Please input a valid number!) && (goto :duration-button-configure)
IF /I %durp% GTR 180 (set duration-prompt=Please input a valid number!) && (goto :duration-button-configure)
IF /I %durp% LEQ 180 (set dur=%durp%) && (call :set-config) && (goto :screenrecord)
set duration-prompt=Please input a valid number!
goto :duration-button-configure


:spath-configure
color %uicolor%
cls
echo Enter the path where the screen recording should go
echo ex. /sdcard/videos
echo.
batbox /c 0x%uicolor% /d "Enter " /c 0x%texthighlight% /d " MENU " /c 0x%uicolor% /d " to go back to screenrecord settings."
echo.
echo.
set /p spathui= : 
IF /i "%spathui%" == "menu" goto :screenrecord
set spath=%spathui%
call :set-config
cls
goto :screenrecord

:screenrecord-start
cls
set sessionid=%random%
IF "%size%" == "Default" (goto :screenrecord-default) else (goto :screenrecord-custom)

:screenrecord-default
color %uicolor%
cls
echo Recording the screen for %dur% seconds. Press CTRL+C to stop.
echo File will be saved to %spath%/ADBSR-%current-date%-%sessionid%.mp4
adb shell screenrecord --time-limit %dur% --verbose "%spath%/ADBSR-%current-date%-%sessionid%.mp4"
call Button 2 17 %buttoncolor% "Pull video from device" 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL% == 1 goto :screenrecord-pull
IF %ERRORLEVEL% == 2 goto :menu
IF %ERRORLEVEL% == 3 goto :screenrecord
goto menu

:screenrecord-custom
color %uicolor%
cls
echo [%TIME%] Recording the screen for %dur% seconds. Press CTRL+C to stop.
echo File will be saved to %spath%/ADBSR-%current-date%-%sessionid%.mp4
adb shell screenrecord --size %size% --time-limit %dur% --verbose "%spath%/ADBSR-%current-date%-%sessionid%.mp4"
call Button 2 17 %buttoncolor% "Pull video from device" 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL% == 1 goto :screenrecord-pull
IF %ERRORLEVEL% == 2 goto :menu
IF %ERRORLEVEL% == 3 goto :screenrecord
goto menu

:screenrecord-pull
color %uicolor%
cls
echo Where to save?
REM BrowseFolder
cls
IF "%result%" == "0" goto :menu
adb pull "%spath%/ADBSR-%current-date%-%sessionid%.mp4" "%result%"
start "%SysRoot%\explorer.exe" "%result%\ADBSR-%current-date%-%sessionid%.mp4"
goto menu

:powercontrols
color %uicolor%
cls
echo Power controls
echo.
echo.
echo.
echo  Choose an option :
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
batbox /c 0x%uicolor% /d "  " /c 0x%textcritical% /d "Be careful! These will execute instantly upon input."
call Button 3 6 %buttoncolor% "Shutdown" 17 6 %buttoncolor% "Reboot" 29 6 %criticalbutton% "Recovery" 43 6 %criticalbutton% "Bootloader" 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL% == 1 adb shell reboot -p
IF %ERRORLEVEL% == 2 adb shell reboot
IF %ERRORLEVEL% == 3 adb shell reboot recovery
IF %ERRORLEVEL% == 4 adb shell reboot bootloader
IF %ERRORLEVEL% == 5 goto :menu
IF %ERRORLEVEL% == 6 goto :powercontrols
goto powercontrols


:custom
color %uicolor%
title SuroADB Lite %ver% : Custom mode
batbox /c 0x%uicolor% /d "Enter " /c 0x%texthighlight% /d " goto :menu " /c 0x%uicolor% /d " to go back to menu."
echo.
echo.
:custom-loop
echo.
set /p sndbx=Enter a command : 
echo.
%sndbx%
goto :custom-loop


:shell
color %uicolor%
cls
title SuroADB Lite %ver% : ADB shell mode
adb shell
goto shell

:wifi
call :getDevices
if "%deviceCount%" GTR "1" (set wifiInfo=There are %deviceCount% devices connected. Please connect only one via USB, then click "@".) && (goto :wifi-invalid)
if "%deviceCount%" LSS "1" (set wifiInfo=There are no devices connected. Connect a device via USB then click "@".) && (goto :wifi-invalid)
if "%deviceCount%" EQU "1" (goto :wifi-3)

:wifi-invalid
cls
echo %wifiInfo%
call Button 2 17 %buttoncolor% "Cannot find your device?" 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL% == 1 start https://github.com/nicamoq/SuroADB-Lite/wiki
IF %ERRORLEVEL% == 2 goto :menu
IF %ERRORLEVEL% == 3 goto :wifi
goto :wifi


:wifi-3
color %uicolor%
cls
echo [%TIME%] Executing "adb tcpip 5555"
adb tcpip 5555
echo [%TIME%] Done. Please disconnect your device from the USB cable.
echo.
echo Enter your device's IP Address.
echo.
set /p deviceip= : 
echo.
echo [%TIME%] Executing "adb connect %deviceip%:5555"
adb connect %deviceip%:5555
echo [%TIME%] Done.
echo [%TIME%] Executing "adb devices"
adb devices
echo [%TIME%] Done.
echo [%TIME%] If you encounter problems, click the " @ " button to try again.
echo.
call Button 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL% == 1 goto :menu
IF %ERRORLEVEL% == 2 goto :wifi-re
:wifi-re
color %uicolor%
cls
echo [%TIME%] Executing "adb kill-server"
adb kill-server
echo [%TIME%] Done.
echo [%TIME%] Executing "adb devices"
adb devices
echo [%TIME%] Done.
goto :wifi-3


:settings
IF "%themename%" == "Dark" (set darktoggle=/) else (set darktoggle=O)
IF "%killadbonexit%" == "1" (set adbkilltoggle=/) else (set adbkilltoggle=O)
cls
color %uicolor%
echo SuroADB Settings
echo.
echo.
echo  Main settings:
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
echo  SuroADB:
call Button 2 5 %buttoncolor% "(%darktoggle%) Dark mode" 21 5 %buttoncolor% "(%adbkilltoggle%) Kill ADB on exit" 2 17 %buttoncolor% "View SuroADB on Github" 30 17 %buttoncolor% "TEMP folder" 47 17 %criticalbutton% "Uninstall SuroADB Lite" 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL% == 1 goto :dark-mode
IF %ERRORLEVEL% == 2 goto :adb-kill
IF %ERRORLEVEL% == 3 start https://github.com/nicamoq/SuroADB-Lite
IF %ERRORLEVEL% == 4 start "%SysRoot%\explorer.exe" "%MYFILES%"
IF %ERRORLEVEL% == 5 goto :unin-1
IF %ERRORLEVEL% == 6 goto :menu
IF %ERRORLEVEL% == 7 goto :settings
goto settings


:dark-mode
IF "%themename%" == "Dark" (goto :default-mode-default) else (goto :dark-mode-dark)

:default-mode-default
cls
set themename=Default
set uicolor=3F
set buttoncolor=F3
set highlightcolor=3F
set navcolor=FC
set criticalbutton=4F
set texthighlight=F3
set textcritical=0C
call :set-config
goto :settings
:dark-mode-dark
cls
set themename=Dark
set uicolor=0F
set buttoncolor=8F
set highlightcolor=70
set navcolor=8F
set texthighlight=F0
set textcritical=0C
call :set-config
goto :settings

:adb-kill
IF "%killadbonexit%" == "1" (set killadbonexit=0) else (set killadbonexit=1)
call :set-config
goto :settings


:unin-1
cls
start "%SysRoot%\cmd.exe" "%MYFILES%\uninstaller.bat"
exit

:exitpr
title Exiting ...
IF "%killadbonexit%" == "1" (taskkill /F /IM adb.exe) else (exit)
cls
exit


