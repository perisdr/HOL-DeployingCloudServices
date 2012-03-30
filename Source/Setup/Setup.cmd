@ECHO off
%~d0
CD "%~dp0"

ECHO Install Windows Azure Management CmdLets:
ECHO -------------------------------------------------------------------------------
CALL .\Scripts\dependencies\setup\InstallWazManagementCmdlets.cmd
ECHO Done!
ECHO.
ECHO *******************************************************************************
ECHO.
@PAUSE
