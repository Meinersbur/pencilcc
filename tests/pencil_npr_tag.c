#include <stdlib.h>
#include <pencil.h>

static void kernel(int n, float A[static const restrict n], unsigned mod)
{
#pragma scop
	for (int i = 0; i < n; ++i) {
		if (i % mod == 0)
			A[i] = mod;
	}
#pragma endscop
}

int main()
{
	float A[128];

	__pencil_npr_mem_tag(A, PENCIL_NPR_MEM_NOACCESS);

	kernel(128, A, 1);

	/* to verify that the host data is not used, we (illegaly) write to it
	 * and afterwards chack that the legal data itself hasn't changed. */
	for (int i = 0; i < 128; ++i)
		A[i] = 42;

	kernel(128, A, 2);

	__pencil_npr_mem_tag(A, PENCIL_NPR_MEM_READ);

	for (int i = 0; i < 128; i += 1) {
		if (A[i] != 2 - i % 2)
			exit(1);
	}

	return EXIT_SUCCESS;
}
