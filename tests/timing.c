
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

	prl_prof_benchmark(&test, A, &init, A, &check, A);
	return EXIT_SUCCESS;
}
