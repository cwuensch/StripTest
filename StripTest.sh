#!/bin/bash
echo 'Run a standardized RecStrip test for SD/HD video'
echo '(c) 2021-2024 Christian Wuensch'
echo

if [ "$1" == "-h" ] ; then
  echo "Usage:  $0 <SD/HD> <version> [<RecStrip_binary>] [<reference_binary>]"
  echo '   or:  STRIPTEST=SD RS_VER=3 RunTest.sh'
  echo
  echo '<RecStrip_binary> defaults to "RecStrip" resp. "RecStrip3"'
  echo
  echo 'If no reference exist, create it with <reference_binary>'
  echo
  exit 0
fi

cd "$(dirname "${BASH_SOURCE[0]}")"


striptest_sd() {
  # Prepare output folder
  rm -rf new
  mkdir -p new/RS_sep new/RS_sepstrip new/RS_gem new/RS_gemstrip

  # 1. RecStrip: Copy into SEPARATE files (without and with stipping)
  echo "1. RecStrip: Copy into SEPARATE files (without and with stipping)"
  $1 -c -tt "Wintersport.rec" new/RS_sep > new/RS_sep/RS.log
  $1 -c -s -e -tt "Wintersport.rec" new/RS_sepstrip > new/RS_sepstrip/RS.log

  # 2. RecStrip: Remove scenes to create a COMMON file (without and with stripping)
  echo "2. RecStrip: Remove scenes to create a COMMON file (without and with stripping)"
  mv "Wintersport.cut" "Wintersport_sep.cut" ; mv "Wintersport_gem.cut" "Wintersport.cut"
  $1 -r -tt "Wintersport.rec" "new/RS_gem/Wintersport_cut.rec" > new/RS_gem/RS.log
  $1 -r -s -e -tt "Wintersport.rec" "new/RS_gemstrip/Wintersport_cutstrip.rec" > new/RS_gemstrip/RS.log
  mv "Wintersport.cut" "Wintersport_gem.cut"; mv "Wintersport_sep.cut" "Wintersport.cut"

  # 3. RecStrip: STRIP the non-stripped files from steps 1 and 2
  echo "3. RecStrip: STRIP the non-stripped files from steps 1 and 2"
  $1 -s -e -tt "new/RS_gem/Wintersport_cut.rec" "new/RS_gem/Wintersport_cutstrip.rec" > new/RS_gem/RS2.log

  $1 -s -e -tt "new/RS_sep/Wintersport (Cut-1).rec" "new/RS_sep/Wintersport (Cut-1)_strip.rec" > new/RS_sep/RS2a.log
  $1 -s -e -tt "new/RS_sep/Wintersport (Cut-2).rec" "new/RS_sep/Wintersport (Cut-2)_strip.rec" > new/RS_sep/RS2b.log
  $1 -s -e -tt "new/RS_sep/Wintersport (Cut-3).rec" "new/RS_sep/Wintersport (Cut-3)_strip.rec" > new/RS_sep/RS2c.log

  # Clean log files
  sed -i -E '/^Execution time:|^Local timezone:|^Elapsed time:/d' new/*/RS*.log
}

striptest_hd() {
  # Prepare output folder
  rm -rf new
  mkdir -p new/RS_sep new/RS_sepstrip new/RS_gem new/RS_gemstrip new/RS_append new/RS_merge new/RS_mergestrip new/RS_mergestripped

  # 1. RecStrip: Copy into SEPARATE files (without and with stipping)
  echo "1. RecStrip: Copy into SEPARATE files (without and with stipping)"
  $1 -c "Sportschau.rec" new/RS_sep > new/RS_sep/RS.log
  $1 -c -s -e "Sportschau.rec" new/RS_sepstrip > new/RS_sepstrip/RS.log

  # 2. RecStrip: Remove scenes to create a COMMON file (without and with stripping)
  echo "2. RecStrip: Remove scenes to create a COMMON file (without and with stripping)"
  mv "Sportschau.cut" "Sportschau_sep.cut"; mv "Sportschau_gem.cut" "Sportschau.cut"
  $1 -r "Sportschau.rec" "new/RS_gem/Sportschau_cut.rec" > new/RS_gem/RS.log
  $1 -r -s -e "Sportschau.rec" "new/RS_gemstrip/Sportschau_cutstrip.rec" > new/RS_gemstrip/RS.log
  mv "Sportschau.cut" "Sportschau_gem.cut"; mv "Sportschau_sep.cut" "Sportschau.cut"

  # 3. RecStrip: STRIP the non-stripped files from steps 1 and 2
  echo "3. RecStrip: STRIP the non-stripped files from steps 1 and 2"
  $1 -s -e "new/RS_gem/Sportschau_cut.rec" "new/RS_gem/Sportschau_cutstrip.rec" > new/RS_gem/RS2.log

  $1 -s -e "new/RS_sep/Sportschau (Cut-1).rec" "new/RS_sep/Sportschau (Cut-1)_strip.rec" > new/RS_sep/RS2a.log
  $1 -s -e "new/RS_sep/Sportschau (Cut-2).rec" "new/RS_sep/Sportschau (Cut-2)_strip.rec" > new/RS_sep/RS2b.log
  $1 -s -e "new/RS_sep/Sportschau (Cut-3).rec" "new/RS_sep/Sportschau (Cut-3)_strip.rec" > new/RS_sep/RS2c.log


  # 4. RecStrip: APPEND 2 scenes of original video onto itself (without stripping)
  echo "4. RecStrip: APPEND 2 scenes of original video onto itself (without stripping)"
  mv "Sportschau.cut" "Sportschau_sep.cut" ; mv "Sportschau_app.cut" "Sportschau.cut"
  cp "Sportschau.rec"* "Sportschau.srt" "Sportschau.cut" new/RS_append/
  $1 -a -r "new/RS_append/Sportschau.rec" "Sportschau.rec" > new/RS_append/RS.log
  mv "Sportschau.cut" "Sportschau_app.cut" ; mv "Sportschau_sep.cut" "Sportschau.cut"


  # 5. RecStrip: MERGE the 3 scenes from step 1 into new file (and strip it afterwards)
  echo "5. RecStrip: MERGE the 3 scenes from step 1 into new file (and strip it afterwards)"
  $1 -m "new/RS_merge/Sportschau_merge.rec" "new/RS_sep/Sportschau (Cut-1).rec" "new/RS_sep/Sportschau (Cut-2).rec" "new/RS_sep/Sportschau (Cut-3).rec" > new/RS_merge/RS.log
  $1 -s -e "new/RS_merge/Sportschau_merge.rec" "new/RS_merge/Sportschau_mergestrip.rec" > new/RS_merge/RS2.log

  # 6. RecStrip: MERGE and STRIP the the scenes from step 1 within a single step
  echo "6. RecStrip: MERGE and STRIP the the scenes from step 1 within a single step"
  $1 -m -s -e "new/RS_mergestrip/Sportschau_mergestrip.rec" "new/RS_sep/Sportschau (Cut-1).rec" "new/RS_sep/Sportschau (Cut-2).rec" "new/RS_sep/Sportschau (Cut-3).rec" > new/RS_mergestrip/RS.log

  # 7. RecStrip: MERGE the STRIPPED versions of the scenes from step 1
  echo "7. RecStrip: MERGE the STRIPPED versions of the scenes from step 1"
  $1 -m "new/RS_mergestripped/Sportschau_mergestripped.rec" "new/RS_sepstrip/Sportschau (Cut-1).rec" "new/RS_sepstrip/Sportschau (Cut-2).rec" "new/RS_sepstrip/Sportschau (Cut-3).rec" > new/RS_mergestripped/RS.log

  # Clean log files
  sed -i -E '/^Execution time:|^Local timezone:|^Elapsed time:/d' new/*/RS*.log
}

run_recstrip() {
  if [ "$1" == "HD" ] ; then
    striptest_sd $2
  else
    striptest_hd $2
  fi
}


# Check variables and parameters
if [ -n "$1" ] ; then STRIPTEST=$1 ; fi
if [ -n "$2" ] ; then RS_VER=$2 ; fi
if [ -n "$RS_VER" ] && [ "$RS_VER" -le "2" ] ; then RS_VER= ; fi
if [ -n "$3" ] ; then RECSTRIP=$3 ; fi
if [ -n "$4" ] ; then REFERENCE=$4 ; fi
if [ -z "$RECSTRIP" ] ; then RECSTRIP=./bin/RecStrip${RS_VER} ; fi
if [ -z "$REFERENCE" ] ; then REFERENCE=./bin_ref/RecStrip${RS_VER} ; fi
REFDIR=ref${RS_VER}

if [ "$STRIPTEST" != "SD" ] && [ "$STRIPTEST" != "HD" ] ; then
  echo "StripTest method '$STRIPTEST' is not 'SD' or 'HD'."
  exit 1000
fi
if [ ! -f $RECSTRIP ] ; then
  echo "RecStrip binary '$RECSTRIP' not found!"
  exit 1001
fi
if [ -z "$REFDIR" ] || [ ! -d $REFDIR ] ; then
  if [ -f $REFERENCE ] ; then
    echo "Creating new reference folder by '$REFERENCE'..."
    echo
    run_recstrip $STRIPTEST $REFERENCE
    echo
    mv new $REFDIR
  else
    echo "No reference folder '$REFDIR' and no reference binary '$REFERENCE'!"
    exit 1002
  fi
fi

# Perform strip test
echo "Using RecStrip $RS_VER at '$RECSTRIP' and reference '$REFDIR'..."
echo
run_recstrip $STRIPTEST $RECSTRIP
echo


# Check for differences
echo
echo "Check for differences"
diff -r --brief --exclude=*.log new $REFDIR
RETURN=$?
if [ "$RETURN" -eq "0" ] ; then
  echo "All files identical!"
fi
exit $RETURN
