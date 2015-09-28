#include <stdlib.h>
#include <prl_mem.h>

static void kernel(int n, float A[static const restrict n], unsigned mod) {
#pragma scop
	for (int i = 0; i<n; ++i) {
		if (i % mod == 0)
			A[i] = mod;
	}
#pragma endscop
}

int main() {
	prl_mem mem_A = prl_mem_alloc(128*sizeof(float), prl_mem_readable_writable);
	float *A = prl_mem_get_host_mem(mem_A);

	kernel(128, A, 1);
	kernel(128, A, 2);

	for (int i = 0; i<128; i+=1) {
		if (A[i] != 2-i%2)
			exit(1);
	}

	prl_mem_free(mem_A);
	return EXIT_SUCCESS;
}
