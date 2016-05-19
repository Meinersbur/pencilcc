#include <stdlib.h>
#include <assert.h>
#include <prl_mem.h>

static void kernel(int n, float A[static const restrict n], float val) {
#pragma scop
	for (int i = 0; i<n; ++i) {
		A[i] = val;
	}
#pragma endscop
}

int main() {
	float A[128];
	prl_mem mem_A = prl_mem_manage_host(sizeof A, A, prl_mem_readable_writable);
	assert(mem_A);

	kernel(128, A, 42);

	prl_mem mem_A2 = prl_mem_manage_host(sizeof A, A, prl_mem_readable_writable);
	assert(mem_A == mem_A2);
	assert(mem_A == prl_get_mem(A));
	assert(prl_mem_get_host_mem(mem_A)== &A);

	kernel(128, A, 21);

	prl_mem_free(mem_A);


	for (int i = 0; i<128; i+=1)
		assert(A[i] == 21);
	
	return EXIT_SUCCESS;
}
