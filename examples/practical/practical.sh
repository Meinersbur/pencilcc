#! /bin/sh

gcc -O3 practical.c -lm -c -o practical.o
gcc -O3 practical.c -lm -o practical
gcc -O3 practical.c -lm -o practical && ./practical
gcc -O3 practical.c -lm -o practical && time ./practical

pencilcc -O3 --no-private-memory --target=opencl practical.c -c -o practical.o
pencilcc -O3 --no-private-memory --target=opencl practical.c -o practical
pencilcc -O3 --no-private-memory --target=opencl practical.c -o practical --run
pencilcc -O3 --no-private-memory --target=opencl practical.c -o practical && time ./practical

pencilcc --help
ppcg --help

pencilcc -O3 --no-private-memory --target=opencl practical.c -o practical --run -v
pencilcc -O3 --no-private-memory --target=opencl practical.c -o practical --run -v -v

pencilcc -O3 --no-private-memory --target=opencl practical.c -o practical --run --keep

pencilcc -O3 --no-private-memory --target=opencl practical.c -o practical --run --c-ext=.c
pencilcc -O3 --no-private-memory --target=opencl practical.c -o practical --run --pencil-ext=.pencil.c

pencilcc -O3 --no-private-memory --target=prl practical.c -o practical
PRL_TARGET_DEVICE=gpu ./practical
PRL_TARGET_DEVICE=cpu ./practical
PRL_TARGET_DEVICE=acc ./practical
PRL_TARGET_DEVICE=1:0 ./practical

PRL_DUMP_ALL=1 ./practical
PRL_TRACE_GPU=1 ./practical
