@REM ) Build script for Devepos ADT plugins
@REM ) ------------------------------------
@echo off
echo [INFO] Building ADT Plugins

@REM ) Defining variables
set mvn_cmd=%MVN_HOME%\bin\mvn
set working_dir=%cd%
set plugins_dir=%working_dir%\..\..
set result_file=%working_dir%\output\build.txt

@REM ) Check maven 
if not exist %MVN_HOME% (
	echo [ERROR] Environment variable MVN_HOME for maven installation is not set
	echo [ERROR] Environment variable MVN_HOME for maven installation is not set >> %result_file% 
	goto error
)

@REM ) main function
call :main
exit /B 0 

:main
	echo [INFO] Starting Building devepos plugins/features
	echo [INFO] ------------------------------------------
	echo [INFO] Starting Building devepos plugins/features >> %result_file%
	echo [INFO] ------------------------------------------ >> %result_file% 
	 
    for /f %%r in (repos.txt) do (
		call :build_repo "%%r"
    )
    
    echo [INFO] End of Build
    echo [INFO] ------------------------------------------
    echo [INFO] End of Build >> %result_file% 
    echo [INFO] ------------------------------------------ >> %result_file%
    echo %working_dir%
    cd %working_dir% 
    
exit /B 0

:build_repo
    echo [INFO] Building project %1...
    echo [INFO] Building project %1... >> %result_file% 
    
	if not exist %plugins_dir%\%1 (
		echo [ERROR] Repository %1 does not exist in directory "%working_dir%"
		echo [ERROR] Repository %1 does not exist in directory "%working_dir%" >> %result_file%
		exit /B 1 
	)
	
	cd %plugins_dir%\%1
	call %mvn_cmd% clean install
	if not ERRORLEVEL == 0 (
		echo [ERROR] maven install failed with Error Code %ERRORLEVEL% 
		echo [ERROR] maven install failed with Error Code %ERRORLEVEL% >> %result_file%  
		exit /B 1
	)
	echo [INFO] Build complete
	echo [INFO] Build complete >> %result_file%
	echo.
	echo. >> %result_file%
	
exit /B 0