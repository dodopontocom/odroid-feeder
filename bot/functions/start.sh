#!/bin/bash
#
BASEDIR=$(dirname $0)

start.sendGreetings() {
  local message txt
  txt=${BASEDIR}/texts/start.txt
  message="*olá *"

  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "asdasdasd" --parse_mode markdown
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e $(cat ${txt}))" --parse_mode markdown
}
