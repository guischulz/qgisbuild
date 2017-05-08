@echo off
setlocal

set OSGEO4W_ROOT=C:\OSGeo4W64
set O4W_INSTALLER=D:\Archiv\Downloads\OSGeo4W64_Install\osgeo4w-setup-x86_64.exe
set O4W_PACKAGES_DIR=D:\Archiv\Downloads\OSGeo4W64_Install\x86_64\release

rem Unattended installation
"%O4W_INSTALLER%" -q -r -n -d -S --local-install --root "%OSGEO4W_ROOT%" -l "%O4W_PACKAGES_DIR%"
del /q "%OSGEO4W_ROOT%\bin\vcredist*.exe" >nul