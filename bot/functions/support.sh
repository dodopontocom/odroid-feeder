#!/bin/bash
BASEDIR=$(dirname $0)

support.reset() {
  local logs admins_id message registred_id
  
  admins_id=($(cat ${BASEDIR}/.admins_id))
  registred_id=${BASEDIR}/.id_registrados
  logs=${BASEDIR}/logs
  
  if [[ $(echo ${admins_id[@]} | grep ${message_chat_id[$id]}) ]]; then
    folders=($(ls $logs))
    for f in $(echo ${folders[@]}); do    
    	rm -r $logs/$f
    done
    echo "" > $registred_id
  fi

  message="reset done"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
}
