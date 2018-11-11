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
#
# O LogAnalyzer é uma interface da Web para o Syslog/Rsyslog e outros dados de eventos da rede. Ele fornece fácil navegação
# análise de eventos de rede em tempo real e serviços de relatórios. Os relatórios ajudam a manter um visão na atividade da
# rede. Ele consolida o Syslog/Rsyslog e outros dados de eventos, fornecendo uma página web de fácil leitura. Os gráficos 
# ajudam a ver as coisas importantes de relance.
#
# Site oficial: https://loganalyzer.adiscon.com/
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
# Declarando as variaveis para o download do LogAnalyzer
LOGANALYZER="http://download.adiscon.com/loganalyzer/loganalyzer-4.1.6.tar.gz"
#
# Declarando as variaveis de autenticação no MySQL
MYSQLUSER="root"
MYSQLPASS="pti@2018"
#
# Declarando as variaveis para criação da Base de Dados do Syslog/Rsyslog
RSYSLOGDB="syslog"
RSYSLOGDATABASE="CREATE DATABASE syslog;"
RSYSLOGUSER="CREATE USER 'syslog' IDENTIFIED BY 'syslog';"
RSYSLOGGRANTDATABASE="GRANT USAGE ON *.* TO 'syslog' IDENTIFIED BY 'syslog';"
RSYSLOGGRANTALL="GRANT ALL PRIVILEGES ON syslog.* TO 'syslog';"
RSYSLOGFLUSH="FLUSH PRIVILEGES;"
RSYSLOGINSTALL="/usr/share/dbconfig-common/data/rsyslog-mysql/install/mysql"
#
# Declarando as variaveis para criação da Base de Dados do LogAnalyzer
LOGDATABASE="CREATE DATABASE loganalyzer;"
LOGUSERDATABASE="CREATE USER 'loganalyzer' IDENTIFIED BY 'loganalyzer';"
LOGGRANTDATABASE="GRANT USAGE ON *.* TO 'loganalyzer' IDENTIFIED BY 'loganalyzer';"
LOGGRANTALL="GRANT ALL PRIVILEGES ON loganalyzer.* TO 'loganalyzer';"
LOGFLUSH="FLUSH PRIVILEGES;"
#
# Exportando o recurso de Noninteractive do Debconf para não solicitar telas de configuração
export DEBIAN_FRONTEND="noninteractive"
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
# Script de instalação do LogAnalyzer no GNU/Linux Ubuntu Server 18.04.x
clear
echo -e "Instalação do LogAnalyzer no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a instalação do LogAnalyzer acessar a URL: http://`hostname -I`/log/\n"
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
echo -e "Instalando as dependências do LogAnalyzer, aguarde..."
	echo "rsyslog-mysql rsyslog-mysql/dbconfig-install boolean false" | debconf-set-selections &>> $LOG
	apt -y install rsyslog-mysql &>> $LOG
echo -e "Dependências instaladas com sucesso!!!, continuando com o script"
sleep 5
echo
#
echo -e "Criando a Base de Dados do Rsyslog, aguarde..."
	mysql -u $MYSQLUSER -p$MYSQLPASS -e "$RSYSLOGDATABASE" mysql &>> $LOG
	mysql -u $MYSQLUSER -p$MYSQLPASS -e "$RSYSLOGUSERDATABASE" mysql &>> $LOG
	mysql -u $MYSQLUSER -p$MYSQLPASS -e "$RSYSLOGGRANTDATABASE" mysql &>> $LOG
	mysql -u $MYSQLUSER -p$MYSQLPASS -e "$RSYSLOGGRANTALL" mysql &>> $LOG
	mysql -u $MYSQLUSER -p$MYSQLPASS -e "$RSYSLOGFLUSH" mysql &>> $LOG
	mysql -u$MYSQLUSER -D $RSYSLOGDB -p$MYSQLPASS < $RSYSLOGINSTALL &>> $LOG
echo -e "Base de Dados do Rsyslog criada com sucesso!!!, continuando o script..."
sleep 5
echo
#
echo -e "Criando a Base de Dados do LogAnalyzer, aguarde..."
	mysql -u $MYSQLUSER -p$MYSQLPASS -e "$LOGDATABASE" mysql &>> $LOG
	mysql -u $MYSQLUSER -p$MYSQLPASS -e "$LOGUSERDATABASE" mysql &>> $LOG
	mysql -u $MYSQLUSER -p$MYSQLPASS -e "$LOGGRANTDATABASE" mysql &>> $LOG
	mysql -u $MYSQLUSER -p$MYSQLPASS -e "$LOGGRANTALL" mysql &>> $LOG
	mysql -u $MYSQLUSER -p$MYSQLPASS -e "$LOGFLUSH" mysql &>> $LOG
echo -e "Base de Dados do LogAnalyzer criada com sucesso!!!, continuando o script..."
sleep 5
echo
#
echo -e "Atualizando os arquivos de configuração do Rsyslog, aguarde..."
	cp -v conf/rsyslog.conf /etc/rsyslog.conf  >> $LOG
	cp -v conf/mysql.conf /etc/rsyslog.d/mysql.conf >> $LOG
echo -e "Arquivos atualizadas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o LogAnalyzer, aguarde..."
sleep 5
echo
#
echo -e "Baixando o LogAnalyzer do site oficial, aguarde..."
	wget $LOGANALYZER &>> $LOG
echo -e "LogAnalyzer baixado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Descompactando o LogAnalyzer, aguarde..."
	LOGANALYZERFILE=`echo loganalyzer*.*.*`
	tar -xzvf $LOGANALYZERFILE &>> $LOG
echo -e "Descompactação do LogAnalyzer feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Copiando os arquivos de configuração do LogAnalyzer, aguarde..."
	LOGANALYZERDIR=`echo loganalyzer*/`
	SOURCE="src/*"
	mkdir -v /var/www/html/log &>> $LOG
	cp -Rv $LOGANALYZERDIR$SOURCE /var/www/html/log/ &>> $LOG
	touch /var/www/html/log/config.php &>> $LOG
	chmod -v 666 /var/www/html/log/config.php &>> $LOG
	chown -Rv www-data.www-data /var/www/html/log/ &>> $LOG
echo -e "Arquivos copiados com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do LogAnalyzer feita com sucesso!!! Pressione <Enter> para continuar."
read
sleep 3
clear
#
echo -e "Editando o arquivo de configuração do Rsyslog, aguarde..."
	echo -e "Pressione <Enter> para editar o arquivo: rsyslog.conf"
	read
	sleep 3
	vim /etc/rsyslog.conf
echo -e "Arquivo editado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Editando o arquivo de configuração do MySQL do Rsyslog, aguarde..."
	echo -e "Pressione <Enter> para editar o arquivo: mysql.conf"
	read
	sleep 3
	vim /etc/rsyslog.d/mysql.conf
echo -e "Arquivo editado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Reinicializando o Serviço do Rsyslog, aguarde..."
	sudo service rsyslog restart &>> $LOG
echo -e "Serviço do Rsyslog reinicializado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Verificando a porta de conexão do Syslog/Rsyslog, aguarde..."
	netstat -an | grep 514
echo -e "Porta de conexão do Syslog/Rsyslog verificado com sucesso!!!, continuando o script..."
sleep 5
echo
#
echo -e "Instalação do LogAnalyzer feita com Sucesso!!!"
	DATAFINAL=`date +%s`
	SOMA=`expr $DATAFINAL - $DATAINICIAL`
	RESULTADO=`expr 10800 + $SOMA`
	TEMPO=`date -d @$RESULTADO +%H:%M:%S`
echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo."
read
exit 1
