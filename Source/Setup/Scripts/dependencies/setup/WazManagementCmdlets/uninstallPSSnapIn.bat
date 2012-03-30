@echo off
%~d0
cd "%~dp0"

ECHO ----------------------------------------
ECHO Uninstall AzureManagementTools PSSnapIn
ECHO ----------------------------------------

IF EXIST %WINDIR%\SysWow64 (
	set installUtilDir=%WINDIR%\Microsoft.NET\Framework64\v2.0.50727
) ELSE (
	set installUtilDir=%WINDIR%\Microsoft.NET\Framework\v2.0.50727
)

set assemblyPath="..\..\..\..\..\Assets\AzureManagementTools\code\AzureManagementTools.Cmdlets\bin\Debug\Microsoft.Samples.AzureManagementTools.PowerShell.dll"

ECHO "Uninstalling PSSnapIn..."
%installUtilDir%\installutil.exe -u %assemblyPath%

@PAUSE