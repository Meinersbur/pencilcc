#! /bin/sh
set -e # Fail if any subcommand fails

echo "pwd=`pwd`"
echo "PENCILCC=${PENCILCC}"
echo "TESTSRCDIR=${TESTSRCDIR}"
echo "TESTBUILDDIR=${TESTBUILDDIR}"

cd "${TESTBUILDDIR}"

cat > benchmark.c <<- EOM
#include <stdlib.h>
#include <prl_perf.h>

static void init(void *arg) {
	float *A = arg;
	for (int i = 0; i<128; ++i) {
		A[i] = 0;
	}
}

static void kernel(int n, float A[static const restrict n]) {
#pragma scop
	for (int i = 0; i<n; ++i) {
		A[i] = 42;
	}
#pragma endscop
}

static void test(void *arg) {
	float *A = arg;
	kernel(128, A);
}

static void check(void *arg) {
	const float *A = arg;
	for (int i = 0; i<128; ++i) {
		if (A[i] != 42)
			exit(42);
	}
}

int main() {
	float A[128];

	prl_perf_benchmark(&test, &init, &check, A);
	return EXIT_SUCCESS;
}

EOM

${PENCILCC} -v -v -O3 --target=prl -w benchmark.c -o benchmark
PRL_PROF_ALL=1 PRL_PROF_PREFIX=PROF_ ./benchmark | tee std.out
grep "^PROF\_Duration\s*\:\s*[0-9\.]+\s*ms\s\(\S+\s*[0-9\.]+\%\)$" -P std.out
