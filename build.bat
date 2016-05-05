@echo off

set ahk2exe_path=C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe
set szexe_path=C:\Program Files\7-Zip\7z.exe
set output_name=ahk_git_password

if EXIST %output_name%.exe del /F %output_name%.exe
if EXIST %output_name%.zip del /F %output_name%.zip

echo Building .exe file
"%ahk2exe_path%" /in git_password.ahk /out %output_name%.exe

echo Zipping .exe file
"%szexe_path%" a -tzip -mx9 %output_name%.zip %output_name%.exe

echo Done

pause
