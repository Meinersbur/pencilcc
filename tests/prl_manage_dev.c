#include <stdlib.h>

#include <CL/opencl.h>
//#include <prl.h>
#include <prl_mem.h>
#include <prl_opencl.h>

static void kernel(int n, float A[static const restrict n], unsigned mod) {
#pragma scop
	for (int i = 0; i<n; ++i) {
		if (i % mod == 0)
			A[i] = mod;
	}
#pragma endscop
}



int main() {
	cl_context context = prl_opencl_get_context();
	cl_mem clmem_A = clCreateBuffer(context,CL_MEM_READ_WRITE, 128*sizeof(float), NULL, NULL);
	prl_mem mem_A = prl_opencl_mem_manage_dev(clmem_A, prl_mem_readable_writable);
	float *A = prl_mem_get_host_mem(mem_A);

	kernel(128, A, 1);
	kernel(128, A, 2);

	for (int i = 0; i<128; i+=1) {
		if (A[i] != 2-i%2)
			exit(1);
	}

	prl_mem_free(mem_A);
	clReleaseMemObject(clmem_A);
	return EXIT_SUCCESS;
}
