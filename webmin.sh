#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 10/11/2018
# Data de atualização: 10/11/2018
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
# Vídeo de instalação do LAMP Server no Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=6EFUu-I3u4s
#
# Webmin é um programa de gerenciamento de servidor, que roda em plataformas Unix/Linux. Com ele você pode usar também o 
# Usermin e o Virtualmin. O Webmin funciona como um centralizador de configurações do sistema, monitoração dos serviços e de
# servidores, fornecendo uma interface amigável, e que quando configurado com um servidor web, pode ser acessado de qualquer
# local, através de um navegador: https:\\(ip do servidor):(porta de utilização). Exemplo: https:\\172.16.1.20:10000
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
WEBMIN="https://prdownloads.sourceforge.net/webadmin/webmin_1.890_all.deb"
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
# Script de instalação do Webmin no GNU/Linux Ubuntu Server 18.04.x
clear
echo -e "Instalação do Webmin no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a instalação do Webmin acessar a URL: https://`hostname -I`:10000/\n"
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
echo -e "Instalando o Webmin, aguarde..."
echo
#
echo -e "Instalando as dependências do Webmin, aguarde..."
	apt -y install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python &>> $LOG
echo -e "Instalação das dependências feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Fazendo o download do Webmin, aguarde..."
	wget $WEBMIN &>> $LOG
echo -e "Download do Webmin feito com sucesso!!!, continuando com o script..."
sleep 5
echo
#				 
echo -e "Instalando o Webmin, aguarde..."
	WEBMINVERSION=`echo webmin*`
	dpkg -i $WEBMINVERSION &>> $LOG
echo -e "Instalação do Webmin feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Verificando a porta de conexão do Webmin, aguarde..."
	netstat -an | grep 10000
echo -e "Porta de conexão verificada com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do Webmin feito com Sucesso!!!"
	DATAFINAL=`date +%s`
	SOMA=`expr $DATAFINAL - $DATAINICIAL`
	RESULTADO=`expr 10800 + $SOMA`
	TEMPO=`date -d @$RESULTADO +%H:%M:%S`
echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo."
read
exit 1
