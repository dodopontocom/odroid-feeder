#!/bin/bash
BASEDIR=$(dirname $0)

remove.acento() {
  local str ret_str
  str=$1
  ret_str="$(echo "$str" | sed 's/áÁàÀãÃâÂéÉêÊíÍóÓõÕôÔúÚçÇ/aAaAaAaAeEeEiIoOoOoOuUcC/g')"
  echo $ret_str
}
