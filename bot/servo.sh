#!/bin/bash
$BASEDIR=$(dirname $0)

python3 ${BASEDIR}/init.py $1

#sudo chown root.sys /dev/gpiomem
#sudo chown root.odroid /dev/gpiomem

