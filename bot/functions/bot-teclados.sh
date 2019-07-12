#!/bin/bash

source /odroid-feeder/bot/ShellBot.sh

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
