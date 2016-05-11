#! /bin/sh

pencilcc -O3 --no-private-memory practical.c -o practical

PRL_PROF_GPU=1 ./practical
PRL_PROF_ALL=1 ./practical
PRL_PROF_ALL=1 ./practical
PRL_PROF_RUNS=3 PRL_PROF_ALL=1 ./practical
PRL_PROF_DRY_RUNS=0 PRL_PROF_ALL=1 ./practical
PRL_PROF_PREFIX=My PRL_PROF_ALL=1 ./practical

pencilcc -O3 --no-private-memory practical.c -o practical --tile-size=16 && PRL_PROF_ALL=1 ./practical
pencilcc -O3 --no-private-memory practical.c -o practical --dump-sizes
pencilcc -O3 --no-private-memory practical.c -o practical --sizes="{kernel[0]->tile[16,4,4]}" && PRL_PROF_ALL=1 ./practical
pencilcc -O3 --no-private-memory practical.c -o practical --sizes="{kernel[i]->block[16,16,1]}" && PRL_PROF_ALL=1 ./practical
pencilcc -O3 --no-private-memory practical.c -o practical --sizes="{kernel[i]->grid[512,512]}" && PRL_PROF_ALL=1 ./practical
pencilcc -O3 --no-private-memory practical.c -o practical --sizes="{kernel[0]->tile[16,4,4];kernel[i]->block[16,16,1];kernel[i]->grid[512,512]}" && PRL_PROF_ALL=1 ./practical
