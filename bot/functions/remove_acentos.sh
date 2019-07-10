#!/bin/bash
BASEDIR=$(dirname $0)

sed_file=${BASEDIR}/functions/sed_remove_acentos.sed

remove.acento() {
  local str ret_str
  str=$1
  ret_str=$(echo "$str" | sed -f $sed_file)
  echo $ret_str
}
