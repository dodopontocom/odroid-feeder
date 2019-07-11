
#!/bin/bash
BASEDIR=$(dirname $0)

feed.init() {
  local user_log keyboard1 pets_info pets_name message log_message

  keyboard1=$1
  
  user_log=${BASEDIR}/logs/${message_chat_id[$id]}_${message_from_first_name}
  pets_info=${user_log}/pets_info.txt
  pets_name=$(cat $pets_info | grep ^nome | tail -1 | cut -d':' -f2 | cut -d' ' -f1 | tr '[:upper:]' '[:lower:]')
  pets_action="$(cat $pets_info | grep ^acao | tail -1 | cut -d':' -f2)"
  pets_dono="$(cat $pets_info | grep ^dono | tail -1 | cut -d':' -f2)"

  log_message="$(date +%H:%M:%S) - comando /${pets_name} executado"
  echo $log_message >> $user_log/$(date +%Y%m%d).log
  echo $log_message # log into main log
  
  message="*${pets_action} ... Estou com fome ${pets_dono} ...*"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" \
        --reply_markup "$keyboard1" --parse_mode markdown
}
