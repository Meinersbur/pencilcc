#! /bin/sh
pencilcc example-ext.c --opencl-include-file=example-opencl.h -o example-ext
./example-ext
