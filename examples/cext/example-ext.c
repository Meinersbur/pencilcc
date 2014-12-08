
#include <pencil.h>

#include <stdio.h>
#include <sys/time.h>

static void inner_summary(int m, float col[static const restrict m], int k) {
	// Alternatively: __pencil_def(col);
	for (int j = 0; j<m; ++j) {
		col[j] = 0;
	}
}

// __attribute__((pencil_access(inner_summary))) or ACCESS(inner_summary)
void inner(int m, float col[static const restrict m], int k) ACCESS(inner_summary);

void inner(int m, float col[static const restrict m], int k) {
	for (int j = 0; j<m; ++j) {
		col[j] = k;
	}
}

// __attribute__((pencil)) according to PENCIL language spec chapter 6
void kernel(int n, int m, float A[static const restrict n][m]) {
// According to spec:
// #pragma pencil 
// - or -
// __attribute__((pencil))
#pragma scop
	{
		__pencil_assume(n > 0);
		__pencil_assume(m > 0);
		for (int i = 0; i<n;++i) {
			bool test = (i==0);
			int k = test ? 0 : clampi(m*cosf(i), 0, m);
			inner(m, A[i], k); 
		}
	}
#pragma endscop
}

static double get_time() {
	struct timeval Tp;
	int stat;

	stat = gettimeofday (&Tp, NULL);
	if (stat != 0)
		fprintf(stderr, "Error return from gettimeofday: %d", stat);
	return Tp.tv_sec + Tp.tv_usec * 1.0e-6;
}

int main() {
	printf("Kernel start\n");
	float A[128][128];
	double start_time = get_time();
	kernel(128, 128, A);
	double stop_time = get_time();
	printf("Kernel end, took %f secs\n", stop_time-start_time);
	return 0;
}
