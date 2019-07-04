#!/bin/bash

#sleep para funcionar melhor no startup do sistema
sleep 10

# Importando API
BASEDIR=$(dirname $0)
echo ${BASEDIR}
source ${BASEDIR}/ShellBot.sh
source ${BASEDIR}/functions/selfie.sh
source ${BASEDIR}/functions/start.sh

logs=${BASEDIR}/../logs

# Token do bot
if [[ ! -z $1 ]]; then
	bot_token=$1
else
	bot_token=$(cat ${BASEDIR}/../.token)
fi

# Inicializando o bot
ShellBot.init --token "$bot_token" --monitor --flush

ShellBot.username

servo.function () {
	if [[ $(cat ${BASEDIR}/.allowed_id | grep "${callback_query_message_chat_id[$id]}") ]]; then
		ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
					--text "Alimentando seu pet..."
		servo.sh
		sleep 3
		selfie.shot
	else
		ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
			--text "Desculpe, você não tem autorização para essa operação..."
	fi
	return 0
}
servo2.function () {
	if [[ $(cat ${BASEDIR}/.allowed_id | grep "${callback_query_message_chat_id[$id]}") ]]; then
		ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
					--text "Colocando água..."
		servo2.sh
		sleep 3
		selfie.shot
	else
		ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
			--text "Desculpe, você não tem autorização para essa operação..."
	fi
	return 0
}

# Limpa o array que irá receber a estrutura inline_button e suas configurações.
botao1=''

ShellBot.InlineKeyboardButton --button 'botao1' --line 1 --text 'Alimentar 250g' --callback_data 'btn_feed1'
ShellBot.InlineKeyboardButton --button 'botao1' --line 1 --text 'Água 500ml' --callback_data 'btn_water1'
ShellBot.InlineKeyboardButton --button 'botao1' --line 2 --text 'Alimentar 150g' --callback_data 'btn_feed2'
ShellBot.InlineKeyboardButton --button 'botao1' --line 2 --text 'Água 250ml' --callback_data 'btn_water2'
ShellBot.InlineKeyboardButton --button 'botao1' --line 3 --text 'Verificar Potes 📷' --callback_data 'btn_foto'
ShellBot.InlineKeyboardButton --button 'botao1' --line 3 --text 'Ajuda ⁉️' --callback_data 'btn_ajuda'

ShellBot.regHandleFunction --function servo.function --callback_data btn_feed1
ShellBot.regHandleFunction --function servo.function --callback_data btn_feed2
ShellBot.regHandleFunction --function servo2.function --callback_data btn_water1
ShellBot.regHandleFunction --function servo2.function --callback_data btn_water2
ShellBot.regHandleFunction --function selfie.shot --callback_data btn_foto
ShellBot.regHandleFunction --function start.sendGreetings --callback_data btn_ajuda

keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'botao1')"

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
		# Verifica se a mensagem enviada pelo usuário é um comando válido.
		case ${message_text[$id]} in
			"/hello")	# bot comando
				# Envia a mensagem anexando o teclado "$keyboard1"
				if [[ ! -d ${logs}/${message_chat_id[$id]}_${message_from_first_name} ]]; then
					mkdir ${logs}/${message_chat_id[$id]}_${message_from_first_name}
				fi	
				ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "*Pois não ${message_from_first_name} ...*" \
							--reply_markup "$keyboard1" \																		--parse_mode markdown
			;;
		esac
	) & # Utilize a thread se deseja que o bot responda a várias requisições simultâneas.
	done
done
#FIM
