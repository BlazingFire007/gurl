@echo off
setlocal enabledelayedexpansion

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT

if !OS!==32BIT echo This is a 32bit operating system
if !OS!==64BIT echo This is a 64bit operating system

:64bitinstall
md !userprofile!\.gurl
md tmpgurlinstall
cd tmpgurlinstall
echo Downloading 64bit version of gurl
powershell -Command "wget -UseBasicParsing -o gurl.exe https://github.com/BlazingFire007/gurl/releases/download/v0.1.0/gurl-windows-64bit.exe"
move /Y .\gurl.exe !userprofile!\.gurl\gurl.exe
cd ..
rmdir /S /Q tmpgurlinstall
goto add2path

:32bitinstall
md !userprofile!\.gurl
md tmpgurlinstall
cd tmpgurlinstall
echo Downloading 64bit version of gurl
powershell -Command "wget -UseBasicParsing -o gurl.exe https://github.com/BlazingFire007/gurl/releases/download/v0.1.0/gurl-windows-32bit.exe"
move /Y .\gurl.exe !userprofile!\.gurl\gurl.exe
cd ..
rmdir /S /Q tmpgurlinstall
goto add2path

:add2path
echo Adding gurl to path
setx path "!path!;!userprofile!\.gurl"
goto end

:end
echo Installation complete
pause