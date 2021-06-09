#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 09/06/2021
# Data de atualização: 09/06/2021
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
# Testado e homologado para a versão do VSFTPD v3.0.x
#
# O VSFTPd, é um servidor FTP para sistemas do tipo Unix, incluindo Linux. É o servidor FTP 
# padrão nas distribuições Ubuntu, CentOS, Fedora, NimbleX, Slackware e RHEL Linux. Está 
# licenciado pela GNU General Public License. Suporta IPv4, IPv6, TLS e FTPS.
#
# Site Oficial do Projeto Zimbra: https://security.appspot.com/vsftpd.html
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
# Vídeo de configuração do OpenSSH no GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=ecuol8Uf1EE&t
# Vídeo de instalação do LAMP Server no Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=6EFUu-I3u4s
# Vídeo de instalação e configuração do Bind9 DNS e do ISC DHCP Server: https://www.youtube.com/watch?v=NvD9Vchsvbk
# Vídeo de configuração do OpenSSL no Apache2: https://www.youtube.com/watch?v=GXcwpJfp7eo
# Vídeo de instalação e configuração do Wordpress: https://www.youtube.com/watch?v=Fs2B7kLdlm4
#
# Variável da Data Inicial para calcular o tempo de execução do script (VARIÁVEL MELHORADA)
# opção do comando date: +%T (Time)
HORAINICIAL=$(date +%T)
#
# Variáveis para validar o ambiente, verificando se o usuário é "root", versão do ubuntu e kernel
# opções do comando id: -u (user)
# opções do comando: lsb_release: -r (release), -s (short), 
# opões do comando uname: -r (kernel release)
# opções do comando cut: -d (delimiter), -f (fields)
# opção do shell script: piper | = Conecta a saída padrão com a entrada padrão de outro comando
# opção do shell script: acento crase ` ` = Executa comandos numa subshell, retornando o resultado
# opção do shell script: aspas simples ' ' = Protege uma string completamente (nenhum caractere é especial)
# opção do shell script: aspas duplas " " = Protege uma string, mas reconhece $, \ e ` como especiais
USUARIO=$(id -u)
UBUNTU=$(lsb_release -rs)
KERNEL=$(uname -r | cut -d'.' -f1,2)
#
# Criação do Grupo dos Usuários de FTP e Usuários de Acesso ao FTP
GROUPFTP="ftpusers"
USERFTP1="ftpuser"
USERFTP2="wordpress"
PASSWORD="pti@2018"
WORDPRESS="/var/www/html/wp"
#
# Variável do caminho do Log dos Script utilizado nesse curso (VARIÁVEL MELHORADA)
# opções do comando cut: -d (delimiter), -f (fields)
# $0 (variável de ambiente do nome do comando)
LOG="/var/log/$(echo $0 | cut -d'/' -f2)"
#
# Exportando o recurso de Noninteractive do Debconf para não solicitar telas de configuração
export DEBIAN_FRONTEND="noninteractive"
#
# Verificando se o usuário é Root, Distribuição é >=18.04 e o Kernel é >=4.15 <IF MELHORADO)
# [ ] = teste de expressão, && = operador lógico AND, == comparação de string, exit 1 = A maioria dos erros comuns na execução
clear
if [ "$USUARIO" == "0" ] && [ "$UBUNTU" == "18.04" ] && [ "$KERNEL" == "4.15" ]
	then
		echo -e "O usuário é Root, continuando com o script..."
		echo -e "Distribuição é >= 18.04.x, continuando com o script..."
		echo -e "Kernel é >= 4.15, continuando com o script..."
		sleep 5
	else
		echo -e "Usuário não é Root ($USUARIO) ou Distribuição não é >=18.04.x ($UBUNTU) ou Kernel não é >=4.15 ($KERNEL)"
		echo -e "Caso você não tenha executado o script com o comando: sudo -i"
		echo -e "Execute novamente o script para verificar o ambiente."
		exit 1
fi
#
# Verificando se as dependências do Vsftpd estão instaladas
# opção do dpkg: -s (status), opção do echo: -e (interpretador de escapes de barra invertida), -n (permite nova linha)
# || (operador lógico OU), 2> (redirecionar de saída de erro STDERR), && = operador lógico AND, { } = agrupa comandos em blocos
# [ ] = testa uma expressão, retornando 0 ou 1, -ne = é diferente (NotEqual)
echo -n "Verificando as dependências do Vsftpd Server, aguarde... "
	for name in bind9 bind9utils apache2 
	do
		[[ $(dpkg -s $name 2> /dev/null) ]] || { 
			echo -en "\n\nO software: $name precisa ser instalado. \nUse o comando 'apt install $name'\n";
			deps=1; 
			}
	done
		[[ $deps -ne 1 ]] && echo "Dependências.: OK" || { 
			echo -en "\nInstale as dependências acima e execute novamente este script\n";
			echo -en "Recomendo utilizar o script: lamp.sh para resolver as dependências."
			echo -en "Recomendo utilizar o script: dnsdhcp.sh para resolver as dependências."
			exit 1; 
			}
		sleep 5
#
# Script de instalação do Vsftpd no GNU/Linux Ubuntu Server 18.04.x
# opção do comando echo: -e (enable interpretation of backslash escapes), \n (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
# opção do comando cut: -d (delimiter), -f (fields)
echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
clear
#
echo
echo -e "Instalação do Vsftpd Server no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a instalação do Vsftpd acessar o FTP: ftp://ftp.`hostname -d | cut -d' ' -f1`"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet...\n"
sleep 5
#
echo -e "Adicionando o Repositório Universal do Apt, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	add-apt-repository universe &>> $LOG
echo -e "Repositório adicionado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Adicionando o Repositório Multiversão do Apt, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	add-apt-repository multiverse &>> $LOG
echo -e "Repositório adicionado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Atualizando as listas do Apt, aguarde..."
	#opção do comando: &>> (redirecionar a saída padrão)
	apt update &>> $LOG
echo -e "Listas atualizadas com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Atualizando o sistema, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (yes)
	apt -y upgrade &>> $LOG
echo -e "Sistema atualizado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Removendo software desnecessários, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (yes)
	apt -y autoremove &>> $LOG
echo -e "Software removidos com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Instalando o Vsftpd Server e criando os usuários, aguarde...\n"
sleep 5
#
echo -e "Instalando o Serviço do Vsftpd Server, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	apt -y install vsftpd &>> $LOG
echo -e "Vsftpd Server instalado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Criando o Grupo padrão dos Usuários do FTP, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	groupadd ftpusers &>> $LOG
echo -e "Grupo criado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Criando o Usuário padrão do FTP, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando useradd: -s (shell), -G (Groups)
	# opção do comando echo: -e (enable escapes), \n (new line), 
	# opção do redirecionar | "piper": (Conecta a saída padrão com a entrada padrão de outro comando)
	# opção do comando mkdir: -v (verbose)
	# opção do comando chown: -R (recursive), -v (verbose)
	# opção do comando chmod: -R (recursive), -v (verbose), 755 (User=RWX,Group=R-X,Other=R-X)
	useradd -s /bin/bash -G $GROUPFTP $USERFTP1 &>> $LOG
	echo -e "$PASSWORD\n$PASSWORD" | passwd $USERFTP1 &>> $LOG
	mkdir -v /home/$USERFTP1 &>> $LOG
	chown -Rv $USERFTP1.$GROUPFTP /home/$USERFTP1 &>> $LOG
	chmod -Rv 755 /home/$USERFTP1 &>> $LOG
echo -e "Usuário padrão o FTP criado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Criando o Usuário de FTP do Wordpress, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando useradd: -d (home-dir), -s (shell), -G (Groups)
	# opção do comando echo: -e (enable escapes), \n (new line), 
	# opção do redirecionar | "piper": (Conecta a saída padrão com a entrada padrão de outro comando)
	useradd -d $WORDPRESS -s /bin/bash -G www-data,$GROUPFTP $USERFTP2 &>> $LOG
	echo -e "$PASSWORD\n$PASSWORD" | passwd $USERFTP2 &>> $LOG
echo -e "Usuário de FTP do Wordpress criado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Atualizando o arquivo de configuração do Vsftpd Server, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando mv: -v (verbose)
	# opção do comando cp: -v (verbose)
	mv -v /etc/vsftpd.conf /etc/vsftpd.conf.old &>> $LOG
	cp -v conf/vsftpd.conf /etc/vsftpd.conf &>> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Editando o arquivo de configuração do Vsftpd Server, aguarde..."
	read
	/etc/vsftpd.conf
echo -e "Arquivo editado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Reinicializando o serviço do Vsftpd Server, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	systemctl restart vsftpd &>> $LOG
echo -e "Porta de conexão verificada com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Verificando a porta do Vsftpd Server, aguarde..."
	# opção do comando netstat: -a (all), -n (numeric)
	netstat -an | grep ':21'
echo -e "Porta de conexão verificada com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Instalação do Vsftpd Server feita com Sucesso!!!"
	# script para calcular o tempo gasto (SCRIPT MELHORADO, CORRIGIDO FALHA DE HORA:MINUTO:SEGUNDOS)
	# opção do comando date: +%T (Time)
	HORAFINAL=$(date +%T)
	# opção do comando date: -u (utc), -d (date), +%s (second since 1970)
	HORAINICIAL01=$(date -u -d "$HORAINICIAL" +"%s")
	HORAFINAL01=$(date -u -d "$HORAFINAL" +"%s")
	# opção do comando date: -u (utc), -d (date), 0 (string command), sec (force second), +%H (hour), %M (minute), %S (second), 
	TEMPO=$(date -u -d "0 $HORAFINAL01 sec - $HORAINICIAL01 sec" +"%H:%M:%S")
	# $0 (variável de ambiente do nome do comando)
	echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo."
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Fim do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
read
exit 1
