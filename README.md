pencil-driver
=============

Driver for PENCIL compile toolchain.



Requirements (that I know of)
============

- C99 compiler (Tested with gcc 4.9.1)
- automake, autoconf, libtool (Tested with version 2.69)
- pkg-config (Tested with version 0.28)
- ppcg (bundled in ppcg submodule)
  - Integer Set Library (Bundled in ppcg/isl submodule)
    - GNU Bignum Library (Tested with version 6.0)
  - PET (bundled in ppcg/pet submodule)
    - Clang headers and libraries (Tested with version 3.5)
- pencil-optimizer (Bundled in pencil submodule)
  - Scala/scalac (Tested with version 2.10.4)
  - Apache Ant (Tested with version 1.9.4)
  - ANTLR3 (Tested with version 3.5.2)
    - antlr3-task
- pencil headers and runtime (Bundled in pencil-util submodule)
  - C++11 compiler (Tested with g++ 4.9.1)
- Python3 (Tested with version 3.4.2)



Installation
============

In theory:

1) git clone https://github.com/Meinersbur/pencil-driver.git
2) cd pencil-driver
3) git submodule update --init --recursive
4) ./autogen.sh
5) ./configure
6) make
7) sudo make install


In practice your distribution's Scala and ANTLR3 are probably not recent enough (e.g. Ubuntu 13.10 has only Scala 2.9.2 and ANTLR3 3.2 anf antlr3-task is not available at all)

Installation instructions tested on Ubuntu 13.10 (Utopic Unicorn):

0) sudo apt-get install build-essential pkg-config libgmp-dev libclang-dev ant python3 libedit-dev opencl-headers
1) git clone https://github.com/Meinersbur/pencil-driver.git
2) cd pencil-driver
3) git submodule update --init --recursive
4) ./get-scala.sh
5) ./get-antlr3.sh
6) ./autogen.sh
7) ./configure
8) make
9) sudo make install

Be aware that this creates directories pencil-driver/scala and pencil-driver/antlr3 that are required even after make install.  Install those localy and those jars to CLASSPATH before ./configure to avoid this. 



Usage
=====

pencilcc is a compiler invocation replacement.  Replace your compiler call by pencilcc.  Call "pencilcc --help" for options.  Every option not recognized is passed to the compiler (cc) after optimization took place.

Currently *.pencil.c files are assumed to contain pure PENCIL code (sublanguage of C99) and every other file C99 code with embedded PENCIL (#pragma scop/#pragma endscop).  There is currently no way to override this behaviour.  PENCIL files are optimized using pencil-optimizer and ppcg; embedded PENCIL files with ppcg only.

CC=pencilcc (globally or by build utilitity) won't work; pencilcc uses this to determine which compiler to call and would potentially call itself.

The directories example/plain and example/cext contain scripts (example.sh) that call pencilcc to demonstrate the behaviour.



Known Issues
============

- pencilcc assumes the compiler accepts gcc command line syntax
- pencilcc assumes the compiler invocation includes linking; i.e. the options -c (compile to .o) and -E (precompile) are not recognized 
- Some warnings are unavoidable (e.g. unkonwn attribute)
- ppcg --version reports UNKNOWN for its own version

Untested features:
- Any --with-PACKAGE option other than bundled
- Systems other than Ubuntu 13.10
- make check, or testing in general



Future Features
===============

- Run pencilcc as compile prefix (like libtool) instead of replacement (like mpicc)
- Detect -c and -E (+ others) compile modes
- Honor -x switch
- make check
- make dist
- Support for more non-cc (ppcg, pencil-optimizer) command line options
