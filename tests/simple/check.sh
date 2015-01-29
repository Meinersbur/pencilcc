#! /bin/sh
set -e # Fail if any subcommand fails

echo "PENCILCC=${PENCILCC}"
echo "TESTSRCDIR=${TESTSRCDIR}"
${PENCILCC} "${TESTSRCDIR}/example.c" --run || exit 1
