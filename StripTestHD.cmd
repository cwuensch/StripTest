echo Run a standardized RecStrip test for HD video
echo (c) 2021-2024 Christian Wuensch
echo.
cd /d "%~dp0"

set RECSTRIP=RecStrip3_Win32.exe
if not exist %RECSTRIP% goto end

echo Prepare output folder
del /S /Q new\*
mkdir new\RS_sep new\RS_sepstrip new\RS_gem new\RS_gemstrip new\RS_append new\RS_merge new\RS_mergestrip new\RS_mergestripped

echo 1. RecStrip: Copy into SEPARATE files (without and with stipping)
%RECSTRIP% -c "Sportschau.rec" new/RS_sep > new/RS_sep/RS.log
%RECSTRIP% -c -s -e "Sportschau.rec" new/RS_sepstrip > new/RS_sepstrip/RS.log

echo 2. RecStrip: Remove scenes to create a COMMON file (without and with stripping)
ren "Sportschau.cut" "Sportschau_sep.cut"
ren "Sportschau_gem.cut" "Sportschau.cut"
%RECSTRIP% -r "Sportschau.rec" "new/RS_gem/Sportschau_cut.rec" > new/RS_gem/RS.log
%RECSTRIP% -r -s -e "Sportschau.rec" "new/RS_gemstrip/Sportschau_cutstrip.rec" > new/RS_gemstrip/RS.log
ren "Sportschau.cut" "Sportschau_gem.cut"
ren "Sportschau_sep.cut" "Sportschau.cut"

echo 3. RecStrip: STRIP the non-stripped files from steps 1 and 2
%RECSTRIP% -s -e "new/RS_gem/Sportschau_cut.rec" "new/RS_gem/Sportschau_cutstrip.rec" > new/RS_gem/RS2.log

%RECSTRIP% -s -e "new/RS_sep/Sportschau (Cut-1).rec" "new/RS_sep/Sportschau (Cut-1)_strip.rec" > new/RS_sep/RS2a.log
%RECSTRIP% -s -e "new/RS_sep/Sportschau (Cut-2).rec" "new/RS_sep/Sportschau (Cut-2)_strip.rec" > new/RS_sep/RS2b.log
%RECSTRIP% -s -e "new/RS_sep/Sportschau (Cut-3).rec" "new/RS_sep/Sportschau (Cut-3)_strip.rec" > new/RS_sep/RS2c.log


echo 4. RecStrip: APPEND 2 scenes of original video onto itself (without stripping)
ren "Sportschau.cut" "Sportschau_sep.cut"
ren "Sportschau_app.cut" "Sportschau.cut"
copy "Sportschau.rec.*" new\RS_append
copy "Sportschau.srt" new\RS_append
copy "Sportschau.cut" new\RS_append
%RECSTRIP% -a -r "new/RS_append/Sportschau.rec" "Sportschau.rec" > new/RS_append/RS.log
ren "Sportschau.cut" "Sportschau_app.cut"
ren "Sportschau_sep.cut" "Sportschau.cut"


echo 5. RecStrip: MERGE the 3 scenes from step 1 into new file (and strip it afterwards)
%RECSTRIP% -m "new/RS_merge/Sportschau_merge.rec" "new/RS_sep/Sportschau (Cut-1).rec" "new/RS_sep/Sportschau (Cut-2).rec" "new/RS_sep/Sportschau (Cut-3).rec" > new/RS_merge/RS.log
%RECSTRIP% -s -e "new/RS_merge/Sportschau_merge.rec" "new/RS_merge/Sportschau_mergestrip.rec" > new/RS_merge/RS2.log

echo 6. RecStrip: MERGE and STRIP the the scenes from step 1 within a single step
%RECSTRIP% -m -s -e "new/RS_mergestrip/Sportschau_mergestrip.rec" "new/RS_sep/Sportschau (Cut-1).rec" "new/RS_sep/Sportschau (Cut-2).rec" "new/RS_sep/Sportschau (Cut-3).rec" > new/RS_mergestrip/RS.log

echo 7. RecStrip: MERGE the STRIPPED versions of the scenes from step 1
%RECSTRIP% -m "new/RS_mergestripped/Sportschau_mergestripped.rec" "new/RS_sepstrip/Sportschau (Cut-1).rec" "new/RS_sepstrip/Sportschau (Cut-2).rec" "new/RS_sepstrip/Sportschau (Cut-3).rec" > new/RS_mergestripped/RS.log

:end
@echo off
for /f %%x in ('dir /b /s new/*.log') do (
  findstr /b /v /c:"Execution time:" /c:"Local timezone:" /c:"Elapsed time:" "%%x" > tmp.log
  move /y tmp.log "%%x" > nul
)
pause
