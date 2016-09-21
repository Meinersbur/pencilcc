#! /bin/sh
set -e # Fail if any subcommand fails

echo "pwd=`pwd`"
echo "PENCILCC=${PENCILCC}"
echo "TESTSRCDIR=${TESTSRCDIR}"
echo "TESTBUILDDIR=${TESTBUILDDIR}"

cd "${TESTBUILDDIR}"

cat > fill.c <<- EOM
#include <stdlib.h>
#include <stdint.h>
#include <assert.h>
#include <prl_mem.h>
#include <stdio.h>

static void kernel(int n, uint32_t A[static const restrict n], uint32_t val) {
#pragma scop
	for (int i = 0; i<n; ++i) {
		A[i] = val;
	}
#pragma endscop
}

static void expect(int n, uint32_t A[static const restrict n], uint32_t val) {
	for (int i = 0; i<n; ++i)
		if (A[i] != val)
	  	printf("A[%d]=%u (expected %u)\n", i, A[i], val);

	for (int i = 0; i<n; ++i)
		assert(A[i] == val);
}

int main() {
	{
		prl_mem mem_A = prl_mem_alloc(128 * sizeof(uint32_t), prl_mem_readable_writable);
		uint32_t *A = prl_mem_get_host_mem(mem_A);

		prl_mem_fill(mem_A, 'A');
		expect(128, A, 0x41414141u);

		kernel(128, A, 42);
		expect(128, A, 42);

		prl_mem_free(mem_A);
	}

	{
		prl_mem mem_B = prl_mem_alloc(128 * sizeof(uint32_t), prl_mem_host_noaccess);
		uint32_t *B = prl_mem_get_host_mem(mem_B);

		prl_mem_fill(mem_B, 'B');
		prl_mem_remove_flags(mem_B, prl_mem_host_noread);
		expect(128, B, 0x42424242u);

		prl_mem_free(mem_B);
	}

	return EXIT_SUCCESS;
}
EOM

${PENCILCC} -v -v -O0 -g fill.c -o fill --run
