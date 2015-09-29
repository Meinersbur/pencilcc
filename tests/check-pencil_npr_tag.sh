#! /bin/sh
set -e # Fail if any subcommand fails

echo "pwd=`pwd`"
echo "PENCILCC=${PENCILCC}"
echo "TESTSRCDIR=${TESTSRCDIR}"
echo "TESTBUILDDIR=${TESTBUILDDIR}"

cd "${TESTBUILDDIR}"
${PENCILCC} -vv -O3 "${TESTSRCDIR}/pencil_npr_tag.c" --run
