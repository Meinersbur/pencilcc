#include <stdlib.h>

struct Cmplx {
	long re,im;
};

void kernel(int n, struct Cmplx A[static const restrict n], struct Cmplx val) {
#pragma scop
	for (int i = 0; i<n; ++i) {
		A[i] = val;
	}
#pragma endscop
}

int main() {
	struct Cmplx A[128];
	struct Cmplx val;
	val.re = 1;
	val.im = 0;

	kernel(128, A, val);

	for (int i = 0; i<128; i+=1) {
		if (A[i].re != 1 || A[i].im != 0)
			exit(1);
	}

	return 0;
}
