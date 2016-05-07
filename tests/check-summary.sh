#! /bin/sh
set -e # Fail if any subcommand fails

echo "pwd=`pwd`"
echo "PENCILCC=${PENCILCC}"
echo "TESTSRCDIR=${TESTSRCDIR}"
echo "TESTBUILDDIR=${TESTBUILDDIR}"

cd "${TESTBUILDDIR}"


cat > external.cl <<- EOM
void external(int n, float *A, int i) {
	A[i] = 42;
}
EOM


cat > summary.pencil.c <<- EOM
#include <pencil.h>
#include <stdio.h>

PENCIL_SUMMARY_FUNC void external_summary(int n, float A[PENCIL_ARRAY n], int i) {
	PENCIL_DEF(A[i]);
}

void external(int n, float A[PENCIL_ARRAY n], int i) PENCIL_ACCESS(external_summary);

void kernel(int n, float A[PENCIL_ARRAY n]) {
	for (int i = 0; i<n; ++i)
		external(n, A, i);
}

int main() {
	float A[128];

	kernel(128, A);

	for (int i = 0; i < 128; i+=1) {
		if (A[i] != 42) {
			printf("A[%i] is not 42 but %f!\n", i, A[i]);
			return EXIT_FAILURE;
		}
	}
	return EXIT_SUCCESS;
}
EOM


${PENCILCC} -v -v -O3 -w  summary.pencil.c --opencl-include-file="${TESTBUILDDIR}/external.cl" --run
