#include <stdlib.h>
#include <prl_mem.h>

static void kernel(int n, float A[static const restrict n], float val) {
#pragma scop
	for (int i = 0; i<n; ++i) {
		A[i] = val;
	}
#pragma endscop
}

int main() {
	float *A = prl_alloc(128*sizeof*A);

	kernel(128, A, 42);
	kernel(128, A, 21);

	for (int i = 0; i<128; i+=1) {
		if (A[i] != 21)
			exit(1);
	}

	prl_free(A);
	return EXIT_SUCCESS;
}
