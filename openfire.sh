#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 22/11/2018
# Data de atualização: 22/11/2018
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
#
# Extensible Messaging and Presence Protocol (XMPP) (conhecido anteriormente como Jabber) é um protocolo aberto,
# extensível, baseado em XML, para sistemas de mensagens instantâneas, desenvolvido originalmente para mensagens
# instantâneas e informação de presença formalizado pelo IETF. Softwares com base XMPP são distribuídos em milhares
# de servidores através da internet, e usados por cerca de dez milhões de pessoas em todo mundo, de acordo com a 
# XMPP Standards Foundation.
#
# O Openfire (anteriormente conhecido como Wildfire e Jive Messenger) é um servidor de mensagens instantâneas e de
# conversas em grupo que usa o servidor XMPP escrito em Java e licenciado sob a licença Apache 2.0.
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
#
# Variável da Data Inicial para calcular o tempo de execução do script
DATAINICIAL=`date +%s`
#
# Variáveis para validar o ambiente, verificando se o usuário e "root", versão do ubuntu e kernel
USUARIO=`id -u`
UBUNTU=`lsb_release -rs`
KERNEL=`uname -r | cut -d'.' -f1,2`
#
# Variável do caminho do Log dos Script utilizado nesse curso
VARLOGPATH="/var/log/"
#
# Variável para criação do arquivo de Log dos Script
LOGSCRIPT=`echo $0 | cut -d'/' -f2`
#
# Variável do caminho para armazenar os Log's de instalação
LOG=$VARLOGPATH/$LOGSCRIPT
#
# Declarando as variaveis para criação da Base de Dados do OpenFire
USER="root"
PASSWORD="pti@2018"
DATABASE="CREATE DATABASE openfire;"
USERDATABASE="CREATE USER 'openfire' IDENTIFIED BY 'openfire';"
GRANTDATABASE="GRANT USAGE ON *.* TO 'openfire' IDENTIFIED BY 'openfire';"
GRANTALL="GRANT ALL PRIVILEGES ON openfire.* TO 'openfire';"
FLUSH="FLUSH PRIVILEGES;"
#
# Declarando a variável de download do OpenFire
OPENFIRE="https://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_4.2.3_all.deb"
#
# Verificando se o usuário e Root, Distribuição e >=18.04 e o Kernel >=4.15 <IF MELHORADO)
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
# Script de instalação do OpenFire no GNU/Linux Ubuntu Server 18.04.x
clear
echo -e "Instalação do OpenFire no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a instalação do OpenFire acessar a URL: http://`hostname -I | cut -d' ' -f1`:9090/\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet..."
sleep 5
echo
#
echo -e "Adicionando o Repositório Universal do Apt, aguarde..."
	add-apt-repository universe &>> $LOG
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
	apt -y upgrade &>> $LOG
echo -e "Sistema atualizado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Removendo software desnecessários, aguarde..."
	apt -y autoremove &>> $LOG
echo -e "Software removidos com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o OpenFire, aguarde..."
echo
#
echo -e "Instalando as dependências do OpenFire, aguarde..."
	apt -y install openjdk-8-jdk openjdk-8-jre &>> $LOG
echo -e "Instalação das dependências feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Verificando a versão do Java, aguarde..."
	java -version &>> $LOG
echo -e "Versão verificada com sucesso!!!, continuando com o script..."
sleep 5
echo
#				 
echo -e "Criando o Banco de Dados do OpenFire, aguarde..."
	mysql -u $USER -p$PASSWORD -e "$DATABASE" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$USERDATABASE" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$GRANTDATABASE" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$GRANTALL" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$FLUSH" mysql &>> $LOG	
echo -e "Banco de Dados criado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Baixando o OpenFire do site oficial, aguarde..."
	wget $OPENFIRE -O openfire.deb &>> $LOG
echo -e "OpenFire baixado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o OpenFire, aguarde..."
	dpkg -i openfire.deb &>> $LOG
echo -e "OpenFire instalado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Verificando a porta de conexão do OpenFire, aguarde..."
	#-a (all), -n (numeric)
	netstat -an | grep 9090
echo -e "Porta de conexão verificada com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do OpenFire feita com Sucesso!!!"
	DATAFINAL=`date +%s`
	SOMA=`expr $DATAFINAL - $DATAINICIAL`
	RESULTADO=`expr 10800 + $SOMA`
	TEMPO=`date -d @$RESULTADO +%H:%M:%S`
echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo."
read
exit 1
