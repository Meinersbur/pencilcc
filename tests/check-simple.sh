#! /bin/sh
set -e # Fail if any subcommand fails

echo "pwd=`pwd`"
echo "PENCILCC=${PENCILCC}"
echo "TESTSRCDIR=${TESTSRCDIR}"
echo "TESTBUILDDIR=${TESTBUILDDIR}"

cd "${TESTBUILDDIR}"
echo "${PENCILCC} --show-commands ${TESTSRCDIR}/simple.c --run "
${PENCILCC} --show-invocation --show-commands --verbose "${TESTSRCDIR}/simple.c" --run || exit 1
