#!/bin/bash
#
BASEDIR=$(dirname $0)

start.sendGreetings() {
  local message txt name user_id user_log pets_info pets_name
  name=$1
  txt=${BASEDIR}/texts/start.txt
  

  user_id=${message_chat_id[$id]}  
  user_log=${BASEDIR}/logs/${message_chat_id[$id]}_${message_from_first_name}
  pets_info=${user_log}/pets_info.txt
  
  pets_name=$(cat $pets_info | grep ^nome | tail -1 | cut -d':' -f2 | cut -d' ' -f1 | tr '[:upper:]' '[:lower:]')
  
  if [[ -z $name ]]; then 
    message="*Opção Ajuda*"
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e $(cat ${txt}))" --parse_mode markdown
    message="Comece pressionando aqui /${pets_name}"
    sleep 5
    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown    
  else
    message="*Olá ${name}*"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e $(cat ${txt}))" --parse_mode markdown
    message="Comece pressionando aqui /${pets_name}"
    sleep 5
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
  
  
}
