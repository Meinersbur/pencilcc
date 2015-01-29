#! /bin/sh
set -e # Fail if any subcommand fails

echo "pwd: `pwd`"
echo "PENCILCC=${PENCILCC}"
echo "TESTSRCDIR=${TESTSRCDIR}"
echo "TESTBUILDDIR=${TESTBUILDDIR}"

cd "${TESTBUILDDIR}"
echo "${PENCILCC} --show-commands ${TESTSRCDIR}/example.c --run "
${PENCILCC} --show-commands "${TESTSRCDIR}/example.c" --run || exit 1
