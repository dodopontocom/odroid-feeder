
#!/bin/bash
BASEDIR=$(dirname $0)

user.register() {
  local user_name user_last_name user_id message admins_id tmp_pedido

  tmp_pedido="/tmp/pedido_cadastro.log"
  user_id=$1
  echo "$user_id" > $tmp_pedido
  user_name=$2
  user_last_name=$3
  admins_id=($(cat ${BASEDIR}/.admins_id))

  message="*Pedido de cadastro*\n"
  message+="Nome: ${user_name} ${user_last_name}\n"
  message+="Id: ${user_id}\n"
  message+="*Aceitar?*"
  
  for a in ${admins_id[@]}; do
    ShellBot.sendMessage --chat_id $a --text "$(echo -e ${message})" \
        --reply_markup "$keyboard_accept" --parse_mode markdown
  done

  message="Um pedido de cadastro foi enviado aos administrados do Bot"
  ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" \
        --parse_mode markdown
  message="Em breve você poderá continuar o cadastro do seu pet"
  ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" \
        --parse_mode markdown
  message="Aguarde a aprovação..."
  ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" \
        --parse_mode markdown
}
user.add() {
  local user_id tmp_pedido registrados admins_id message

  tmp_pedido="/tmp/pedido_cadastro.log"

  if [[ $tmp_pedido ]]; then

    admins_id=($(cat ${BASEDIR}/.admins_id))
    user_id=$(cat $tmp_pedido)
    registrados=${BASEDIR}/.id_registrados
    if [[ ! $(cat $registrados | grep $user_id) ]]; then
      echo $user_id >> $registrados
      if [[ $? -eq 0 ]]; then
        for a in ${admins_id[@]}; do
          message="Cadastro aceito - id: ${user_id}"
          ShellBot.sendMessage --chat_id $a --text "$(echo -e ${message})" \
              --parse_mode markdown
        done
        
        message="Seu cadastro foi aceito!"
        ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" \
          --parse_mode markdown
        
        message="Agora você pode começar cadastrando o seu pet"
        ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" \
          --parse_mode markdown
        
        message="\`Começando aqui\` /start"
        ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" \
          --parse_mode markdown
      
      fi
    else
      for a in ${admins_id[@]}; do
          message="id: ${user_id} - já cadastrado"
          ShellBot.sendMessage --chat_id $a --text "$(echo -e ${message})" \
              --parse_mode markdown
      done
    fi
  else
    for a in ${admins_id[@]}; do
      message="Pedido cancelado..."
      ShellBot.sendMessage --chat_id $a --text "$(echo -e ${message})" \
              --parse_mode markdown
    done
  fi
}
user.donot() {
  local user_id tmp_pedido registrados admins_id

  tmp_pedido="/tmp/pedido_cadastro.log"

}
