#!/bin/bash
# Autor: Rodrigo Fernandes
# Data de criação: 02/04/2019
# Data de atualização: 02/04/2019
# Versão: 0.1
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.18.x
#
# ZoneMinder é um sistema de CFTV (Circuito Fechado de televisão) Open Source, desenvolvido para sistemas 
# operacionais Linux. Ele é liberado sob os termos da GNU General Public License (GPL). Os usuários 
# controlam o ZoneMinder através de uma interface baseada na Web; também fornece LiveCD. O aplicativo
# pode usar câmeras padrão (por meio de uma placa de captura, USB, Firewire etc.) ou dispositivos de
# câmera baseados em IP. O software permite três modos de operação: monitoramento (sem gravação), 
# gravação após movimento detectado e gravação permanente.
#
# CCTV / CFTV = (Closed-Circuit Television - Circuito fechado de televisão);
# PTZ Pan/Tilt/Zoom (Uma câmera de rede PTZ oferece funcionalidade de vídeo em rede combinada com o recurso
# de movimento horizontal, vertical e de zoom - Pan = Panorâmica Horizontal - Tilt = Vertical | Zoom - Aproximar)
#
# Site Oficial do ZoneMinder: https://zoneminder.com/
#
# Antes de iniciar a instalação do ZoneMinder, utilize alguns comandos: 
# * sudo -i = utilizar o usuário root
# * apt-get update
# * apt-get upgrade
# * apt-get dist-upgrade
# 
# Instale alguns recursos importantes:
# * Install Apache2
# * Install vim
# 
#
# Variável da Data Inicial para calcular o tempo de execução do script (VARIÁVEL MELHORADA)
# opção do comando date: +%T (Time)
HORAINICIAL=`date +%T`
#
# Variáveis para validar o ambiente, verificando se o usuário e "root", versão do ubuntu e kernel
# opções do comando id: -u (user), opções do comando: lsb_release: -r (release), -s (short), 
# opões do comando uname: -r (kernel release), opções do comando cut: -d (delimiter), -f (fields)
# opção do caracter: | (piper) Conecta a saída padrão com a entrada padrão de outro comando
USUARIO=`id -u`
UBUNTU=`lsb_release -rs`
KERNEL=`uname -r | cut -d'.' -f1,2`
#
# Variável do caminho do Log dos Script utilizado nesse curso (VARIÁVEL MELHORADA)
# opções do comando cut: -d (delimiter), -f (fields)
# $0 (variável de ambiente do nome do comando)
LOG="/var/log/$(echo $0 | cut -d'/' -f2)"
#
# Declarando as variaveis para criação da Base de Dados do ZoneMinder
USER="root"
PASSWORD="zm@2019"
DATABASE="/usr/share/zoneminder/db/zm_create.sql"
GRANTALL="GRANT ALL PRIVILEGES ON zm.* TO 'zmuser'@'localhost' IDENTIFIED by 'zmpass';"
FLUSH="FLUSH PRIVILEGES;"
#
# Declarando a variável de PPA do ZoneMinder
ZONEMINDER="ppa:iconnor/zoneminder-master"
#
# Verificando se o usuário e Root, Distribuição e >=18.04 e o Kernel >=4.18 <IF MELHORADO)
# && = operador lógico AND, == comparação de string, exit 1 = A maioria dos erros comuns na execução
clear
if [ "$USUARIO" == "0" ] && [ "$UBUNTU" == "18.04" ] && [ "$KERNEL" == "4.18" ]
	then
		echo -e "O usuário e Root, continuando com o script..."
		echo -e "Distribuição e >=18.04.x, continuando com o script..."
		echo -e "Kernel e >= 4.18, continuando com o script..."
		sleep 5
	else
		echo -e "Usuário não e Root ($USUARIO) ou Distribuição não e >=18.04.x ($UBUNTU) ou Kernel não e >=4.18 ($KERNEL)"
		echo -e "Caso você não tenha executado o script com o comando: sudo -i"
		echo -e "Execute novamente o script para verificar o ambiente."
		exit 1
fi
#
# Verificando se as dependêncais do ZoneMinder estão instaladas
# opção do dpkg: -s (status), opção do echo: -e (intepretador de escapes de barra invertida), -n (permite nova linha), \n (new line)
# || (operador lógico OU), 2> (redirecionar de saída de erro STDERR), && = operador lógico AND
echo -n "Verificando as dependências, aguarde... "
	for name in apache2 mysql-server mysql-common software-properties-common
	do
  		[[ $(dpkg -s $name 2> /dev/null) ]] || { echo -en "\n\nO software: $name precisa ser instalado. \nUse o comando 'apt install $name'\n";deps=1; }
	done
		[[ $deps -ne 1 ]] && echo "Dependências.: OK" || { echo -en "\nInstale as dependências acima e execute novamente este script\n";exit 1; }
		sleep 5
#		
# Script de instalação do ZoneMinder no GNU/Linux Ubuntu Server 18.04.x
# opção do comando echo: -e (enable interpretation of backslash escapes), \n (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
clear
#
echo -e "Instalação do ZoneMinder no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a instalação do ZoneMinder acessar a URL: http://`hostname -I`/zm/\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet..."
sleep 5
echo
#
echo -e "Adicionando o Repositório Universal do Apt, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	add-apt-repository universe &>> $LOG
echo -e "Repositório adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando as listas do Apt, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	apt update &>> $LOG
echo -e "Listas atualizadas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando o sistema, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (yes)
	apt -y upgrade &>> $LOG
echo -e "Sistema atualizado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Removendo software desnecessários, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (yes)
	apt -y autoremove &>> $LOG
echo -e "Software removidos com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o ZoneMinder, aguarde..."
echo
#
echo -e "Adicionando o PPA do ZoneMinder, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando echo |: (faz a função do Enter)
	echo | sudo add-apt-repository $ZONEMINDER &>> $LOG
echo -e "PPA adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando novamente as listas do Apt, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	apt update &>> $LOG
echo -e "Listas atualizadas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Editando as Configurações do Servidor de MySQL, perssione <Enter> para continuar"
	# opção do comando: &>> (redirecionar a saída padrão)
	#[mysqld]
	#sql_mode = NO_ENGINE_SUBSTITUTION
	read
	vim /etc/mysql/mysql.conf.d/mysqld.cnf
	sudo service mysql restart &>> $LOG
echo -e "Banco de Dados editado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Editando as Configurações do PHP, perssione <Enter> para continuar"
	# opção do comando: &>> (redirecionar a saída padrão)
	#[Date]
	#date.timezone = America/Sao_Paulo
	read
	vim /etc/php/7.2/apache2/php.ini
echo -e "Arquivo do PHP editado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o ZoneMinder, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (yes)
	apt -y install zoneminder &>> $LOG
echo -e "ZoneMinder instalado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Criando o Banco de Dados do ZoneMinder, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando mysql: -u (user), -p (password), -e (execute), < (Redirecionador de Saída STDOUT)
	mysql -u $USER -p$PASSWORD < $DATABASE &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$GRANTALL" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$FLUSH" mysql &>> $LOG
echo -e "Banco de Dados criado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Alterando as permissões do ZoneMinder, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opções do comando chmod: -v (verbose), 740 (dono=RWX,grupo=R,outro=)
	# opções do comando chown: -v (verbose), -R (recursive), root (dono), www-data (grupo)
	# opções do comando usermod: -a (append), -G (group), video (grupo), www-data (user)
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
	# opção do comando: &>> (redirecionar a saída padrão)
	# a2enmod (Apache2 Enable Mode), a2enconf (Apache2 Enable Conf)
	a2enmod cgi &>> $LOG
	a2enmod rewrite &>> $LOG
	a2enconf zoneminder &>> $LOG
	service apache2 restart &>> $LOG
echo -e "Recurso habilitado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
#
echo -e "Criando o Serviço do ZoneMinder, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	systemctl enable zoneminder &>> $LOG
	service zoneminder start &>> $LOG
echo -e "Serviço criado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do ZoneMinder feita com Sucesso!!!"
	# script para calcular o tempo gasto (SCRIPT MELHORADO, CORRIGIDO FALHA DE HORA:MINUTO:SEGUNDOS)
	# opção do comando date: +%T (Time)
	HORAFINAL=`date +%T`
	# opção do comando date: -u (utc), -d (date), +%s (second since 1970)
	HORAINICIAL01=$(date -u -d "$HORAINICIAL" +"%s")
	HORAFINAL01=$(date -u -d "$HORAFINAL" +"%s")
	# opção do comando date: -u (utc), -d (date), 0 (string command), sec (force second), +%H (hour), %M (minute), %S (second), 
	TEMPO=`date -u -d "0 $HORAFINAL01 sec - $HORAINICIAL01 sec" +"%H:%M:%S"`
	# $0 (variável de ambiente do nome do comando)
	echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo."
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Fim do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
read
exit 1
