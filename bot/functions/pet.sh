#!/bin/bash
BASEDIR=$(dirname $0)

pet.register() {
  local user_log user_id pets_info sucess_msg message
  
  sucess_msg="$(date +%H:%M:%S) - pet cadastrado com sucesso"
  user_id=${message_chat_id[$id]}  
  user_log=${BASEDIR}/logs/${message_chat_id[$id]}_${message_from_first_name}
  pets_info=${user_log}/pets_info.txt
  
  if [[ ! -d $user_log ]]; then					
    mkdir -p $user_log
  fi
  message="Qual o nome do seu pet?"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" \
        --parse_mode markdown
  message="Nome:"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" \
        --reply_markup "$(ShellBot.ForceReply)"

  echo $sucess_msg >> $user_log/$(date +%Y%m%d).log
}
pet.nome() {
  local nome sucess_msg message
  nome=$1
  sucess_msg="$(date +%H:%M:%S) - $nome cadastrado"
  
  user_id=${message_chat_id[$id]}  
  user_log=${BASEDIR}/logs/${message_chat_id[$id]}_${message_from_first_name}
  pets_info=${user_log}/pets_info.txt
  
  echo "$sucess_msg" >> $user_log/$(date +%Y%m%d).log
  echo "nome:$nome" >> $pets_info
  
  message="Animal:"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" \
        --reply_markup "$(ShellBot.ForceReply)"
}

pet.animal() {
  local animal sucess_msg
  animal=$1
  sucess_msg="$(date +%H:%M:%S) - $animal cadastrado"
  
  user_id=${message_chat_id[$id]}  
  user_log=${BASEDIR}/logs/${message_chat_id[$id]}_${message_from_first_name}
  pets_info=${user_log}/pets_info.txt
  
  echo "$sucess_msg" >> $user_log/$(date +%Y%m%d).log
  echo "animal:$animal" >> $pets_info

}

