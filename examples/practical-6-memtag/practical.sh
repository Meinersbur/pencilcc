#! /bin/sh

pencilcc -O3 --no-private-memory --opencl-include-file=practical.cl practical.c -o practical && PRL_PROF_ALL=1 ./practical
