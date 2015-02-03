#! /bin/sh

SCALA_HOME=./scala
mkdir -p $SCALA_HOME
wget http://www.scala-lang.org/files/archive/scala-2.10.4.tgz -O /tmp/scala-2.10.4.tgz 
tar xf /tmp/scala-2.10.4.tgz --strip-component=1 -C $SCALA_HOME
rm /tmp/scala-2.10.4.tgz
