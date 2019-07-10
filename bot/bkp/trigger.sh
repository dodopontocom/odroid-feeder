#!/bin/bash
#
# SCRIPT: BotDownloadFile.sh
#
# DESCRIÇÃO: Efetua download dos arquivos enviados para o privado, grupo ou canal.
#			 Em grupos/canais o bot precisa ser administrador para ter acesso a
#			 todas mensagens enviadas.
#
# Para melhor compreensão foram utilizados parâmetros longos nas funções; Podendo
# ser substituidos pelos parâmetros curtos respectivos.

# Importando API
source ShellBot.sh

# Token do bot
bot_token=$(cat .token)

# Inicializando o bot
ShellBot.init --token "$bot_token" --monitor
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
		if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/test" )" ]]; then
			servo.sh
			st=$?
			if [[ $st -eq 0 ]]; then
				ShellBot.sendMessage --chat_id "${message_chat_id[$id]}" --text "Servo SG90 executado..."
			else
				ShellBot.sendMessage --chat_id "${message_chat_id[$id]}" --text "Erro ao executar Servo SG90..."
			fi
		fi
		#case ${message_text[$id]} in
		#	"/teste2") # comando teste
		#	servo.sh
		#		ShellBot.sendMessage --chat_id "${message_chat_id[$id]}" --text "Oi, mensagem de test..."
		#	;;
		#esac
		) & # Utilize a thread se deseja que o bot responda a várias requisições simultâneas.
	done
	
done
#FIM
