#!/bin/bash
#
BASEDIR=$(dirname $0)

start.sendGreetings() {
  local message txt name user_id user_log pets_info pets_name registred_id
  name=$1
  txt=${BASEDIR}/texts/start.txt
  registred_id=${BASEDIR}/.id_registrados

  if [[ ${callback_query_message_chat_id[$id]} ]]; then
    user_id=${callback_query_message_chat_id[$id]}
    user_log=${BASEDIR}/logs/${user_id}_${callback_query_from_first_name}

    pets_info=${user_log}/pets_info.txt
    pets_name=$(cat $pets_info | grep ^nome | tail -1 | cut -d':' -f2 | cut -d' ' -f1 | tr '[:upper:]' '[:lower:]')
    
    message="*Opção Ajuda*"
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e $(cat ${txt}))" --parse_mode markdown
    
    if [[ $pets_name ]]; then
      message="Comece pressionando aqui /${pets_name}"
    elif [[ $(cat $registred_id | grep $user_id) ]]; then
      message="Comece pressionando aqui /start"
    else
      message="Comece pressionando aqui /cadastro"
    fi
    sleep 5
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  
  else
    user_id=${message_chat_id[$id]}
    user_log=${BASEDIR}/logs/${user_id}_${message_from_first_name}    
    
    pets_info=${user_log}/pets_info.txt
    pets_name=$(cat $pets_info | grep ^nome | tail -1 | cut -d':' -f2 | cut -d' ' -f1 | tr '[:upper:]' '[:lower:]')
    
    message="*Olá ${name}*"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e $(cat ${txt}))" --parse_mode markdown
    
    if [[ $pets_name ]]; then
      message="Comece pressionando aqui /${pets_name}"
    elif [[ $(cat $registred_id | grep $user_id) ]]; then
      message="Comece pressionando aqui /start"
    else
      message="Comece pressionando aqui /cadastro"
    fi
    sleep 5
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
}
