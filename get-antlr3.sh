#! /bin/sh

ANTLR_HOME=./antlr3
mkdir -p $ANTLR_HOME
wget http://www.antlr3.org/download/antlr-3.5.2-complete-no-st3.jar -O $ANTLR_HOME/antlr3.jar
wget http://www.antlr3.org/share/1169924912745/antlr3-task.zip -O /tmp/antlr3-task.zip
unzip /tmp/antlr3-task.zip -d /tmp/antlr3-task
cp /tmp/antlr3-task/antlr3-task/ant-antlr3.jar $ANTLR_HOME/ant-antlr3.jar
rm -rf /tmp/antlr3-task /tmp/antlr3-task.zip
