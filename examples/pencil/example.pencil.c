
#include <pencil.h>


// --pet-autodetect will unecessarily parallelize this function
static void inner_summary(int m, float col[static const restrict m], int k) {
	// Spec: DEF(col)
	for (int j = 0; j<m; ++j) {
		col[j] = 0;
	}
}

void inner(int m, float col[static const restrict m], int k) ACCESS(inner_summary);

void kernel(int n, int m, float A[static const restrict n][m]) {
	__pencil_assume(n > 0);
	__pencil_assume(m > 0);
	for (int i = 0; i<n;++i) {
		bool test = (i==0);
		int k = test ? 0 : clampi(m*cosf(i), 0, m);
		inner(m, A[i], k); 
	}
}
