#!/bin/bash
#
# script: InlineKeyboard.sh
#
# Para melhor compreensão foram utilizados parâmetros longos nas funções; Podendo
# ser substituidos pelos parâmetros curtos respectivos.

#sleep para funcionar melhor no startup do sistema
sleep 10

# Importando API
BASEDIR=$(dirname $0)
echo ${BASEDIR}
source ${BASEDIR}/ShellBot.sh
source ${BASEDIR}/functions/selfie.sh

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
		msg="*Pet alimentado com sucesso...*"
		ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
					--text "*alimentando seu pet...*"
		servo.sh
		sleep 3
		selfie.shot
	else
		ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
			--text "sorry, você não tem autorização para essa operação..."
	fi
	return 0
}

# Limpa o array que irá receber a estrutura inline_button e suas configurações.
botao1=''

ShellBot.InlineKeyboardButton --button 'botao1' --line 1 --text 'Alimentar' --callback_data 'btn_feed'		# linha 1
ShellBot.InlineKeyboardButton --button 'botao1' --line 2 --text 'Verificar' --callback_data 'btn_foto'		# linha 2

ShellBot.regHandleFunction --function servo.function --callback_data btn_feed
ShellBot.regHandleFunction --function selfie.shot --callback_data btn_foto

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
