#! /bin/sh
set -e # Fail if any subcommand fails

POLYBENCH_HOME=./polybench
wget http://web.cse.ohio-state.edu/~pouchet/software/polybench/download/polybench-c-3.2.tar.gz -O /tmp/polybench-c-3.2.tar.gz
mkdir -p ${POLYBENCH_HOME}
tar xf /tmp/polybench-c-3.2.tar.gz --strip-component=1 -C ${POLYBENCH_HOME}
rm /tmp/polybench-c-3.2.tar.gz
