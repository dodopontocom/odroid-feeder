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
source ${BASEDIR}/motion.sh

logs=${BASEDIR}/logs

# Token do bot
bot_token=$(cat ${BASEDIR}/.token)

# Inicializando o bot
ShellBot.init --token "$bot_token" --monitor --flush

ShellBot.username
servo_function () {
	if [[ $(cat ${BASEDIR}/.allowed_id | grep "${callback_query_message_chat_id[$id]}") ]]; then
		msg="*Pet alimentado com sucesso...*"
		ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
					--text "*alimentando seu pet...*"
		snap 1
		sleep 3
		servo.sh && sleep 1.8 && servo.sh && sleep 1.8 && servo.sh
		sleep 3 
		file=$(find /tmp/ -iname "*20*.jpg" 2>/dev/null | sort -n | tail -1)
		echo $file
		# Envia mensagem
		ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
							--text "$(echo -e $msg)" \
							--parse_mode markdown
		ShellBot.sendPhoto --chat_id ${callback_query_message_chat_id[$id]} --photo @$file \
								--caption "*confira...*"

		#descomentar linha abaixo quando estiver funcionando o feeder ja com ração para enviar foto do pote com ração
		#snap
		cat /home/odroid/motion.pid
		kill -9 $(cat /home/odroid/motion.pid)
	else
		ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
			--text "sorry, você não tem autorização para essa operação..."
	fi

	return 0
}

ShellBot.username
motion_function () {
	stamp=$(date +%Y%m%d%H%M)
	snap
	file=$(find /tmp/ -iname "*$stamp*snapshot.jpg" 2>/dev/null | sort -n | tail -1)
	if [[ -z $file ]]; then
		msg="*Ops, algo de errado não deu certo...*\n"
		ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
							--text "$(echo -e $msg)" \
							--parse_mode markdown
	else
		# Envia uma notificação em resposta ao botão pressionado.
		ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
									--text "tirando foto..."
		ShellBot.sendPhoto --chat_id ${callback_query_message_chat_id[$id]} --photo @$file \
								--caption "*meu pote está meio vazio ou meio cheio?...*"
	fi
	mv -v $file ${logs}/${callback_query_message_chat_id[$id]}_${callback_query_message_chat_first_name}/
	return 0
}

# Limpa o array que irá receber a estrutura inline_button e suas configurações.
botao1=''

# INLINE_BUTTON - CONFIGURAÇÕES.
#
# Cria e define as configurações do objeto inline_button,
# armazenando-as na variável 'botao1'.
# O parâmetro '-l, --line' determinada a posição do objeto na exibição.
# É possível especificar um ou mais botões na mesma linha. Neste caso
# os serão redimencionados e dispostos em paralelo.
#
# Layout defino abaixo:
#
#   [                  Blog                 ]  	-> linha 1
#   [ Telegram (Grupo) ] [ Telegram (Canal) ]   -> linha 2
#   [                 Github                ]	-> linha 3
#
#
# 
# Quando um botão é pressionado o usuário é redirecionado para o endereço configurando em '--url'
ShellBot.InlineKeyboardButton --button 'botao1' --line 1 --text 'Alimentar' --callback_data 'btn_feed'		# linha 1
ShellBot.InlineKeyboardButton --button 'botao1' --line 2 --text 'Verificar' --callback_data 'btn_foto'		# linha 2

ShellBot.regHandleFunction --function servo_function --callback_data btn_feed
ShellBot.regHandleFunction --function motion_function --callback_data btn_foto

# Cria o objeto inline_keyboard contendo os elementos armazenados na variável 'botao1'
# É retornada a nova estrutura e armazena em 'keyboard1'.
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
