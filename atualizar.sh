#!/bin/bash
# Script para atualizar o GNU/Linux

echo Atualizando as Listas do Apt
echo
	sudo apt update
echo
echo Listas atualizadas
sleep 5
clear

echo Atualizando os Software
echo
	sudo apt -y upgrade
echo
echo Software atualizados
sleep 5
clear

echo Atualizando o Kernel
echo
	sudo apt -y dist-upgrade
echo
echo Kernel atualizados
sleep 5
clear

echo Removendo Software
echo
	sudo apt -y autoremove
echo
echo Software removidos
sleep 5
clear

echo Limpando o Cache
echo
	sudo apt -y autoclean
echo
echo Cache Limpo
sleep 5
clear
