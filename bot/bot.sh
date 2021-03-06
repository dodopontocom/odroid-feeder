#!/bin/bash

#sleep para funcionar melhor no startup do sistema
sleep 10

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

id_check=${BASEDIR}/.id_registrados
admins_id=${BASEDIR}/.admins_id
logs=${BASEDIR}/logs

# Token do bot
if [[ ! -z $1 ]]; then
	bot_token=$1
else
	bot_token=$(cat ${BASEDIR}/../.token)
fi

# Inicializando o bot
ShellBot.init --token "$bot_token" --monitor --flush
my_id=11504381
message="Fui reiniciado"
ShellBot.sendMessage --chat_id $my_id --text "$(echo -e ${message})"

############Botao para admins aceitarem novos cadastros#######################################
botao=''

ShellBot.InlineKeyboardButton --button 'botao' --line 1 --text 'SIM' --callback_data 'btn_s'
ShellBot.InlineKeyboardButton --button 'botao' --line 1 --text 'NAO' --callback_data 'btn_n'

ShellBot.regHandleFunction --function user.add --callback_data btn_s
ShellBot.regHandleFunction --function user.donot --callback_data btn_n

keyboard_accept="$(ShellBot.InlineKeyboardMarkup -b 'botao')"
##############################################################################################

#############Botao para alimentar pet#########################################################
botao1=''

ShellBot.InlineKeyboardButton --button 'botao1' --line 1 --text 'Alimentar ~250g' --callback_data 'btn_feed1'
ShellBot.InlineKeyboardButton --button 'botao1' --line 1 --text 'Água ~500ml' --callback_data 'btn_water1'
ShellBot.InlineKeyboardButton --button 'botao1' --line 2 --text 'Alimentar ~150g' --callback_data 'btn_feed2'
ShellBot.InlineKeyboardButton --button 'botao1' --line 2 --text 'Água ~250ml' --callback_data 'btn_water2'
ShellBot.InlineKeyboardButton --button 'botao1' --line 3 --text 'Verificar Potes 📷' --callback_data 'btn_foto'
ShellBot.InlineKeyboardButton --button 'botao1' --line 3 --text 'Ajuda ⁉️' --callback_data 'btn_ajuda'

ShellBot.regHandleFunction --function servo.food --callback_data btn_feed1
ShellBot.regHandleFunction --function servo.food --callback_data btn_feed2
ShellBot.regHandleFunction --function servo.water --callback_data btn_water1
ShellBot.regHandleFunction --function servo.water --callback_data btn_water2
ShellBot.regHandleFunction --function selfie.shot --callback_data btn_foto
ShellBot.regHandleFunction --function start.sendGreetings --callback_data btn_ajuda

keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'botao1')"
##############################################################################################

while :
do
	# Obtem as atualizações
	ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
	
	################# check if any user needs to be alerted about lunch time
		#cron=${BASEDIR}/logs/${user_id}_${user_name}/cron.tab
		for file in $(find $logs -name "cron.tab"); do
			hora=$(cat $file)
			if [[ "$(date +%H:%M)" = "${hora}" ]]; then
				sleep 29
				servo.food $file
				servo.water $file
			fi
		done
		########################################################################
	
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
