@echo off


REM ---------------------------------------------------------------------------------------------------------
REM	Set input params - %~dp0 returns working path
REM ---------------------------------------------------------------------------------------------------------

set video=%~dp0%1
set audio=%~dp0%2
set output=%~dp0%3

REM ---------------------------------------------------------------------------------------------------------
REM	Check input
REM ---------------------------------------------------------------------------------------------------------

if [%1] == [] goto wrongparam
if [%2] == [] goto wrongparam
if [%3] == [] goto createoutputfolder

:checkinput
if not exist %video% goto directorynotfound
if not exist %audio% goto directorynotfound
if not exist %output% goto createoutputfolder

goto ant

REM ---------------------------------------------------------------------------------------------------------
REM	ANT
REM ---------------------------------------------------------------------------------------------------------

:ant
call ant.bat clean
call ant.bat compile
call ant.bat VideoMetadataGenerator 	-Dinput=%video% 	-Doutput=%output%
call ant.bat VideoFrameGrabber 		-Dinput=%video% 	-Doutput=%output%
call ant.bat VideoThumbnailGenerator 	-Dinput=%video% 	-Doutput=%output% -Dtimespan=0
call ant.bat VideoThumbnailGenerator 	-Dinput=%video% 	-Doutput=%output% 	-Dtimespan=5
call ant.bat AudioThumbGenerator 	-Dinput=%audio% 	-Doutput=%output% 	-Dlength=10
call ant.bat AudioMetadataGenerator 	-Dinput=%audio% 	-Doutput=%output%
call ant.bat AudioPlayer                -Dinput=%audio%/error.wav
goto end

REM ---------------------------------------------------------------------------------------------------------
REM	Try to create output folder
REM ---------------------------------------------------------------------------------------------------------

:createoutputfolder
if [%3] == [] set output=%~dp0out 
mkdir %output%
goto checkinput

REM ---------------------------------------------------------------------------------------------------------
REM	ERR
REM ---------------------------------------------------------------------------------------------------------

:directorynotfound
echo "Input Folder does not exists"
goto end

:wrongparam
echo "One or more parameter are missing"
echo "Example usage: cmd media\video media\audio output"

REM ---------------------------------------------------------------------------------------------------------
REM	END
REM ---------------------------------------------------------------------------------------------------------

:end