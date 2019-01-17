#!/bin/bash
# Script para atualizar o GNU/Linux

echo Atualizando as Listas do Apt
echo
	sudo apt update
echo
echo Listas atualizadas

echo Atualizando os Software
echo
	sudo apt -y upgrade
echo
echo Software atualizados

echo Atualizando o Kernel
echo
	sudo apt -y dist-upgrade
echo
echo Kernel atualizados

echo Removendo Software
echo
	sudo apt -y autoremove
echo
echo Software removidos

echo Limpando o Cache
echo
	sudo apt -y autoclean
echo
echo Cache Limpo
