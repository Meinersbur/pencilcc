#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <math.h>

#include <pencil.h>
#include <prl.h>

#define N_IMAGES 10
#define IMAGE_WIDTH 1024
#define IMAGE_HEIGHT 768
#define HISTOGRAM_STEPS 16
#define FILTER_WIDTH 7
#define FILTER_HEIGHT 7

static void init_gauss(int w, int h, float out[w][h]) {
	float cx = w*0.5f - 0.5f;
	float cy = h*0.5f - 0.5f;
	float sigmax = w * 0.5f * 0.33f;
	float sigmay = h * 0.5f * 0.33f;
	for (int dx = 0; dx < w; dx += 1)
		for (int dy = 0; dy < h; dy += 1)
			out[dx][dy] = expf(-(dx - cx)*(dx - cx) / (2*sigmax*sigmax))/sqrtf(2*M_PI*sigmax*sigmax) * expf(-(dy - cy)*(dy - cy) / (2*sigmay*sigmay))/sqrtf(2*M_PI*sigmay*sigmay);
}

static void gen_waves(int count, int m, int n, float out[static const restrict count][m][n]) {
#pragma scop
	__pencil_kill(out);
	__pencil_assume(count > 0);
	__pencil_assume(m > 0);
	__pencil_assume(n > 0);
	for (int i = 0; i < count; i += 1)
		for (int x = 0; x < m; x += 1)
			for (int y = 0; y < n; y += 1)
				out[i][x][y] = (sinf( x*i*M_PI/m ) + cosf( y*i*M_PI/n )) / 2;
#pragma endscop
}

static void convolution(int count, int m, int n, float in[static const restrict count][m][n], int w, int h, float filter[static const restrict w][h], float out[static const restrict count][m][n]) {
#pragma scop
	__pencil_kill(out);
	__pencil_assume(w > 0);
	__pencil_assume(h > 0);
	__pencil_assume(w <= FILTER_WIDTH);
	__pencil_assume(h <= FILTER_HEIGHT);
	__pencil_assume(m >= w);
	__pencil_assume(n >= h);
	for (int i = 0; i < count; i += 1)
		for (int x = 0; x < m; x += 1)
			for (int y = 0; y < n; y += 1)
				out[i][x][y] = 0.9;
	for (int i = 0; i < count; i += 1)
		for (int x = w/2; x < m-(w-1)/2; x += 1)
			for (int y = h/2; y < n-(h-1)/2; y += 1) {
				out[i][x][y] = 0;
				for (int dx = 0; dx < w; dx += 1)
					for (int dy = 0; dy < h; dy += 1)
						out[i][x][y] += in[i][x+dx-w/2][y+dy-h/2] * filter[dx][dy];
			}
#pragma endscop
}

PENCIL_SUMMARY_FUNC void hist_inc_summary(int32_t vec[static const restrict HISTOGRAM_STEPS], int s) {
	PENCIL_USE(vec[s]);
}
void hist_inc(int32_t vec[static const restrict HISTOGRAM_STEPS], int s) PENCIL_ACCESS(hist_inc_summary);

static void histogram(int count, int m, int n, int w, int h, float in[static const restrict count][m][n], int32_t out[static const restrict count][HISTOGRAM_STEPS]) {
#pragma scop
	__pencil_kill(out);
	__pencil_assume(count > 0);
	__pencil_assume(m > 0);
	__pencil_assume(n > 0);
	for (int i = 0; i < count; i += 1) {
		for (int j = 0; j < HISTOGRAM_STEPS; j += 1)
			out[i][j] = 0;
#pragma pencil independent
		for (int x = w/2; x < m-(w-1)/2; x += 1)
#pragma pencil independent
			for (int y = h/2; y < n-(h-1)/2; y += 1) {
				float v = in[i][x][y];
				int32_t s = roundf( (v+1)/2*HISTOGRAM_STEPS );
				if (s < 0 || s >= HISTOGRAM_STEPS)
					continue;

				hist_inc(out[i], s);
			}
	}
#pragma endscop
}

static void print_histogram(int count, int32_t in[static const restrict count][HISTOGRAM_STEPS]) {
	for (int i = 0; i < count; i += 1) {
		for (int j = 0; j < HISTOGRAM_STEPS; j += 1)
			printf("%5" PRIi32 " ", in[i][j]);
		printf("\n");
	}
	printf("\n");
}

typedef struct {
	float *gauss; /* In */
	float *waves;
	float *blurred;
	int32_t *hist; /* Out */
} user_t;

static void init(void *arg) {
	printf("------------------------------------------------------------------------------------------------\n");
}

static void kernel(void *arg) {
	user_t *user = arg;
	gen_waves(N_IMAGES, IMAGE_WIDTH, IMAGE_HEIGHT, (void*)user->waves);
	convolution(N_IMAGES, IMAGE_WIDTH, IMAGE_HEIGHT, (void*)user->waves, FILTER_WIDTH, FILTER_HEIGHT, (void*)user->gauss, (void*)user->blurred);
	histogram(N_IMAGES, IMAGE_WIDTH, IMAGE_HEIGHT, FILTER_WIDTH, FILTER_HEIGHT, (void*)user->blurred, (void*)user->hist);
}

static void finit(void *arg) {
	user_t *user = arg;
	print_histogram(N_IMAGES, (int32_t (*)[HISTOGRAM_STEPS])user->hist);
}

int main () {
	float (*gauss)[FILTER_HEIGHT];
	prl_mem gauss_mem = prl_mem_alloc(FILTER_WIDTH * sizeof*gauss, 0);
	gauss = prl_mem_get_host_mem(gauss_mem);

	float (*waves)[IMAGE_WIDTH][IMAGE_HEIGHT];
	prl_mem waves_mem = prl_mem_alloc(N_IMAGES * sizeof*waves, prl_mem_host_noaccess);
	waves = prl_mem_get_host_mem(waves_mem);

	float (*blurred)[IMAGE_WIDTH][IMAGE_HEIGHT];
	prl_mem blurred_mem = prl_mem_alloc(N_IMAGES * sizeof*blurred, prl_mem_host_noaccess);
	blurred = prl_mem_get_host_mem(blurred_mem);

	int32_t (*hist)[HISTOGRAM_STEPS];
	prl_mem hist_mem = prl_mem_alloc(N_IMAGES * sizeof*hist, prl_mem_host_nowrite);
	hist = prl_mem_get_host_mem(hist_mem);

	init_gauss(FILTER_WIDTH, FILTER_HEIGHT, gauss);
	prl_mem_add_flags(gauss_mem, prl_mem_host_noaccess);

	user_t user = { .gauss = (void*)gauss, .waves = (void*)waves, .blurred = (void*)blurred, .hist = (void*)hist };
	prl_perf_benchmark(&kernel, &init, &finit, &user);
	
	prl_mem_free(gauss_mem);
	prl_mem_free(waves_mem);
	prl_mem_free(blurred_mem);
	prl_mem_free(hist_mem);
	return EXIT_SUCCESS;
}
