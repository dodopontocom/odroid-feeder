#!/bin/bash
BASEDIR=$(dirname $0)

remove.acento() {
  local str ret_str
  str=$1
  echo "$str" > /tmp/nome
  ret_str=$(sed 'y/áÁàÀãÃâÂéÉêÊíÍóÓõÕôÔúÚçÇ/aAaAaAaAeEeEiIoOoOoOuUcC/' /tmp/nome)
  echo $ret_str
}
