#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>

void kernel1(int n, float A[static const restrict n]);
void kernel2(int n, float A[static const restrict n]);

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
	float A[1024];
	double start_time = get_time();
	kernel1(1024, A);
	kernel2(1024, A);
	double stop_time = get_time();
	for (int i = 0; i < 1024; i += 1) {
		if (A[i] != i*i) {
			printf("Wrong result");
			exit(1);
		}
	}
	printf("Kernel end, took %f secs\n", stop_time-start_time);
	return EXIT_SUCCESS;
}
