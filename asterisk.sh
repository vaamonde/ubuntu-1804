#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 06/01/2019
# Data de atualização: 06/01/2019
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
#
# O Asterisk é um software livre, de código aberto, que implementa em software os recursos encontrados em um PABX 
# convencional, utilizando tecnologia de VoIP. Ele foi criado pelo Mark Spencer em 1999.
# Inicialmente desenvolvido pela empresa Digium, hoje recebe contribuições de programadores ao redor de todo o mundo. 
# Seu desenvolvimento é ativo e sua área de aplicação muito promissora.
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
#
# Variável da Data Inicial para calcular o tempo de execução do script
# opção do comando date: +%s (seconds since)
DATAINICIAL=`date +%s`
#
# Variáveis para validar o ambiente, verificando se o usuário e "root", versão do ubuntu e kernel
# opções do comando id: -u (user), opções do comando: lsb_release: -r (release), -s (short), 
# opões do comando uname: -r (kernel release), opções do comando cut: -d (delimiter), -f (fields)
# opção do caracter: | (piper) Conecta a saída padrão com a entrada padrão de outro comando
USUARIO=`id -u`
UBUNTU=`lsb_release -rs`
KERNEL=`uname -r | cut -d'.' -f1,2`
#
# Variável do caminho do Log dos Script utilizado nesse curso
VARLOGPATH="/var/log/"
#
# Variável para criação do arquivo de Log dos Script
# $0 (variável de ambiente do nome do comando)
LOGSCRIPT=`echo $0 | cut -d'/' -f2`
#
# Variável do caminho para armazenar os Log's de instalação
LOG=$VARLOGPATH/$LOGSCRIPT
#
# Declarando as variaveis de Download do Asterisk
DAHDI="git://git.asterisk.org/dahdi/linux dahdi-linux"
DAHDITOOLS="git://git.asterisk.org/dahdi/tools dahdi-tools"
LIBPRI="http://gerrit.asterisk.org/libpri libpri"
ASTERISK="http://gerrit.asterisk.org/asterisk asterisk"
#
# Verificando se o usuário e Root, Distribuição e >=18.04 e o Kernel >=4.15 <IF MELHORADO)
# && = operador lógico AND, == comparação de string, exit 1 = A maioria dos erros comuns na execução
clear
if [ "$USUARIO" == "0" ] && [ "$UBUNTU" == "18.04" ] && [ "$KERNEL" == "4.15" ]
	then
		echo -e "O usuário e Root, continuando com o script..."
		echo -e "Distribuição e >=18.04.x, continuando com o script..."
		echo -e "Kernel e >= 4.15, continuando com o script..."
		sleep 5
	else
		echo -e "Usuário não e Root ($USUARIO) ou Distribuição não e >=18.04.x ($UBUNTU) ou Kernel não e >=4.15 ($KERNEL)"
		echo -e "Caso você não tenha executado o script com o comando: sudo -i"
		echo -e "Execute novamente o script para verificar o ambiente."
		exit 1
fi
#		
# Script de instalação do Asterisk no GNU/Linux Ubuntu Server 18.04.x
# opção do comando hostname: -I (all IP address)
echo
echo -e "Instalação do Asterisk no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet..."
sleep 5
echo
#
echo -e "Adicionando o Repositório Universal do Apt, aguarde..."
	#opção do comando: &>> (redirecionar a entrada padrão)
	add-apt-repository universe &>> $LOG
echo -e "Repositório adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Adicionando o Repositório Multiverse do Apt, aguarde..."
	#opção do comando: &>> (redirecionar a entrada padrão)
	add-apt-repository multiverse &>> $LOG
echo -e "Repositório adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando as listas do Apt, aguarde..."
	apt update &>> $LOG
echo -e "Listas atualizadas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando o sistema, aguarde..."
	#-y (yes)
	apt -y upgrade &>> $LOG
echo -e "Sistema atualizado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Removendo software desnecessários, aguarde..."
	#-y (yes)
	apt -y autoremove &>> $LOG
echo -e "Software removidos com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o Asterisk, aguarde..."
echo
#
echo -e "Instalando as dependências do Asterisk, aguarde..."
	#-y (yes) | $(uname -r) = kernel-release
	apt install -y build-essential libssl-dev libelf-dev libncurses5-dev libnewt-dev libxml2-dev linux-headers-$(uname -r) libsqlite3-dev uuid-dev subversion libjansson-dev sqlite3 autoconf automake libtool libedit-dev flex bison libtool libtool-bin &>> $LOG
echo -e "Dependências instaladas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Download e instalação do DAHDI, aguarde..."
	git clone $DAHDI &>> $LOG
	cd dahdi-linux*/
	./configure  &>> $LOG
	make clean  &>> $LOG
	make all  &>> $LOG
	make install  &>> $LOG
	cd ..
echo -e "DAHDI instalado com sucesso!!!, continuando com o script..."
sleep 5
echo	
#
echo -e "Download e instalação do DAHDI Tools, aguarde..."
	git clone $DAHDITOOLS &>> $LOG
	cd dahdi-tools*/
	autoreconf -i  &>> $LOG
	./configure &>> $LOG
	make clean  &>> $LOG
	make all  &>> $LOG
	make install  &>> $LOG
	cd ..
echo -e "DAHDI Tools instalado com sucesso!!!, continuando com o script..."
sleep 5
echo	
#
echo -e "Download e instalação do LIBPRI, aguarde..."
	git clone $LIBPRI &>> $LOG
	cd libpri*/ &>> $LOG
	./configure &>> $LOG
	make clean  &>> $LOG
	make all &>> $LOG
	make install &>> $LOG
	cd ..
echo -e "LIBPRI instalado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Download e instalação do Asterisk, aguarde..."
	git clone $ASTERISK &>> $LOG
	cd asterisk*/
	./configure &>> $LOG
	make all &>> $LOG
	make install &>> $LOG
	make samples &>> $LOG
	make basic-pbx &>> $LOG
	make config &>> $LOG
	make install-logrotate &>> $LOG
	sudo service asterisk start &>> $LOG
	cd ..
echo -e "Asterisk instalado com sucesso!!!, continuando com o script..."
sleep 5
echo	
#
echo -e "Instalação do Asterisk feita com Sucesso!!!"
	# opção do comando date: +%s (seconds since)
	DATAFINAL=`date +%s`
	SOMA=`expr $DATAFINAL - $DATAINICIAL`
	# opção do comando expr: 10800 segundos, usada para arredondamento de cálculo
	RESULTADO=`expr 10800 + $SOMA`
	# opção do comando date: -d (date), +%H (hour), %M (minute), %S (second)
	TEMPO=`date -d @$RESULTADO +%H:%M:%S`
echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo."
read
exit 1
