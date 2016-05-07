#! /bin/sh
set -e # Fail if any subcommand fails

echo "pwd: `pwd`"
echo "PENCILCC=${PENCILCC}"
echo "TESTSRCDIR=${TESTSRCDIR}"
echo "TESTBUILDDIR=${TESTBUILDDIR}"

cd "${TESTBUILDDIR}"
${PENCILCC} -v -v -O3 --keep --keep-dir "${TESTBUILDDIR}" "${TESTSRCDIR}/simple.c"  --run
