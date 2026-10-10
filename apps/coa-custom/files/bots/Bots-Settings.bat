@echo off
setlocal
set PY="%~dp0..\..\..\Runtime\python\python.exe"
if not exist %PY% set PY=python
%PY% -B "%~dp0bots_settings.py" --repack "%~dp0..\..\.." %*
echo.
pause
