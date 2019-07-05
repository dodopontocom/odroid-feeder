#!/bin/bash
BASEDIR=$(dirname $0)

source ${BASEDIR}/selfie.sh

servo.food () {
	ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
					--text "Alimentando seu pet..."
	servo1.sh
	sleep 3
	selfie.shot
}

servo.water () {
	ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
					--text "Alimentando seu pet..."
	servo2.sh
	sleep 3
	selfie.shot
}
