echo Run a standardized RecStrip test for SD video
echo (c) 2021-2024 Christian Wuensch
echo.
cd /d "%~dp0"

set RECSTRIP=RecStrip_Win32.exe
if not exist %RECSTRIP% goto end

echo Prepare output folder
del /S /Q new\*
mkdir new\RS_sep new\RS_sepstrip new\RS_gem new\RS_gemstrip

echo 1. RecStrip: Copy into SEPARATE files (without and with stipping)
%RECSTRIP% -c -tt "Wintersport.rec" new/RS_sep > new/RS_sep/RS.log
%RECSTRIP% -c -s -e -tt "Wintersport.rec" new/RS_sepstrip > new/RS_sepstrip/RS.log

echo 2. RecStrip: Remove scenes to create a COMMON file (without and with stripping)
ren "Wintersport.cut" "Wintersport_sep.cut"
ren "Wintersport_gem.cut" "Wintersport.cut"
%RECSTRIP% -r -tt "Wintersport.rec" "new/RS_gem/Wintersport_cut.rec" > new/RS_gem/RS.log
%RECSTRIP% -r -s -e -tt "Wintersport.rec" "new/RS_gemstrip/Wintersport_cutstrip.rec" > new/RS_gemstrip/RS.log
ren "Wintersport.cut" "Wintersport_gem.cut"
ren "Wintersport_sep.cut" "Wintersport.cut"

echo 3. RecStrip: STRIP the non-stripped files from steps 1 and 2
%RECSTRIP% -s -e -tt "new/RS_gem/Wintersport_cut.rec" "new/RS_gem/Wintersport_cutstrip.rec" > new/RS_gem/RS2.log

%RECSTRIP% -s -e -tt "new/RS_sep/Wintersport (Cut-1).rec" "new/RS_sep/Wintersport (Cut-1)_strip.rec" > new/RS_sep/RS2a.log
%RECSTRIP% -s -e -tt "new/RS_sep/Wintersport (Cut-2).rec" "new/RS_sep/Wintersport (Cut-2)_strip.rec" > new/RS_sep/RS2b.log
%RECSTRIP% -s -e -tt "new/RS_sep/Wintersport (Cut-3).rec" "new/RS_sep/Wintersport (Cut-3)_strip.rec" > new/RS_sep/RS2c.log

:end
@echo off
for /f %%x in ('dir /b /s new/*.log') do (
  findstr /b /v /c:"Execution time:" /c:"Local timezone:" /c:"Elapsed time:" "%%x" > tmp.log
  move /y tmp.log "%%x" > nul
)
pause
