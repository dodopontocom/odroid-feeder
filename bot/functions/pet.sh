#!/bin/bash
BASEDIR=$(dirname $0)

source ${BASEDIR}/functions/remove_acentos.sh

pet.register() {
  local user_log user_id pets_info sucess_msg message
  
  sucess_msg="$(date +%H:%M:%S) - iniciando cadastro do pet"
  user_id=${message_chat_id[$id]}  
  user_log=${BASEDIR}/logs/${message_chat_id[$id]}_${message_from_first_name}
  
  if [[ ! -d $user_log ]]; then					
    mkdir -p $user_log
  fi
  
  message="Qual o nome do seu pet?"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" \
  
  message="Nome:"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" \
        --reply_markup "$(ShellBot.ForceReply)"

  echo $sucess_msg >> $user_log/$(date +%Y%m%d).log
}
pet.nome() {
  local bnome nome sucess_msg message
  bnome=$1
  nome=$(remove.acento "$bnome")
  sucess_msg="$(date +%H:%M:%S) - pet $nome cadastrado"
  
  user_id=${message_chat_id[$id]}  
  user_log=${BASEDIR}/logs/${message_chat_id[$id]}_${message_from_first_name}
  pets_info=${user_log}/pets_info.txt
  
  message="É um dog um gato ou outro animal?"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
  
  message="Animal:"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" \
        --reply_markup "$(ShellBot.ForceReply)"
  
  echo "$sucess_msg" >> $user_log/$(date +%Y%m%d).log
  echo "nome:$nome" >> $pets_info
}

pet.animal() {
  local animal sucess_msg acao
  animal=$1
  sucess_msg="$(date +%H:%M:%S) - espécie $animal cadastrado"
  
  user_id=${message_chat_id[$id]}  
  user_log=${BASEDIR}/logs/${message_chat_id[$id]}_${message_from_first_name}
  pets_info=${user_log}/pets_info.txt
    
  echo "animal:$animal" >> $pets_info
  if [[ $animal =~ ([Dd]og|[Cc]achorro|[Cc]adela|[Cc]achorra) ]]; then
    echo "acao:🐶 auau" >> $pets_info
  elif [[ $animal =~ ([Gg]ato|[Gg]ata|[Cc]at|[Cc]achorra) ]]; then
    echo "acao:😾 miaowW" >> $pets_info
  else
    echo "acao:😾 🐶" >> $pets_info
  fi
  
  message="Como gosta de ser chamado pelo seu pet?"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
  
  message="Dono:"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" \
        --reply_markup "$(ShellBot.ForceReply)"
  
  echo "$sucess_msg" >> $user_log/$(date +%Y%m%d).log
}

pet.dono() {
  local dono sucess_msg acao
  dono=$1
  sucess_msg="$(date +%H:%M:%S) - dono $dono cadastrado"
  
  user_id=${message_chat_id[$id]}  
  user_log=${BASEDIR}/logs/${message_chat_id[$id]}_${message_from_first_name}
  pets_info=${user_log}/pets_info.txt
    
  echo "dono:$dono" >> $pets_info
  
  echo "$sucess_msg" >> $user_log/$(date +%Y%m%d).log
  
  sucess_msg="$(date +%H:%M:%S) - cadastro realizado com sucesso"
  echo "$sucess_msg" >> $user_log/$(date +%Y%m%d).log
  
  message="Cadastro realizado com sucesso"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
  
  message="O comando para me chamar é /$(cat $pets_info | grep ^nome | tail -1 | cut -d':' -f2 | cut -d' ' -f1 | tr '[:upper:]' '[:lower:]')"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
}

