
#!/bin/bash
BASEDIR=$(dirname $0)

feed.init() {
  local user_log keyboard1
  keyboard1=$1
  
  user_log=${BASEDIR}/${logs}/${message_chat_id[$id]}_${message_from_first_name}
  
  if [[ ! -d $user_log ]]; then					
    mkdir -p $user_log
  fi
  echo "$(date +%H:%M:%S) - comando /${pets_name} executado" >> $user_log/$(date +%Y%m%d).log
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "*${pets_action} ... Estou com fome ${message_from_first_name} ...*" \
        --reply_markup "$keyboard1"
}
