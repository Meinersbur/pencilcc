#! /bin/sh
set -e # Fail if any subcommand fails

echo "pwd=`pwd`"
echo "PENCILCC=${PENCILCC}"
echo "TESTSRCDIR=${TESTSRCDIR}"
echo "TESTBUILDDIR=${TESTBUILDDIR}"

cd "${TESTBUILDDIR}"

cat > math_pencil.c <<- EOM
#include <pencil.h>

void kernel(int n, int32_t A32[static const restrict n], int64_t A64[static const restrict n], double fA[static const restrict n], float fAf[static const restrict n]) {
#pragma scop
	for (int32_t i = 0; i<n; ++i) {
		A32[i] = i;
		A64[i] = i;
		fA[i] = i;
		fAf[i] = i;

		A32[i] = abs32(A32[i]);
		A64[i] = abs64(A64[i]);
		fA[i] = fabs(fA[i]);
		fAf[i] = fabsf(fAf[i]);

		A32[i] = clamp32(A32[i], 10, 120);
		A64[i] = clamp64(A64[i], 10, 120);
		fA[i] = fclamp(fA[i], 10, 120);
		fAf[i] = fclampf(fAf[i], 10, 120);

		fA[i] = sin(fA[i]);
		fAf[i] = sinf(fAf[i]);

		fA[i] = atan2pi(fA[i], fA[i]);
		fAf[i] = atan2pif(fAf[i], fAf[i]);
	}
#pragma endscop
}

int main() {
	int32_t A32[128];
	int64_t A64[128];
	double fA[128];
	float fAf[128];
	kernel(128, A32, A64, fA, fAf);
	return EXIT_SUCCESS;
}
EOM

${PENCILCC} -v -v -O3 --target=prl -w  math_pencil.c --run
