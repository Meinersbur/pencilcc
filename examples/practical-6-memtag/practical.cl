
void hist_inc(__global int32_t *vec, int s) {
	atomic_inc(&vec[s]);
}
