@echo off
IF "%~1"=="0" GOTO nosleep
IF not "%~1"=="" GOTO setsleep
SHIFT
GOTO nosleep
 
:setsleep
echo Sleep mode Activated for %~1 Mins
powercfg.exe -change -standby-timeout-ac %~1
GOTO end
 
 
:nosleep
echo Sleep mode deactivated
powercfg.exe -change -standby-timeout-ac 0
GOTO end
 
:end
