#!/bin/bash
#
BASEDIR=$(dirname $0)

pets_name=$(tail -1 ${BASEDIR}/.pets_name | cut -d':' -f1)

start.sendGreetings() {
  local message txt name
  name=$1
  txt=${BASEDIR}/texts/start.txt
  
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
