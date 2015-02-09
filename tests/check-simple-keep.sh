#! /bin/sh
set -e # Fail if any subcommand fails

echo "pwd: `pwd`"
echo "PENCILCC=${PENCILCC}"
echo "TESTSRCDIR=${TESTSRCDIR}"
echo "TESTBUILDDIR=${TESTBUILDDIR}"

cd "${TESTBUILDDIR}"
${PENCILCC} --show-invocation --show-commands --keep "${TESTSRCDIR}/simple.c"  --run || exit 1
