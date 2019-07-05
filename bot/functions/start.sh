#!/bin/bash
#
BASEDIR=$(dirname $0)

start.sendGreetings() {
  local message txt name user_id user_log pets_info pets_name
  name=$1
  txt=${BASEDIR}/texts/start.txt

  if [[ -z $name ]]; then
    user_id=${callback_query_message_chat_id[$id]}  
    echo $user_id
    user_log=${BASEDIR}/logs/${user_id}_${callback_query_from_first_name}
    echo $user_log
    pets_info=${user_log}/pets_info.txt
    echo $pets_info

    pets_name=$(cat $pets_info | grep ^nome | tail -1 | cut -d':' -f2 | cut -d' ' -f1 | tr '[:upper:]' '[:lower:]')
    echo $pets_name
    
    message="*Opção Ajuda*"
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e $(cat ${txt}))" --parse_mode markdown
    message="Comece pressionando aqui /${pets_name}"
    sleep 5
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown    
  else
    user_id=${message_chat_id[$id]}  
    echo $user_id
    user_log=${BASEDIR}/logs/${user_id}_${message_from_first_name}
    echo $user_log
    pets_info=${user_log}/pets_info.txt
    echo $pets_info

    pets_name=$(cat $pets_info | grep ^nome | tail -1 | cut -d':' -f2 | cut -d' ' -f1 | tr '[:upper:]' '[:lower:]')
    echo $pets_name
    
    message="*Olá ${name}*"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e $(cat ${txt}))" --parse_mode markdown
    message="Comece pressionando aqui /${pets_name}"
    sleep 5
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
  
  
}
