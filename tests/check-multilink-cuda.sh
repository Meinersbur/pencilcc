#! /bin/sh
set -e # Fail if any subcommand fails

echo "pwd=`pwd`"
echo "PENCILCC=${PENCILCC}"
echo "TESTSRCDIR=${TESTSRCDIR}"
echo "TESTBUILDDIR=${TESTBUILDDIR}"

cd "${TESTBUILDDIR}"

echo "Compiling..."
${PENCILCC} -c -v -v -O3 --target=cuda -w "${TESTSRCDIR}/multilink_main.c" -o multilink_main.o
${PENCILCC} -c -v -v -O3 --target=cuda -w "${TESTSRCDIR}/multilink_kernel1.pencil.c" -o multilink_kernel1.o
${PENCILCC} -c -v -v -O3 --target=cuda -w "${TESTSRCDIR}/multilink_kernel2.pencil.c" -o multilink_kernel2.o

echo "Linking..."
${PENCILCC} -v -v -O3 --target=cuda -w --autorpath multilink_main.o multilink_kernel1.o multilink_kernel2.o -o multilink-cuda

echo "Executing..."
./multilink-cuda

echo "Done!"
