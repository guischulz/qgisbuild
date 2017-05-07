@echo off
setlocal

rem Visual Studio 2010 C++ build tools
call "%ProgramFiles(x86)%\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" amd64

rem Microsoft Windows SDK
call "%ProgramFiles%\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.Cmd" /x64 /Release
set SETUPAPI_LIBRARY=%ProgramFiles(x86)%\Microsoft SDKs\Windows\v7.1A\Lib\x64\SetupAPI.Lib

rem Required external tools
set OSGEO4W_ROOT=C:\OSGeo4W64
set CYGWIN_ROOT=C:\cygwin64
set CMAKE=C:\Tools\CMake

call "%OSGEO4W_ROOT%\bin\o4w_env.bat"
set PATH=%PATH%;%CMAKE%\bin;%CYGWIN_ROOT%\bin

rem Additional environment variables
set BUILD_DIR=target
set BUILDCONF=Release
set INCLUDE=%INCLUDE%;%OSGEO4W_ROOT%\include;%PYTHON_ROOT%\include
set LIB=%LIB%;%OSGEO4W_ROOT%\lib
set O4W_ROOT=%OSGEO4W_ROOT:\=/%
set PACKAGENAME=qgis-dev
set PYTHONPATH=
set SRCDIR=D:\work\QGIS

set INSTALL_DIR=%~dp0install
set PDB_OUTPUT_DIR=%INSTALL_DIR:\=/%/pdb
rem set INSTALL_DIR=%O4W_ROOT%/apps/%PACKAGENAME%
if not exist "%BUILD_DIR%" md "%BUILD_DIR%"  

if "%1"=="cmake" goto cmake
if "%1"=="clean" goto clean
if "%1"=="build" goto build
if "%1"=="install" goto install

REM ==========================================================================
:cmake
if "%1"=="skip_cmake" goto skip_cmake
if "%1"=="cmake" del "%BUILD_DIR%\CMakeCache.txt"
if exist "%BUILD_DIR%\CMakeCache.txt" goto skip_cmake

color 1f
title QGIS CMake
  
set CMAKE_OPT=^
	-G "Visual Studio 10 Win64" ^
	-D SPATIALINDEX_LIBRARY=%O4W_ROOT%/lib/spatialindex-64.lib ^
	-D SIP_BINARY_PATH=%O4W_ROOT%/bin/sip.exe ^
	-D QWT_LIBRARY=%O4W_ROOT%/lib/qwt5.lib ^
	-D CMAKE_CXX_FLAGS_RELWITHDEBINFO="/MD /Zi /MP /Od /D NDEBUG /D QGISDEBUG" ^
	-D CMAKE_COMPILE_PDB_OUTPUT_DIRECTORY=%PDB_OUTPUT_DIR% ^
	-D SETUPAPI_LIBRARY="%SETUPAPI_LIBRARY%" ^
	-D CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_NO_WARNINGS=TRUE

pushd "%BUILD_DIR%"
cmake %CMAKE_OPT% ^
	-D PEDANTIC=TRUE ^
	-D WITH_QSPATIALITE=TRUE ^
	-D WITH_SERVER=TRUE ^
	-D SERVER_SKIP_ECW=TRUE ^
	-D WITH_GRASS=FALSE ^
	-D WITH_GRASS7=FALSE ^
	-D WITH_GLOBE=FALSE ^
	-D WITH_TOUCH=FALSE ^
	-D WITH_ORACLE=FALSE ^
	-D WITH_POSTGRESQL=TRUE ^
	-D WITH_CUSTOM_WIDGETS=TRUE ^
	-D CMAKE_BUILD_TYPE=%BUILDCONF% ^
	-D CMAKE_CONFIGURATION_TYPES=%BUILDCONF% ^
	-D GEOS_LIBRARY=%O4W_ROOT%/lib/geos_c.lib ^
	-D SQLITE3_LIBRARY=%O4W_ROOT%/lib/sqlite3_i.lib ^
	-D SPATIALITE_LIBRARY=%O4W_ROOT%/lib/spatialite_i.lib ^
	-D PYTHON_EXECUTABLE=%O4W_ROOT%/bin/python.exe ^
	-D PYTHON_INCLUDE_PATH=%O4W_ROOT%/apps/Python27/include ^
	-D PYTHON_LIBRARY=%O4W_ROOT%/apps/Python27/libs/python27.lib ^
	-D QT_BINARY_DIR=%O4W_ROOT%/bin ^
	-D QT_LIBRARY_DIR=%O4W_ROOT%/lib ^
	-D QT_HEADERS_DIR=%O4W_ROOT%/include/qt4 ^
	-D QWT_INCLUDE_DIR=%O4W_ROOT%/include/qwt ^
	-D CMAKE_INSTALL_PREFIX=%INSTALL_DIR% ^
	-D FCGI_INCLUDE_DIR=%O4W_ROOT%/include ^
	-D FCGI_LIBRARY=%O4W_ROOT%/lib/libfcgi.lib ^
	-D WITH_INTERNAL_MARKUPSAFE=FALSE ^
	-D WITH_INTERNAL_DATEUTIL=FALSE ^
	-D WITH_INTERNAL_PYTZ=FALSE ^
	-D WITH_INTERNAL_SIX=FALSE ^
	-D WITH_INTERNAL_NOSE2=FALSE ^
	-D WITH_INTERNAL_FUTURE=FALSE ^
	-D WITH_INTERNAL_YAML=FALSE ^
	-D WITH_INTERNAL_OWSLIB=FALSE ^
	%SRCDIR%
popd
if "%1"=="cmake" goto :eof
:skip_cmake

REM ==========================================================================
:clean
title QGIS Clean
if "%1"=="skip_clean" goto skip_clean
cmake --build %BUILD_DIR% --target clean --config %BUILDCONF%
if "%1"=="clean" goto :eof
:skip_clean

REM ==========================================================================
:build
title QGIS Build
if "%1"=="skip_build" goto skip_build
cmake --build %BUILD_DIR% --config %BUILDCONF%
if "%1"=="build" goto :eof
:skip_build

REM ==========================================================================
:install
title QGIS Install
if "%1"=="skip_install" goto skip_install
cmake --build %BUILD_DIR% --target install --config %BUILDCONF%
if "%1"=="install" goto :eof
:skip_install

echo %date% %time%