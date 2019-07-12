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
#############Botoes dias da semana#########################################################
botao2=''
checked=✅
unchecked=➖
dias=('seg' 'ter' 'qua' 'qui' 'sex' 'sab' 'dom')
ShellBot.InlineKeyboardButton --button 'botao2' --line 1 --text "${unchecked} ${dias[0]}" --callback_data 'btn_seg'
ShellBot.InlineKeyboardButton --button 'botao2' --line 1 --text "${unchecked} ${dias[1]}" --callback_data 'btn_ter'
ShellBot.InlineKeyboardButton --button 'botao2' --line 1 --text "${unchecked} ${dias[2]}" --callback_data 'btn_qua'
ShellBot.InlineKeyboardButton --button 'botao2' --line 1 --text "${unchecked} ${dias[3]}" --callback_data 'btn_qui'
ShellBot.InlineKeyboardButton --button 'botao2' --line 1 --text "${unchecked} ${dias[4]}" --callback_data 'btn_sex'
ShellBot.InlineKeyboardButton --button 'botao2' --line 1 --text "${unchecked} ${dias[5]}" --callback_data 'btn_sab'
ShellBot.InlineKeyboardButton --button 'botao2' --line 1 --text "${unchecked} ${dias[6]}" --callback_data 'btn_dom'

ShellBot.regHandleFunction --function cron.seg --callback_data btn_seg
ShellBot.regHandleFunction --function cron.ter --callback_data btn_ter
ShellBot.regHandleFunction --function cron.qua --callback_data btn_qua
ShellBot.regHandleFunction --function cron.qui --callback_data btn_qui
ShellBot.regHandleFunction --function cron.sex --callback_data btn_sex
ShellBot.regHandleFunction --function cron.sab --callback_data btn_sab
ShellBot.regHandleFunction --function cron.dom --callback_data btn_dom

keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'botao2')"
##############################################################################################

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
