@echo off

mode con: cols=80 lines=25
set ver=2.6
set releaseNumber=8
set sessionid=%random%
title SuroADB Lite %ver%
set MYFILES=%USERPROFILE%\AppData\Local\Temp\afolder
cd "%MYFILES%"
IF NOT "%cd%" == "%MYFILES%" goto :cd-error
goto :start-op

:cd-error
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

:start-op
IF EXIST "%MYFILES%\suroadblite-config.bat" (call "%MYFILES%\suroadblite-config.bat" && goto :DaemonStart) else (goto :create-config)

:create-config
(
	echo :: GUI Theme
	echo set themename=Default
	echo set uicolor=3F
	echo set buttoncolor=F3
	echo set highlightcolor=3F
	echo set navcolor=FC
	echo set criticalbutton=4F
	echo.
	echo set texthighlight=F3
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

:menu
cls
echo What would you like to do?
goto :menubuttons

:menubuttons
color %uicolor%
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
call Button 2 5 %buttoncolor% "Check for devices" 24 5 %buttoncolor% "Install apk" 40 5 %buttoncolor% "Uninstall app" 58 5 %buttoncolor% "Package list" 2 9 %buttoncolor% "Pull file/folder from device" 35 9 %buttoncolor% "Push file/folder to device" 2 13 %buttoncolor% "Take a screenshot" 24 13 %buttoncolor% "Record screen" 43 13 %criticalbutton% "Power controls" 2 21 %buttoncolor% "Custom mode" 18 21 %buttoncolor% "ADB Shell mode" 37 21 %buttoncolor% "Wifi mode" 55 21 %buttoncolor% "*" 61 21 %buttoncolor% "?" 67 21 %buttoncolor% "@" 73 21 %buttoncolor% "X" X _Box _hover
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
IF %ERRORLEVEL% == 15 goto :start-op
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
IF "%result%" == "0" goto :menu
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
) > "%result%\adbpackagelist-%sessionid%.txt"
start "%SysRoot%\notepad.exe" "%result%\adbpackagelist-%sessionid%.txt"
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
cls
color %uicolor%
echo What would you like to copy?
call Button 5 5 %buttoncolor% "          FILE          " 45 5 %buttoncolor% "          FOLDER         " 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL% == 1 goto :push-file
IF %ERRORLEVEL% == 2 goto :push-folder
IF %ERRORLEVEL% == 3 goto :menu
IF %ERRORLEVEL% == 4 goto :push
goto :push
:push-file
cls
color %uicolor%
echo Select the file
:pushf33
rem BrowseFiles
IF %result% == "0" goto :push
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
goto :push-file3
:push-file3
cls
echo Copying: %result%
echo To: %pushf%
echo.
adb push %result% "%pushf%"
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
call Button 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL% == 1 goto :menu
IF %ERRORLEVEL% == 2 goto :push-folder
goto :menu

:screenshot
cls
color %uicolor%
set sessionid=%random%
echo [%TIME%] Saving screenshot to /sdcard
adb shell screencap "/sdcard/adbscreenshot-%sessionid%.png"
echo [%TIME%] Copying to %USERPROFILE%\Desktop
adb pull "/sdcard/adbscreenshot-%sessionid%.png" "%USERPROFILE%\Desktop"
IF EXIST "%USERPROFILE%\Desktop\adbscreenshot-%sessionid%.png" start "%SysRoot%\explorer.exe" "%USERPROFILE%\Desktop\adbscreenshot-%sessionid%.png"
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
call Button 3 5 %buttoncolor% "10" 11 5 %buttoncolor% "30" 19 5 %buttoncolor% "1 Minute" 33 5 %buttoncolor% "2 Minutes" 48 5 %buttoncolor% "3 Minutes (Maximum)" 3 11 %buttoncolor% "Device default" 23 11 %buttoncolor% "480x800" 36 11 %buttoncolor% "720x1280" 50 11 %buttoncolor% "1080x1920" 3 17 %buttoncolor% "/sdcard" 16 17 %criticalbutton% "Configure" 60 17 A0 "START RECORDING" 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%

cls

:duration-button
IF %ERRORLEVEL% == 1 set dur=10
IF %ERRORLEVEL% == 2 set dur=30
IF %ERRORLEVEL% == 3 set dur=60
IF %ERRORLEVEL% == 4 set dur=120
IF %ERRORLEVEL% == 5 set dur=180

:resolution-button
IF %ERRORLEVEL% == 6 set size=Default
IF %ERRORLEVEL% == 7 set size=480x800
IF %ERRORLEVEL% == 8 set size=720x1280
IF %ERRORLEVEL% == 9 set size=1080x1920

:spath
IF %ERRORLEVEL% == 10 set spath=/sdcard
IF %ERRORLEVEL% == 11 goto :spath-configure

:sr-ui-buttons
IF %ERRORLEVEL% == 12 goto :screenrecord-start
IF %ERRORLEVEL% == 13 goto :menu
IF %ERRORLEVEL% == 14 goto :screenrecord
call :set-config
goto :screenrecord

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
echo File will be saved to %spath%/adbscr-%sessionid%.mp4
adb shell screenrecord --time-limit %dur% --verbose "%spath%/adbscr-%sessionid%.mp4"
call Button 2 17 %buttoncolor% "Pull video from device" 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL% == 1 goto screenrecord-pull
IF %ERRORLEVEL% == 2 goto menu
IF %ERRORLEVEL% == 3 goto screenrecord
goto menu

:screenrecord-custom
color %uicolor%
cls
echo [%TIME%] Recording the screen for %dur% seconds. Press CTRL+C to stop.
echo File will be saved to %spath%/adbscr-%sessionid%.mp4
adb shell screenrecord --size %size% --time-limit %dur% --verbose "%spath%/adbscr-%sessionid%.mp4"
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
adb pull "%spath%/adbscr-%sessionid%.mp4" "%result%"
start "%SysRoot%\explorer.exe" "%result%\adbscr-%sessionid%.mp4"
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
batbox /c 0x%uicolor% /d "  " /c 0x%textcritical% /d "Warning: These will execute instantly upon clicking!"
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
set wfmsg=echo.
:wifi-2
color %uicolor%
cls
adb devices
echo.
echo.
echo.
echo.
echo.
echo                     Do you see your device in the list above?
echo.
echo.
echo.
echo.
echo.
echo.
echo                    Please ensure only one device is attached.
echo.
echo.
%wfmsg%
echo.
echo.
echo.
echo.
call Button 24 10 %buttoncolor% "    YES    " 42 10 %buttoncolor% "    NO    " 2 21 %navcolor% "                               Back                               " 74 21 %buttoncolor% "@" X _Box _hover
GetInput /M %_Box% /H %highlightcolor%
IF %ERRORLEVEL% == 1 goto :wifi-3
IF %ERRORLEVEL% == 2 set wfmsg=batbox /c 0x%uicolor% /d "                    " /c 0x%texthighlight% /d "You need one device attached to continue." /c 0x%uicolor% /d " "
IF %ERRORLEVEL% == 3 goto :menu
IF %ERRORLEVEL% == 4 goto :wifi
goto :wifi-2
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


