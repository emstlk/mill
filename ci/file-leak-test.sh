#!/usr/bin/env bash

set -eux

if [ -x "./leaky-mill" ] ; then
  ./leaky-mill -i "{__.publishLocal,assembly}"
else
  ./mill -i all __.publishLocal assembly
fi

cp out/assembly/dest/mill leaky-mill

rm -rf out/mill-worker*

./leaky-mill --version

for i in {1..20} ; do 
  echo "iteration $i/20"
  ./leaky-mill clean assembly
  ./leaky-mill assembly || exit 1
  # mill does not report proper exit value in this case, so we also check outselves
  test -x out/assembly/dest/mill || exit 1
done
