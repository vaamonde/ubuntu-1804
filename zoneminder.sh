#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 02/12/2018
# Data de atualização: 01/12/2018
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
#
# ZoneMinder é um sistema de CFTV (Circuito Fechado de televisão) Open Source, desenvolvido para sistemas 
# operacionais Linux. Ele é liberado sob os termos da GNU General Public License (GPL). Os usuários 
# controlam o ZoneMinder através de uma interface baseada na Web; também fornece LiveCD. O aplicativo
# pode usar câmeras padrão (por meio de uma placa de captura, USB, Firewire etc.) ou dispositivos de
# câmera baseados em IP. O software permite três modos de operação: monitoramento (sem gravação), 
# gravação após movimento detectado e gravação permanente.
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
#
# Vídeo de instalação do LAMP Server no GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=6EFUu-I3u4s
#
# Variável da Data Inicial para calcular o tempo de execução do script
# opção do comando date: +%s (seconds since)
DATAINICIAL=`date +%s`
#
# Variáveis para validar o ambiente, verificando se o usuário e "root", versão do ubuntu e kernel
# opções do comando id: -u (user), opções do comando: lsb_release: -r (release), -s (short), 
# opões do comando uname: -r (kernel release), opções do comando cut: -d (delimiter), -f (fields)
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
# Declarando as variaveis para criação da Base de Dados do ZoneMinder
USER="root"
PASSWORD="pti@2018"
DATABASE="/usr/share/zoneminder/db/zm_create.sql"
GRANTALL="GRANT ALL PRIVILEGES ON zm.* TO 'zmuser'@'localhost' IDENTIFIED by 'zmpass';"
FLUSH="FLUSH PRIVILEGES;"
#
# Declarando a variável de PPA do ZoneMinder
ZONEMINDER="ppa:iconnor/zoneminder-master"
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
# Verificando se as dependêncais do ZoneMinder estão instaladas
# opção do dpkg: -s (status), opção do echo: -e (intepretador de escapes de barra invertida), -n (permite nova linha), \n (new line)
# || (operador lógico OU), 2> (redirecionar de saída de erro STDERR), && = operador lógico AND
echo -n "Verificando as dependências, aguarde... "
	for name in mysql-server mysql-common software-properties-common
	do
  		[[ $(dpkg -s $name 2> /dev/null) ]] || { echo -en "\n\nO software: $name precisa ser instalado. \nUse o comando 'apt install $name'\n";deps=1; }
	done
		[[ $deps -ne 1 ]] && echo "Dependências.: OK" || { echo -en "\nInstale as dependências acima e execute novamente este script\n";exit 1; }
		sleep 5
#		
# Script de instalação do ZoneMinder no GNU/Linux Ubuntu Server 18.04.x
# opção do comando hostname: -I (all IP address)
clear
echo -e "Instalação do ZoneMinder no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a instalação do ZoneMinder acessar a URL: http://`hostname -I`/zm/\n"
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
echo -e "Instalando o ZoneMinder, aguarde..."
echo
#
echo -e "Adiconando o PPA do ZoneMinder, aguarde..."
	#echo | (faz a função do Enter)
	echo | sudo add-apt-repository $ZONEMINDER &>> $LOG
echo -e "PPA adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando novamente as listas do Apt, aguarde..."
	apt update &>> $LOG
echo -e "Listas atualizadas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Editando as Configurações do Servidor de MySQL, perssione <Enter> para continuar"
	#sql_mode = NO_ENGINE_SUBSTITUTION
	read
	vim /etc/mysql/mysql.conf.d/mysqld.cnf
	sudo service mysql restart &>> $LOG
echo -e "Banco de Dados editado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Criando o Banco de Dados do ZoneMinder, aguarde..."
	#-u (user), -p (password), -e (execute), < (Redirecionador de Saída STDOUT)
	mysql -u $USER -p$PASSWORD < $DATABASE &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$GRANTALL" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$FLUSH" mysql &>> $LOG
echo -e "Banco de Dados criado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Editando as Configurações do PHP, perssione <Enter> para continuar"
	#[Date] - date.timezone = America/Sao_Paulo
	read
	vim /etc/php/7.2/apache2/php.ini
echo -e "Arquivo do PHP editado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o ZoneMinder, aguarde..."
	#-y (yes)
	apt -y install zoneminder &>> $LOG
echo -e "ZoneMinder instalado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Alterando as permissões do ZoneMinder, aguarde..."
	#opções do comando: chmod -v (verbose), 740 (dono=RWX,grupo=R,outro=)
	#opções do comando: chown -v (verbose), -R (recursive), root (dono), www-data (grupo)
	#opções do comando: usermod -a (append), -G (group), video (grupo), www-data (user)
	chmod -v 740 /etc/zm/zm.conf &>> $LOG
	chown -v root.www-data /etc/zm/zm.conf &>> $LOG
	chown -Rv www-data.www-data /usr/share/zoneminder/ &>> $LOG
	usermod -a -G video www-data &>> $LOG
echo -e "Permissões alteradas com sucesso com sucesso!!!, continuando com o script..."
sleep 5
echo
#
#
echo -e "Habilitando os recursos do Apache2 para o ZoneMinder, aguarde..."
	#a2enmod (Apache2 Enable Mode), a2enconf (Apache2 Enable Conf)
	a2enmod cgi &>> $LOG
	a2enmod rewrite &>> $LOG
	a2enconf zoneminder &>> $LOG
echo -e "Recurso habilitado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
#
echo -e "Criando o Serviço do ZoneMinder, aguarde..."
	systemctl enable zoneminder &>> $LOG
	service zoneminder start &>> $LOG
	service apache2 restart &>> $LOG
echo -e "Serviço criado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do ZoneMinder feita com Sucesso!!!"
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
