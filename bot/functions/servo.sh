#!/bin/bash
BASEDIR=$(dirname $0)

source ${BASEDIR}/functions/selfie.sh
source ${BASEDIR}/run-servo.sh

servo.food () {
	local btn_type
	
	btn_type=$callback_query_data
	
	ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
					--text "Alimentando seu pet..."
	
	if [[ $btn_type == "btn_feed1" ]]; then
		#250g
		servo.trigger "1.6"
		selfie.shot
	elif [[ $btn_type == "btn_feed2" ]]; then
		#150g
		servo.trigger "0.6"
		selfie.shot
	fi
}

servo.water () {
	local btn_type
	
	btn_type=$callback_query_data
	
	ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
					--text "Colocando água para seu pet..."
	if [[ $btn_type == "btn_water1" ]]; then
		#500ml
		water.trigger "12"
		selfie.shot
	elif [[ $btn_type == "btn_water2" ]]; then
		#250ML
		water.trigger "6"
		selfie.shot
	fi
}
