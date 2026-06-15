#!/bin/bash

for rec in rec rec.nav
do
  if diff "./ref/RS_gem/Wintersport_cut.$rec" "./ref3/RS_gem/Wintersport_cut.$rec" ; then
    ln -f "./ref/RS_gem/Wintersport_cut.$rec" "./ref3/RS_gem/Wintersport_cut.$rec"
  fi

  for i in {1..3}
  do
    if diff "./ref/RS_sep/Wintersport (Cut-$i).$rec" "./ref3/RS_sep/Wintersport (Cut-$i).$rec" ; then
      ln -f "./ref/RS_sep/Wintersport (Cut-$i).$rec" "./ref3/RS_sep/Wintersport (Cut-$i).$rec"
    fi
  done


  for ref in ref ref3
  do
    for i in {1..3}
    do
      if diff "./$ref/RS_sep/Wintersport (Cut-$i)_strip.$rec" "./$ref/RS_sepstrip/Wintersport (Cut-$i).$rec" ; then
        ln -f "./$ref/RS_sep/Wintersport (Cut-$i)_strip.$rec" "./$ref/RS_sepstrip/Wintersport (Cut-$i).$rec"
      fi
    done
  done
done
