#!/bin/bash
#
BASEDIR=$(dirname $0)

start.sendGreetings() {
  local message txt
  txt=${BASEDIR}/texts/start.txt
  
  message="*Opção Ajuda*"
  
  ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e $(cat ${txt}))" --parse_mode markdown
}
