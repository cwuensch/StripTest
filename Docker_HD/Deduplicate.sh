#!/bin/bash

for rec in rec rec.nav
do
  if diff "./ref/RS_gem/Sportschau_cut.$rec" "./ref3/RS_gem/Sportschau_cut.$rec" ; then
    ln -f "./ref/RS_gem/Sportschau_cut.$rec" "./ref3/RS_gem/Sportschau_cut.$rec"
  fi

  for i in {1..3}
  do
    if diff "./ref/RS_sep/Sportschau (Cut-$i).$rec" "./ref3/RS_sep/Sportschau (Cut-$i).$rec" ; then
      ln -f "./ref/RS_sep/Sportschau (Cut-$i).$rec" "./ref3/RS_sep/Sportschau (Cut-$i).$rec"
    fi
  done

  if diff "./ref/RS_merge/Sportschau_merge.$rec" "./ref3/RS_merge/Sportschau_merge.$rec" ; then
    ln -f "./ref/RS_merge/Sportschau_merge.$rec" "./ref3/RS_merge/Sportschau_merge.$rec"
  fi

  if diff "./ref/RS_append/Sportschau.$rec" "./ref3/RS_append/Sportschau.$rec" ; then
    ln -f "./ref/RS_append/Sportschau.$rec" "./ref3/RS_append/Sportschau.$rec"
  fi

  for ref in ref ref3
  do
    for i in {1..3}
    do
      if diff "./$ref/RS_sep/Sportschau (Cut-$i)_strip.$rec" "./$ref/RS_sepstrip/Sportschau (Cut-$i).$rec" ; then
        ln -f "./$ref/RS_sep/Sportschau (Cut-$i)_strip.$rec" "./$ref/RS_sepstrip/Sportschau (Cut-$i).$rec"
      fi
    done
  done
done

if diff "./ref/RS_mergestrip/Sportschau_mergestrip.rec" "./ref/RS_mergestripped/Sportschau_mergestripped.rec" ; then
  ln -f "./ref/RS_mergestrip/Sportschau_mergestrip.rec" "./ref/RS_mergestripped/Sportschau_mergestripped.rec"
fi
