#!/bin/bash
#
source ${BASEDIR}/functions/random.sh

selfie.shot() {
  local message random_file_name error_message user_id user_log timestamp user_name log_message
  
  random_file_name=$(random.helper)
  message="*tirando uma foto dos potes para confirmação 🤳*"
  error_message="*ops... agora não posso*\n"
  error_message+="...estou transmitindo ao vivo!"
  
  user_name=${message_from_first_name[$id]}
  if [[ ${callback_query_message_from_first_name[$id]} ]]; then
    user_name=${callback_query_message_from_first_name[$id]}
  fi
  user_id=${message_chat_id[$id]}  
  if [[ ${callback_query_message_chat_id[$id]} ]]; then
    user_id=${callback_query_message_chat_id[$id]}
  fi
  user_log=${BASEDIR}/logs/${user_id}_${user_name}

  ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" --parse_mode markdown
  
  fswebcam -r 1280x720 /tmp/${random_file_name}.jpg
  if [[ $? -eq 0 ]]; then
    ShellBot.sendPhoto --chat_id $user_id --photo @/tmp/${random_file_name}.jpg
    timestamp=$(date +%H:%M:%S)
		log_message="${timestamp} - imagem enviada com sucesso"
    echo $log_message >> $user_log/$(date +%Y%m%d).log
		echo $log_message #log into main log
    
  else
    ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${error_message})" --parse_mode markdown
    timestamp=$(date +%H:%M:%S)
		log_message="${timestamp} - erro ao enviar imagem para usuário"
    echo $log_message >> $user_log/$(date +%Y%m%d).log
		echo $log_message #log into main log
  fi   
}
