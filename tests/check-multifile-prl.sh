#! /bin/sh
set -e # Fail if any subcommand fails

echo "pwd=`pwd`"
echo "PENCILCC=${PENCILCC}"
echo "TESTSRCDIR=${TESTSRCDIR}"
echo "TESTBUILDDIR=${TESTBUILDDIR}"

cd "${TESTBUILDDIR}"
${PENCILCC} -v -v -O3 --target=prl -Werror "${TESTSRCDIR}/multilink_kernel1.pencil.c" "${TESTSRCDIR}/multilink_kernel2.pencil.c" "${TESTSRCDIR}/multilink_main.c" --run
