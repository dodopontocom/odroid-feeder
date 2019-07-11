#!/bin/bash
BASEDIR=$(dirname $0)

servo.trigger() {
  local time
  time=$1
  python3 ${BASEDIR}/servo.py $time
}
water.trigger() {
  local time
  time=$1
  python3 ${BASEDIR}/water.py $time
}

#sudo chown root.sys /dev/gpiomem
#sudo chown root.odroid /dev/gpiomem
