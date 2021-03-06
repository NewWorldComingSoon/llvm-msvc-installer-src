@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion

SET "EXIT_ON_ERROR=%~1"
SET SUCCESS=0

PUSHD %~dp0

SET VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe

@rem Visual Studio 2015
SET VCT_PATH=%ProgramFiles(x86)%\MSBuild\Microsoft.Cpp\v4.0\v140\Platforms
IF EXIST "%VCT_PATH%" CALL :SUB_VS2015
SET VCT_PATH=%ProgramFiles%\MSBuild\Microsoft.Cpp\v4.0\v140\Platforms
IF EXIST "%VCT_PATH%" CALL :SUB_VS2015

@rem Visual Studio 2017
FOR /f "delims=" %%A IN ('"%VSWHERE%" -property installationPath -prerelease -version [15.0^,16.0^)') DO (
	SET VCT_PATH=%%A\Common7\IDE\VC\VCTargets\Platforms
	IF EXIST "!VCT_PATH!" CALL :SUB_VS2017 "!VCT_PATH!"
)

@rem Visual Studio 2017 Build Tools
FOR /f "delims=" %%A IN ('"%VSWHERE%" -products Microsoft.VisualStudio.Product.BuildTools -property installationPath -prerelease -version [15.0^,16.0^)') DO (
	SET VCT_PATH=%%A\Common7\IDE\VC\VCTargets\Platforms
	IF EXIST "!VCT_PATH!" CALL :SUB_VS2017 "!VCT_PATH!"
)

@rem Visual Studio 2019, 2022
FOR /f "delims=" %%A IN ('"%VSWHERE%" -property installationPath -prerelease -version [16.0^,18.0^)') DO (
	@rem Visual C++ 2022 v143 toolset
	SET VCT_PATH=%%A\MSBuild\Microsoft\VC\v170\Platforms
	IF EXIST "!VCT_PATH!" CALL :SUB_VS2022 "!VCT_PATH!"
	@rem Visual C++ 2019 v142 toolset
	SET VCT_PATH=%%A\MSBuild\Microsoft\VC\v160\Platforms
	IF EXIST "!VCT_PATH!" CALL :SUB_VS2019 "!VCT_PATH!"
	@rem Visual C++ 2017 v141 toolset
	SET VCT_PATH=%%A\MSBuild\Microsoft\VC\v150\Platforms
	IF EXIST "!VCT_PATH!" CALL :SUB_VS2017 "!VCT_PATH!"
)

@rem Visual Studio 2019, 2022 Build Tools
FOR /f "delims=" %%A IN ('"%VSWHERE%" -products Microsoft.VisualStudio.Product.BuildTools -property installationPath -prerelease -version [16.0^,18.0^)') DO (
	@rem Visual C++ 2022 v143 toolset
	SET VCT_PATH=%%A\MSBuild\Microsoft\VC\v170\Platforms
	IF EXIST "!VCT_PATH!" CALL :SUB_VS2022 "!VCT_PATH!"
	@rem Visual C++ 2019 v142 toolset
	SET VCT_PATH=%%A\MSBuild\Microsoft\VC\v160\Platforms
	IF EXIST "!VCT_PATH!" CALL :SUB_VS2019 "!VCT_PATH!"
	@rem Visual C++ 2017 v141 toolset
	SET VCT_PATH=%%A\MSBuild\Microsoft\VC\v150\Platforms
	IF EXIST "!VCT_PATH!" CALL :SUB_VS2017 "!VCT_PATH!"
)

IF %SUCCESS% == 0 (
	ECHO Visual C++ 2017, 2019 or 2022 NOT Installed.
	IF "%EXIT_ON_ERROR%" == "" EXIT /B
)

POPD
ENDLOCAL
EXIT /B


:SUB_VS2015
ECHO VCTargetsPath for Visual Studio 2015: %VCT_PATH%
XCOPY /Q /Y "LLVM-MSVC" "%VCT_PATH%\..\LLVM-MSVC\"
XCOPY /Q /Y "LLVM-MSVC_v140" "%VCT_PATH%\x64\PlatformToolsets\LLVM-MSVC_v140\"
XCOPY /Q /Y "LLVM-MSVC_v140_xp" "%VCT_PATH%\x64\PlatformToolsets\LLVM-MSVC_v140_xp\"
XCOPY /Q /Y "LLVM-MSVC_KernelMode" "%VCT_PATH%\x64\PlatformToolsets\LLVM-MSVC_v140_KernelMode\"
XCOPY /Q /Y "LLVM-MSVC_v140" "%VCT_PATH%\Win32\PlatformToolsets\LLVM-MSVC_v140\"
XCOPY /Q /Y "LLVM-MSVC_v140_xp" "%VCT_PATH%\Win32\PlatformToolsets\LLVM-MSVC_v140_xp\"
XCOPY /Q /Y "LLVM-MSVC_KernelMode" "%VCT_PATH%\Win32\PlatformToolsets\LLVM-MSVC_v140_KernelMode\"
SET SUCCESS=1
EXIT /B

:SUB_VS2017
ECHO VCTargetsPath for Visual Studio 2017: %~1
XCOPY /Q /Y "LLVM-MSVC" "%~1\..\LLVM-MSVC\"
XCOPY /Q /Y "LLVM-MSVC_v141" "%~1\x64\PlatformToolsets\LLVM-MSVC_v141\"
XCOPY /Q /Y "LLVM-MSVC_v141_xp" "%~1\x64\PlatformToolsets\LLVM-MSVC_v141_xp\"
XCOPY /Q /Y "LLVM-MSVC_KernelMode" "%~1\x64\PlatformToolsets\LLVM-MSVC_v141_KernelMode\"
XCOPY /Q /Y "LLVM-MSVC_v141" "%~1\Win32\PlatformToolsets\LLVM-MSVC_v141\"
XCOPY /Q /Y "LLVM-MSVC_v141_xp" "%~1\Win32\PlatformToolsets\LLVM-MSVC_v141_xp\"
XCOPY /Q /Y "LLVM-MSVC_KernelMode" "%~1\Win32\PlatformToolsets\LLVM-MSVC_v141_KernelMode\"
IF EXIST "%~1\ARM64" XCOPY /Q /Y "LLVM-MSVC_v141" "%~1\ARM64\PlatformToolsets\LLVM-MSVC_v141\"
IF EXIST "%~1\ARM64" XCOPY /Q /Y "LLVM-MSVC_KernelMode" "%~1\ARM64\PlatformToolsets\LLVM-MSVC_v141_KernelMode\"
IF EXIST "%~1\ARM" XCOPY /Q /Y "LLVM-MSVC_v141" "%~1\ARM\PlatformToolsets\LLVM-MSVC_v141\"
IF EXIST "%~1\ARM" XCOPY /Q /Y "LLVM-MSVC_KernelMode" "%~1\ARM\PlatformToolsets\LLVM-MSVC_v141_KernelMode\"
SET SUCCESS=1
EXIT /B

:SUB_VS2019
ECHO VCTargetsPath for Visual Studio 2019: %~1
XCOPY /Q /Y "LLVM-MSVC" "%~1\..\LLVM-MSVC\"
XCOPY /Q /Y "LLVM-MSVC_v142" "%~1\x64\PlatformToolsets\LLVM-MSVC_v142\"
XCOPY /Q /Y "LLVM-MSVC_KernelMode" "%~1\x64\PlatformToolsets\LLVM-MSVC_v142_KernelMode\"
XCOPY /Q /Y "LLVM-MSVC_v142" "%~1\Win32\PlatformToolsets\LLVM-MSVC_v142\"
XCOPY /Q /Y "LLVM-MSVC_KernelMode" "%~1\Win32\PlatformToolsets\LLVM-MSVC_v142_KernelMode\"
IF EXIST "%~1\ARM64" XCOPY /Q /Y "LLVM-MSVC_v142" "%~1\ARM64\PlatformToolsets\LLVM-MSVC_v142\"
IF EXIST "%~1\ARM64" XCOPY /Q /Y "LLVM-MSVC_KernelMode" "%~1\ARM64\PlatformToolsets\LLVM-MSVC_v142_KernelMode\"
IF EXIST "%~1\ARM" XCOPY /Q /Y "LLVM-MSVC_v142" "%~1\ARM\PlatformToolsets\LLVM-MSVC_v142\"
IF EXIST "%~1\ARM" XCOPY /Q /Y "LLVM-MSVC_KernelMode" "%~1\ARM\PlatformToolsets\LLVM-MSVC_v142_KernelMode\"
SET SUCCESS=1
EXIT /B

:SUB_VS2022
ECHO VCTargetsPath for Visual Studio 2022: %~1
XCOPY /Q /Y "LLVM-MSVC" "%~1\..\LLVM-MSVC\"
XCOPY /Q /Y "LLVM-MSVC_v143" "%~1\x64\PlatformToolsets\LLVM-MSVC_v143\"
XCOPY /Q /Y "LLVM-MSVC_KernelMode" "%~1\x64\PlatformToolsets\LLVM-MSVC_v143_KernelMode\"
XCOPY /Q /Y "LLVM-MSVC_v143" "%~1\Win32\PlatformToolsets\LLVM-MSVC_v143\"
XCOPY /Q /Y "LLVM-MSVC_KernelMode" "%~1\Win32\PlatformToolsets\LLVM-MSVC_v143_KernelMode\"
IF EXIST "%~1\ARM64" XCOPY /Q /Y "LLVM-MSVC_v143" "%~1\ARM64\PlatformToolsets\LLVM-MSVC_v143\"
IF EXIST "%~1\ARM64" XCOPY /Q /Y "LLVM-MSVC_KernelMode" "%~1\ARM64\PlatformToolsets\LLVM-MSVC_v143_KernelMode\"
IF EXIST "%~1\ARM" XCOPY /Q /Y "LLVM-MSVC_v143" "%~1\ARM\PlatformToolsets\LLVM-MSVC_v143\"
IF EXIST "%~1\ARM" XCOPY /Q /Y "LLVM-MSVC_KernelMode" "%~1\ARM\PlatformToolsets\LLVM-MSVC_v143_KernelMode\"
SET SUCCESS=1
EXIT /B
