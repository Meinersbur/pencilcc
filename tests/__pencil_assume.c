#include <stdlib.h>
#include <stdio.h>

void kernel(int n, float A[static const restrict n]) {
#pragma scop
	__pencil_assume(n == 128);
	for (int i = 0; i<n; ++i) {
		A[i] = 0;
	}
#pragma endscop
}

int main() {
	printf("Kernel start\n");
	float A[128];
	kernel(128, A);
	printf("Kernel terminated\n");
	return EXIT_SUCCESS;
}
