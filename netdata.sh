#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 11/11/2018
# Data de atualização: 11/11/2018
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
# Vídeo de instalação do LAMP Server no Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=6EFUu-I3u4s
#
# O Netdata é uma ferramenta para visualizar e monitorar métricas em tempo real, otimizado para acumular todos os tipos de
# dados, como uso da CPU, atividade do disco, consultas SQL, visitas a um site, etc. A ferramenta é projetada para visualizar 
# o agora com o máximo de detalhes possível, permitindo que o usuário tenha uma visão do que está acontecendo e do que acaba
# de acontecer em seu sistema ou aplicativo, sendo uma opção ideal para resolver problemas de desempenho em tempo real.
# https:\\(ip do servidor):(porta de utilização). Exemplo: https:\\172.16.1.20:19999
#
# Site oficial: https://github.com/netdata/netdata
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
# Variável do download do Webmin
NETDATA="https://github.com/firehol/netdata.git --depth=1"
#
# Verificando se o usuário e Root
if [ "$USUARIO" == "0" ]
	then
		echo -e "O usuário e Root, continuando com o script..."
	else
		echo -e "Usuário não e Root, execute o comando: sudo -i, execute novamente o script."
		exit 1
fi
#
# Verificando se a distribuição e 18.04.x
if [ "$UBUNTU" == "18.04" ]
	then
		echo -e "Distribuição e 18.04.x, continuando com o script..."
	else
		echo -e "Distribuição não homologada, instale a versão 18.04.x e execute novamente o script."
		exit 1
fi
#		
# Verificando se o Kernel e 4.15
if [ "$KERNEL" == "4.15" ]
	then
		echo -e "Kernel e >= 4.15, continuando com o script..."
		sleep 5
	else
		echo -e "Kernel não homologado, instale a versão do Ubuntu 18.04.x e atualize o sistema."
		exit 1
fi
#
# Script de instalação do Netdata no GNU/Linux Ubuntu Server 18.04.x
clear
echo -e "Instalação do Netdata no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a instalação do Netdata acessar a URL: http://`hostname -I`:19999/\n"
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
echo -e "Instalando o Netdata, aguarde..."
echo
#
echo -e "Instalando as dependências do Netdata, aguarde..."
	apt -y install zlib1g-dev gcc make git autoconf autogen automake pkg-config uuid-dev python python-mysqldb python-pip python-dev python3-dev libmysqlclient-dev python-ipaddress &>> $LOG
echo -e "Instalação das dependências feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Fazendo a clonagem do Netdata, aguarde..."
	git clone $NETDATA &>> $LOG
echo -e "Clonagem do Netdata feito com sucesso!!!, continuando com o script..."
sleep 5
echo
#				 
echo -e "Instalando o Netdata, aguarde..."
	cd netdata/
	echo | ./netdata-installer.sh &>> $LOG
echo -e "Instalação do Netdata feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Verificando a porta de conexão do Netdata, aguarde..."
	netstat -an | grep 19999
echo -e "Porta de conexão verificada com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Netdata instalado com sucesso!!!, pressione <Enter> para continuar com o script."
read
sleep 5
clear
#
echo -e "Editando o arquivo de monitoramento do MySQL, pressione <Enter> para editar"
	read
	sleep 5
	vim /usr/lib/netdata/conf.d/python.d/mysql.conf
echo -e "Arquivo editado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Reinicializando o serviço do Netdata, aguarde..."
	sudo service netdata restart
echo -e "Serviço reinicializado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do Netdata feita com Sucesso!!!"
	DATAFINAL=`date +%s`
	SOMA=`expr $DATAFINAL - $DATAINICIAL`
	RESULTADO=`expr 10800 + $SOMA`
	TEMPO=`date -d @$RESULTADO +%H:%M:%S`
echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo."
read
exit 1
