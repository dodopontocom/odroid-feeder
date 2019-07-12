#!/bin/bash

#sleep para funcionar melhor no startup do sistema
#sleep 10

# Importando API
BASEDIR=$(dirname $0)
echo ${BASEDIR}
source ${BASEDIR}/ShellBot.sh
source ${BASEDIR}/functions/selfie.sh
source ${BASEDIR}/functions/start.sh
source ${BASEDIR}/functions/feed.sh
source ${BASEDIR}/functions/pet.sh
source ${BASEDIR}/functions/servo.sh
source ${BASEDIR}/functions/user.sh
source ${BASEDIR}/functions/support.sh
source ${BASEDIR}/functions/cron.sh
source ${BASEDIR}/functions/bot-teclados.sh

id_check=${BASEDIR}/.id_registrados
admins_id=${BASEDIR}/.admins_id

# Token do bot
if [[ ! -z $1 ]]; then
	bot_token=$1
else
	bot_token=$(cat ${BASEDIR}/../.token)
fi

# Inicializando o bot
ShellBot.init --token "$bot_token" --monitor --flush

ShellBot.username

while :
do
	# Obtem as atualizações
	ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
	
	# Lista o índice das atualizações
	for id in $(ShellBot.ListUpdates)
	do
	# Inicio thread
	(
		ShellBot.watchHandle --callback_data ${callback_query_data[$id]}

		if [[ ${message_entities_type[$id]} == bot_command ]]; then
			if [[ $(cat $id_check | grep ${message_from_id}) ]]; then
				pets_info=${BASEDIR}/logs/${message_chat_id[$id]}_${message_from_first_name}/pets_info.txt
				if [[ -f $pets_info ]]; then
					pets_name=$(cat $pets_info | grep ^nome | tail -1 | cut -d':' -f2 | cut -d' ' -f1 | tr '[:upper:]' '[:lower:]')
					case ${message_text[$id]} in
						"/${pets_name}")
							feed.init "${keyboard1}"
						;;
						"/start")
							start.sendGreetings "${message_from_first_name}"
						;;
						"/agendar")
							cron.agendar "${message_from_id}" "${message_from_first_name}"
						;;
						"/cancelar")
							cron.cancel "${message_from_id}" "${message_from_first_name}"
						;;
					esac
				else
					case ${message_text[$id]} in
						"/start")
							pet.register
						;;
					esac
				fi
			else
				case ${message_text[$id]} in
					"/cadastro")
						user.register "${message_from_id}" "${message_from_first_name}" "${message_from_last_name}"
					;;
					"/start")
						start.sendGreetings "${message_from_first_name}"
					;;
				esac
			fi
			if [[ $(cat $admins_id | grep ${message_from_id}) ]]; then
				case ${message_text[$id]} in
					"/reset")
						support.reset
				esac
			fi
		fi
		if [[ ${message_reply_to_message_message_id[$id]} ]]; then
			case ${message_reply_to_message_text[$id]} in
				'Nome:')
					pet.nome "${message_text[$id]}"
				;;
				'Animal:')
					pet.animal "${message_text[$id]}"
				;;
				'Dono:')
					pet.dono "${message_text[$id]}"
				;;
				'Hora:')
					cron.create "${message_from_id}" "${message_from_first_name}" "${message_text[$id]}"
				;;
			esac
		fi
	) &
	done
done
#FIM
