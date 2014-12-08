
void inner(int m, __global float *col, int k) {
	for (int j = 0; j<m; ++j) {
		col[j] = k;
	}
}
