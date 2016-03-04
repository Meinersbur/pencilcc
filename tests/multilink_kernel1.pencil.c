
void kernel1(int n, float A[static const restrict n]) {
	for (int i = 0; i<n; ++i) {
		A[i] = i*n;
	}
}
