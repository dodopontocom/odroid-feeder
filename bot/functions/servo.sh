#!/bin/bash
BASEDIR=$(dirname $0)

source ${BASEDIR}/functions/selfie.sh

servo.food () {
	local btn_type
	
	btn_type=$callback_query_data
	
	ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
					--text "Alimentando seu pet..."
	
	if [[ $btn_type == "btn_feed1" ]]; then
		echo feed1
		#250g
		#servo1.sh
		#sleep 3
		#servo1.sh
		#selfie.shot
	elif [[ $btn_type == "btn_feed2" ]]; then
		echo feed2
		#150g
		#servo1.sh
		#sleep 3
		#selfie.shot
	fi
}

servo.water () {
	local btn_type
	
	btn_type=$callback_query_data
	
	ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
					--text "Colocando água para seu pet..."
	if [[ $btn_type == "btn_water1" ]]; then
		echo water1
		#500ml
		#servo2.sh
		#sleep 3
		#servo2.sh
		#selfie.shot
	elif [[ $btn_type == "btn_water2" ]]; then
		echo water2
		#250ML
		#servo2.sh
		#sleep 3
		#selfie.shot
	fi
}
