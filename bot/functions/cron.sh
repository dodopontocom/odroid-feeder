#!/bin/bash
BASEDIR=$(dirname $0)

cron.agendar() {
  local user_id user_name message cron

  user_id=$1
  user_name=$2
  cron=${BASEDIR}/logs/${user_id}_${user_name}/cron.tab
  
  if [[ $(ls $cron) ]]; then
  	message="Diga um novo horario para alimentar:"
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
  	message="Adicionando horario ao sistema de agenda"
  	ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})"
	echo "$hora" > $cron
	if [[ $? -eq 0 ]]; then
  		message="Horario atualizado"
  		ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})"
		message="O bot ira alimentar todos os dias as $(cat $cron)"
  		ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})"
  		message="Para cancelar pressione aqui /cancelar"
  		ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})"
	else
  		message="Erro, tente novamente /agendar"
  		ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})"
	fi

  else
	message="Horario nao e valido (exemplo de horario valido - 12:15)\n"
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
  		ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})"
	else
		message="Nao ha agendamendos ativos"
  		ShellBot.sendMessage --chat_id $user_id --text "$(echo -e ${message})"
	fi
}
cron.seg() {
	if [[ ${_CHECKED} ]]; then
		unset _CHECKED
	else
		export _CHECKED='1'
	fi
}
cron.ter() {
	local cron message user_id user_name
	echo ter
}
cron.qua() {
	local cron message user_id user_name
	echo qua
}
cron.qui() {
	local cron message user_id user_name
	echo qui
}
cron.sex() {
	local cron message user_id user_name
	echo sex
}
cron.sab() {
	local cron message user_id user_name
	echo sab
}
cron.dom() {
	local cron message user_id user_name
	echo dom
}
