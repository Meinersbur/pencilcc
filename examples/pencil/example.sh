#! /bin/sh
pencilcc example.c example.pencil.c --opencl-include-file=example-opencl.h -o example
./example
