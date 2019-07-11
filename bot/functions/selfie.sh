#!/bin/bash
#
source ${BASEDIR}/functions/random.sh

selfie.shot() {
  local message random_file_name error_message user_id
  random_file_name=$(random.helper)
  message="*tirando uma foto 🤳*"
  error_message="*ops... agora não posso*\n"
  error_message+="...estou transmitindo ao vivo!"
  user_id=${message_chat_id[$id]}
  if [[ ${callback_query_message_chat_id[$id]} ]]; then
    user_id=${callback_query_message_chat_id[$id]}
  fi

  ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" --parse_mode markdown
  fswebcam -r 1280x720 /tmp/${random_file_name}.jpg
  if [[ $? -eq 0 ]]; then
    ShellBot.sendPhoto --chat_id $user_id --photo @/tmp/${random_file_name}.jpg
  else
    ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${error_message})" --parse_mode markdown
  fi   
}
