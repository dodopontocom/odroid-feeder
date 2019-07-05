#!/bin/bash
#
BASEDIR=$(dirname $0)

start.sendGreetings() {
  local message txt
  txt=${BASEDIR}/texts/start.txt
  message="*olá *"
  if [[ ! -z $callback_query_from_first_name ]]; then
    message+=${callback_query_from_first_name}
  else
    message+=${callback_query_from_id}
  fi
  ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e $(cat ${txt}))" --parse_mode markdown
}
