#! /bin/sh

pencilcc -O3 --no-private-memory practical.c -o practical && PRL_PROF_ALL=1 ./practical
