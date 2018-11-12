#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 04/11/2018
# Data de atualização: 12/11/2018
# Versão: 0.03
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
#
# APACHE-2.4 (Apache HTTP Server) -Servidor de Hospedagem de Páginas web
# MYSQL-5.7 (SGBD) - Sistemas de Gerenciamento de Banco de Dados
# PHP-7.2 (Personal Home Page - PHP: Hypertext Preprocessor) - Linguagem de Programação Dinâmica para Web
# PERL-5.26 - Linguagem de programação multiplataforma
# PYTHON-2.7 - Linguagem de programação de alto nível
# PHPMYADMIN-4.6 - Aplicativo desenvolvido em PHP para administração do MySQL pela Internet
#
# Debconf - Sistema de configuração de pacotes Debian
# Site: http://manpages.ubuntu.com/manpages/bionic/man7/debconf.7.html
# Debconf-Set-Selections - insere novos valores no banco de dados debconf
# Site: http://manpages.ubuntu.com/manpages/bionic/man1/debconf-set-selections.1.html
#
# Opção: lamp-server^ Recurso existente no GNU/Ubuntu Server para facilitar a instalação do Servidor LAMP
# A opção de circunflexo no final do comando e obrigatório, considerado um meta-caracter de filtragem para
# a instalação correta de todos os serviços do LAMP.
# Recurso faz parte do software Tasksel: https://help.ubuntu.com/community/Tasksel
#
# O módulo do PHP Mcrypt na versão 7.2 está descontinuado, para fazer sua instalação e recomendado utilizar
# o comando o Pecl e adicionar o repositório pecl.php.net, a instalação e baseada em compilação do módulo.
#
# Observação: Nesse script está sendo feito a instalação do Oracle MySQL, hoje os desenvolvedores estão migrando
# para o MariaDB, nesse script o mesmo deve ser reconfigurado para instalar e configurar o MariaDB no Ubuntu.
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
# Variáveis de configuração do MySQL e liberação de conexão remota
USER="root"
PASSWORD="pti@2018"
AGAIN=$PASSWORD
GRANTALL="GRANT ALL ON *.* TO $USER@'%' IDENTIFIED BY '$PASSWORD';"
#
# Variáveis de configuração do PhpMyAdmin
ADMINUSER=$USER
ADMIN_PASS=$PASSWORD
APP_PASSWORD=$PASSWORD
APP_PASS=$PASSWORD
WEBSERVER="apache2"
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
# Script de instalação do LAMP-Server no GNU/Linux Ubuntu Server 18.04.x
clear
echo -e "Instalação do LAMP-SERVER no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "APACHE (Apache HTTP Server) - Servidor de Hospedagem de Páginas Web - Porta 80/443"
echo -e "Após a instalação do Apache2 acessar a URL: http://`hostname -I`/\n"
echo -e "MYSQL (SGBD) - Sistemas de Gerenciamento de Banco de Dados - Porta 3306\n"
echo -e "PHP (Personal Home Page - PHP: Hypertext Preprocessor) - Linguagem de Programação Dinâmica para Web\n"
echo -e "PERL - Linguagem de programação multi-plataforma\n"
echo -e "PYTHON - Linguagem de programação de alto nível\n"
echo -e "PhpMyAdmin - Aplicativo desenvolvido em PHP para administração do MySQL pela Internet"
echo -e "Após a instalação do PhpMyAdmin acessar a URL: http://`hostname -I`/phpmyadmin\n"
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
echo -e "Software removidos com Sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o LAMP-SERVER, aguarde..."
echo
#
echo -e "Configurando as variáveis do Debconf do MySQL para o Apt, aguarde..."
	echo "mysql-server-5.7 mysql-server/root_password password $PASSWORD" |  debconf-set-selections
	echo "mysql-server-5.7 mysql-server/root_password_again password $AGAIN" |  debconf-set-selections
	debconf-show mysql-server-5.7 &>> $LOG
echo -e "Variáveis configuradas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o LAMP-SERVER, aguarde..."
	apt -y install lamp-server^ perl python &>> $LOG
echo -e "Instalação do LAMP-SERVER feito com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o PhpMyAdmin, aguarde..."
echo
#
echo -e "Configurando as variáveis do Debconf do PhpMyAdmin para o Apt, aguarde..."
	echo "phpmyadmin phpmyadmin/internal/skip-preseed boolean true" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/app-password-confirm password $APP_PASSWORD" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect $WEBSERVER" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/admin-user string $ADMINUSER" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/admin-pass password $ADMIN_PASS" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/app-pass password $APP_PASS" |  debconf-set-selections
	debconf-show phpmyadmin &>> $LOG
echo -e "Variáveis configuradas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o PhpMyAdmin, aguarde..."
	apt -y install phpmyadmin php-mbstring php-gettext php-dev libmcrypt-dev php-pear &>> $LOG
echo -e "Instalação do PhpMyAdmin feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#				 
echo -e "Atualizando as dependências do PHP para o PhpMyAdmin, aguarde..."
	pecl channel-update pecl.php.net &>> $LOG
	echo | pecl install mcrypt-1.0.1 &>> $LOG
	cp -v conf/mcrypt.ini /etc/php/7.2/mods-available/ &>> $LOG
	phpenmod mcrypt &>> $LOG
	phpenmod mbstring &>> $LOG
echo -e "Atualização das dependêncais feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Criando o arquivo de teste do PHP phpinfo.php, aguarde..."
	touch /var/www/html/phpinfo.php
	echo -e "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
	chown www-data.www-data /var/www/html/phpinfo.php
echo -e "Arquivo criado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do LAMP-Server e PhpMyAdmin feito com sucesso!!! Pressione <Enter> para continuar."
read
sleep 3
clear
#
echo -e "Atualizando e editando o arquivo de configuração do Apache2, aguarde..."
	cp -v /etc/apache2/apache2.conf /etc/apache2/apache2.conf.old &>> $LOG
	cp -v conf/apache2.conf /etc/apache2/apache2.conf &>> $LOG
	echo -e "Pressione <Enter> para editar o arquivo: apache2.conf"
		read
		sleep 3
	vim /etc/apache2/apache2.conf
echo -e "Arquivo atualizado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando e editando o arquivo de configuração do PHP, aguarde..."
	cp -v /etc/php/7.2/apache2/php.ini /etc/php/7.2/apache2/php.ini.old &>> $LOG
	cp -v conf/php.ini /etc/php/7.2/apache2/php.ini &>> $LOG
	echo -e "Pressione <Enter> para editar o arquivo: php.ini"
		read
		sleep 3
	vim /etc/php/7.2/apache2/php.ini
echo -e "Arquivo atualizado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Reinicializando o serviço do Apache2, aguarde..."
	sudo service apache2 restart
echo -e "Serviço reinicializado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Permitindo o Root do MySQL se autenticar remotamente, aguarde..."
	mysql -u $USER -p$PASSWORD -e "$GRANTALL" mysql &>> $LOG
echo -e "Permissão alterada com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando e editando o arquivo de configuração do MySQL, aguarde..."
	cp -v /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.old &>> $LOG
	cp -v conf/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf &>> $LOG
	echo -e "Pressione <Enter> para editar o arquivo: mysqld.cnf"
		read
		sleep 3
	vim /etc/mysql/mysql.conf.d/mysqld.cnf
echo -e "Arquivo atualizado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Reinicializando os serviços do MySQL, aguarde..."
	sudo service mysql restart
echo -e "Serviço reinicializado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Verificando as portas de Conexão do Apache2 e do MySQL, aguarde..."
	netstat -an | grep '80\|3306'
echo -e "Portas verificadas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do LAMP-SERVER feito com Sucesso!!!"
	DATAFINAL=`date +%s`
	SOMA=`expr $DATAFINAL - $DATAINICIAL`
	RESULTADO=`expr 10800 + $SOMA`
	TEMPO=`date -d @$RESULTADO +%H:%M:%S`
echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo."
read
exit 1
