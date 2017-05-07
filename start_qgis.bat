@echo off
setlocal

set OSGEO4W_ROOT=C:\OSGeo4W64
set PACKAGENAME=qgis-dev
set QGIS_DIR=%~dp0install
rem set QGIS_DIR=%OSGEO4W_ROOT%\apps\%PACKAGENAME%

set PATH=%SystemRoot%;%SystemRoot%\System32
call "%OSGEO4W_ROOT%\bin\o4w_env.bat"
set PATH=%QGIS_DIR%\bin;%PATH%

set QGIS_PREFIX_PATH=%QGIS_DIR:\=/%
set GDAL_FILENAME_IS_UTF8=YES
set VSI_CACHE=TRUE
set VSI_CACHE_SIZE=1000000
set QT_PLUGIN_PATH=%OSGEO4W_ROOT%\apps\qt4\plugins

start qgis.exe %*