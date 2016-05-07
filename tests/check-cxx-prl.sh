#! /bin/sh
set -e # Fail if any subcommand fails

echo "pwd=`pwd`"
echo "PENCILCC=${PENCILCC}"
echo "TESTSRCDIR=${TESTSRCDIR}"
echo "TESTBUILDDIR=${TESTBUILDDIR}"



cd "${TESTBUILDDIR}"

cat > kernel.pencil.c <<- EOM
void kernel(int n, float A[static const restrict n]) {
	for (int i = 0; i<n; ++i) {
		A[i] = 0;
	}
}
EOM

cat > main.cpp <<- EOM
#include <cstdlib>
#include <iostream>
#include <cstring>

extern "C" void kernel(int n, float *A);

class Main {
	float A[128];

public:
	Main() {
		memset(A, 'c', sizeof(A));
		kernel(128, A);
		if (A[42] != 0)
			exit(EXIT_FAILURE);
		std::cout << "Success!\n";
		exit(EXIT_SUCCESS);
	}
};

int main() {
	Main();
	return EXIT_FAILURE;
}
EOM

${PENCILCC} -v -v -O3 --target=prl -w kernel.pencil.c main.cpp --cc-ld-prog=c++ --run
