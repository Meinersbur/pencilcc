#! /bin/sh
set -e # Fail if any subcommand fails

echo "pwd=`pwd`"
echo "PENCILCC=${PENCILCC}"
echo "TESTSRCDIR=${TESTSRCDIR}"
echo "TESTBUILDDIR=${TESTBUILDDIR}"

cd "${TESTBUILDDIR}"
${PENCILCC} -v -v -O3 "${TESTSRCDIR}/simple.c" --keep --keep-dir "${TESTBUILDDIR}" --target=cuda --keep --run -w
