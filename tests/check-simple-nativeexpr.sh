#! /bin/sh
set -e # Fail if any subcommand fails

cd "${TESTBUILDDIR}"
${PENCILCC} --show-invocation --show-commands --opencl-native-expr "${TESTSRCDIR}/simple.c" --run || exit 1
