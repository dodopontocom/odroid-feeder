#!/bin/bash
BASEDIR=$(dirname $0)

cron.agendar() {
  local user_id user_name message cron

  user_id=$1
  user_name=$2
  cron=${BASEDIR}/logs/${user_id}_${user_name}/cron.tab
  
  if [[ $(ls $cron) ]]; then
  	message="Diga um novo horário para alimentar:"
  	ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})"
	message="Hora:"
	ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" \
        	--reply_markup "$(ShellBot.ForceReply)"
  else
  	message="Agende um horário para alimentar:"
  	ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})"
	message="Hora:"
	ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})" \
        	--reply_markup "$(ShellBot.ForceReply)"
  fi
}
cron.create() {

	local cron re message user_id user_name hora
  
	user_id=$1
  	user_name=$2
	hora=$3
    re='^[:0-9]+$'

  	cron=${BASEDIR}/logs/${user_id}_${user_name}/cron.tab
  
  if [[ $hora =~ $re ]]; then
  	message="Adicionando horário ao sistema de agenda"
  	ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})"
	echo "$hora" > $cron
	if [[ $? -eq 0 ]]; then
  		message="Horario atualizado"
  		ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})"
		message="O bot irá alimentar todos os dias às $(cat $cron)"
  		ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})"
  		message="Para cancelar pressione aqui /cancelar"
  		ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})"
	else
  		message="Erro, tente novamente /agendar"
  		ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})"
	fi

  else
	message="Horário não é válido (exemplo de horário válido - 12:15)\n"
	message+="tente novamente /agendar"
  	ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})"
  fi
}
cron.cancel() {
	local cron message user_id user_name
  
	user_id=$1
  	user_name=$2
  	cron=${BASEDIR}/logs/${user_id}_${user_name}/cron.tab

	echo "" > $cron
	if [[ $? -eq 0 ]]; then
  		message="Agendamentos Cancelados"
		  message+="Para Agendar, pressione aqui /agendar"
  		ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})"
	else
		message="Não há agendamendos ativos"
		message+="Para Agendar, pressione aqui /agendar"
  		ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})"
	fi
}