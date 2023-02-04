@REM ) Script for building dev update site
@REM ) -----------------------------------
@echo off

@REM ) removing the currently installed devepos artifacts
echo [INFO] Deleting Directory %userprofile%\.m2\repository\com\devepos ...
if not exist "%userprofile%\.m2\repository\com\devepos" (
    echo [INFO] Directory does not exist
    exit /B 1
)
rmdir /S/Q %userprofile%\.m2\repository\com\devepos 2>NUL

if not exist "%userprofile%\.m2\repository\com\devepos" (
    echo [INFO] Directory deleted
)