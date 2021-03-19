@REM ) Build script for Devepos ADT plugins
@REM ) ------------------------------------
@echo off
echo Building ADT Plugins

@REM ) Defining variables

set working_dir=%cd%
set plugins_dir=%working_dir%\..
set result_file=%working_dir%\output\build.txt
set repos=adt-tools-base
set repos=%repos% abap-search-tools-ui
set repos=%repos% abap-tags-ui
set repos=%repos% adtextensions

@REM ) main function
call :main
exit /B 0 

:main
	mkdir "%working_dir%\output" 2>NUL
	del %result_file% 2>NUL
	
	echo [INFO]  Starting Building devepos plugins/features
	echo [INFO]  ------------------------------------------
	echo [INFO]  Starting Building devepos plugins/features >> %result_file%
	echo [INFO]  ------------------------------------------ >> %result_file% 
	 
    for %%r in (%repos%) do (
        echo [INFO]  Building project "%%r"...
        echo [INFO]  Building project "%%r"... >> %result_file% 
         
    	if not exist %plugins_dir%\%%r (
    		echo [ERROR] Repository "%%r" does not exist in directory "%working_dir%"
    		echo [ERROR] Repository "%%r" does not exist in directory "%working_dir%" >> %result_file%
    		goto error 
    	)
		
		cd %plugins_dir%\%%r
		%MVN_HOME%\bin\mvn clean install
		if not "%ERRORLEVEL%" == "0" (
			echo [ERROR] maven install failed with Error Code %ERRORLEVEL% 
			echo [ERROR] maven install failed with Error Code %ERRORLEVEL% >> %result_file%  
			echo [INFO]  Build complete >> %result_file%
			goto error
		)
    	echo/
    	echo/ >> %result_file% 
    )
    
    echo [INFO]  End of Build
    echo [INFO]  ------------------------------------------
    echo [INFO]  End of Build >> %result_file% 
    echo [INFO]  ------------------------------------------ >> %result_file%
    cd %working_dir% 
	
exit /B 0

:error
cmd /C exit /B 1