pencil-driver
=============

Driver for PENCIL compile toolchain


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

Installation instructions for Ubuntu 13.10 (Utopic Unicorn):

0) sudo apt-get install build-essential pkg-config libgmp-dev libclang-dev ant python3
1) git clone https://github.com/Meinersbur/pencil-driver.git
2) cd pencil-driver
3) git submodule update --init --recursive
4) ./get-scala.sh
5) ./get-antlr3.sh
6) ./autogen.sh
7) ./configure
8) make

Be aware that this creates directories pencil-driver/scala and pencil-driver/antlr3 that are required even after make install.


