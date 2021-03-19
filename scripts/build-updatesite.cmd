@REM ) Script for building update site
@REM ) -----------------------------------
@echo off
echo [INFO] Building %1 Update Site

@REM ) Setting variables
set mvn_cmd=%MVN_HOME%\bin\mvn
set working_dir=%cd%
set result_file=%working_dir%\output\build.txt

mkdir "%working_dir%\output" 2>NUL
del %result_file% 2>NUL

@REM ) Check maven 
if not exist %MVN_HOME% (
	echo [ERROR] Environment variable MVN_HOME for maven installation is not set
	echo [ERROR] Environment variable MVN_HOME for maven installation is not set >> %result_file% 
	goto error
)
@REM ) Building all plugins/feaures for the site
call build-adt-plugins
if not ERRORLEVEL == 0 (
	echo [ERROR] Error occurred in build-adt-plugins
	echo [ERROR] Error occurred in build-adt-plugins >> %result_file%
	exit /B %ERRORLEVEL%
)
cd %2
echo [INFO] Installing %1 update site
echo [INFO] Installing %1 update site >> %result_file% 

@REM ) Installing the update site itesel
call %mvn_cmd% clean install
cd %working_dir%
	
exit /B 0