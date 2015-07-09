


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
	float A[128];
	prl_mem mem_A = prl_mem_manage_host(sizeof A, A, prl_mem_readable_writable);

	kernel(128, A, 42);
	kernel(128, A, 21);

	prl_mem_free(mem_A);

	for (int i = 0; i<128; i+=1) {
		if (A[i] != 21)
			exit(1);
	}
	
	return EXIT_SUCCESS;
}
