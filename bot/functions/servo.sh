#!/bin/bash
BASEDIR=$(dirname $0)

source ${BASEDIR}/functions/selfie.sh
source ${BASEDIR}/run-servo.sh

servo.food () {
	local btn_type user_log log_message timestamp message
	
	user_log=${BASEDIR}/logs/${callback_query_message_chat_id[$id]}_${callback_query_from_first_name}
	btn_type=$callback_query_data
	
	ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
					--text "Alimentando seu pet..."
	
	if [[ $btn_type == "btn_feed1" ]]; then
		#250g
		servo.trigger "1.6"
		
		timestamp=$(date +%H:%M:%S)
		log_message="${timestamp} - 250g de ração foi despejado"
		message="Comando executado com sucesso às ${timestamp}"
		ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
					--text "$(echo -e ${message})" --parse_mode markdown
		echo $log_message >> $user_log/$(date +%Y%m%d).log
		echo $log_message #log into main log
					
		selfie.shot
		
	elif [[ $btn_type == "btn_feed2" ]]; then
		#150g
		servo.trigger "0.6"
		
		timestamp=$(date +%H:%M:%S)
		log_message="${timestamp} - 150g de ração foi despejado"
		message="Comando executado com sucesso às ${timestamp}"
		ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
					--text "$(echo -e ${message})" --parse_mode markdown
		echo $log_message >> $user_log/$(date +%Y%m%d).log
		echo $log_message #log into main log
		
		selfie.shot
	fi
}

servo.water () {
	local btn_type log_message timestamp message
	
	user_log=${BASEDIR}/logs/${callback_query_message_chat_id[$id]}_${callback_query_from_first_name}	
	btn_type=$callback_query_data
	
	ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
					--text "Colocando água para seu pet..."
	if [[ $btn_type == "btn_water1" ]]; then
		#500ml
		water.trigger "12"
		
		timestamp=$(date +%H:%M:%S)
		log_message="${timestamp} - 500ml de água foi despejado"
		message="Comando executado com sucesso às ${timestamp}"
		ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
					--text "$(echo -e ${message})" --parse_mode markdown
		echo $log_message >> $user_log/$(date +%Y%m%d).log
		echo $log_message #log into main log
		
		selfie.shot
		
	elif [[ $btn_type == "btn_water2" ]]; then
		#250ML
		water.trigger "6"
		
		timestamp=$(date +%H:%M:%S)
		log_message="${timestamp} - 350ml de água foi despejado"
		message="Comando executado com sucesso às ${timestamp}"
		ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
					--text "$(echo -e ${message})" --parse_mode markdown
		echo $log_message >> $user_log/$(date +%Y%m%d).log
		echo $log_message #log into main log
		
		selfie.shot
	fi
}
