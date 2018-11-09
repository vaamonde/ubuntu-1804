#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 09/11/2018
# Data de atualização: 09/11/2018
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
#
# Vídeo de instalação do LAMP Server no Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=6EFUu-I3u4s
#
# Wordpress: é um sistema livre e aberto de gestão de conteúdo para internet (do inglês: Content Management System - CMS),
# baseado em PHP com banco de dados MySQL, executado em um servidor interpretador, voltado principalmente para a criação de
# páginas eletrônicas (sites) e blogs online. Criado a partir do extinto b2/cafelog, por Ryan Boren e Matthew Mullenweg, e
# distribuído gratuitamente sob a GNU General Public License.
#
# Site oficial: https://wordpress.org/
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
#Declarando as variaveis para o download do Wordpress
WORDPRESS="https://wordpress.org/latest.zip"
#
#Declarando as variaveis para criação da Base de Dados do Wordpress
USER="root"
PASSWORD="pti@2018"
DATABASE="CREATE DATABASE wordpress;"
USERDATABASE="CREATE USER 'wordpress' IDENTIFIED BY 'wordpress';"
GRANTDATABASE="GRANT USAGE ON *.* TO 'wordpress' IDENTIFIED BY 'wordpress';"
GRANTALL="GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress';"
FLUSH="FLUSH PRIVILEGES;"
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
# Script de instalação do Wordpress no GNU/Linux Ubuntu Server 18.04.x
clear
echo -e "Instalação do Wordpress no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a instalação do Wordpress acessar a URL: http://`hostname -I`/wp/\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet..."
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
echo -e "Instalando as dependências do Wordpress, aguarde..."
	apt -y install unzip &>> $LOG
echo -e "Dependências instaladas com sucesso!!!, continuando com o script"
sleep 5
echo
#
echo -e "Removendo os software desnecessários, aguarde..."
	apt -y autoremove &>> $LOG
echo -e "Software removidos com Sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o Wordpress, aguarde..."
echo
#
echo -e "Baixando o Wordpress do site oficial, aguarde..."
	wget $WORDPRESS &>> $LOG
echo -e "Wordpress baixado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Descompactando o Wordpress, aguarde..."
	unzip latest.zip &>> $LOG
echo -e "Descompactação feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Copiando os arquivos de configuração do Wordpress, aguarde..."
	mv -v wordpress/ /var/www/html/wp &>> $LOG
	cp -v conf/htaccess /var/www/html/wp/.htaccess &>> $LOG
	cp -v conf/wp-config.php /var/www/html/wp/ &>> $LOG
echo -e "Arquivos copiados com sucesso!!!, continuando com o script..."
sleep 5
echo
#				 
echo -e "Alterando as permissões dos arquivos e diretórios do Wordpress, aguarde..."
	chmod -Rfv 755 /var/www/html/wp/ &>> $LOG
	chown -Rfv www-data.www-data /var/www/html/wp/ &>> $LOG
echo -e "Permissões alteradas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Criando a Base de Dados do Wordpress, aguarde..."
	mysql -u $USER -p$PASSWORD -e "$DATABASE" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$USERDATABASE" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$GRANTDATABASE" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$GRANTALL" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$FLUSH" mysql &>> $LOG
echo -e "Base de Dados criada com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do Wordpress feita com sucesso!!! Pressione <Enter> para continuar."
read
sleep 3
clear
#
echo -e "Editando o arquivo de configuração da Base de Dados do Wordpress, aguarde..."
	echo -e "Pressione <Enter> para editar o arquivo: wp-config.php"
		read
		sleep 3
	vim /var/www/html/wp/wp-config.php
echo -e "Arquivo editado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Editando o arquivo de configuração do htaccess do Wordpress, aguarde..."
	echo -e "Pressione <Enter> para editar o arquivo: .htaccess"
		read
		sleep 3
	vim /var/www/html/wp/.htaccess
echo -e "Arquivo editado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do Wordpress feito com Sucesso!!!"
	DATAFINAL=`date +%s`
	SOMA=`expr $DATAFINAL - $DATAINICIAL`
	RESULTADO=`expr 10800 + $SOMA`
	TEMPO=`date -d @$RESULTADO +%H:%M:%S`
echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo."
read
exit 1
