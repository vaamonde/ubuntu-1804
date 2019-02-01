#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 01/02/2019
# Data de atualização: 01/02/2019
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
# Testado e homologado para a versão do SAMBA-4.9.4
#
# O SAMBA é uma reimplementação de software livre do protocolo de rede SMB e foi originalmente desenvolvido por
# Andrew Tridgell. O Samba fornece serviços de arquivo e impressão para vários clientes do Microsoft Windows e 
# pode se integrar a um domínio do Microsoft Windows Server, como um controlador de domínio (DC) ou como um 
# membro do domínio. A partir da versão 4, ele suporta domínios do Active Directory e do Microsoft Windows NT.
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
#
# Variável da Data Inicial para calcular o tempo de execução do script (VARIÁVEL MELHORADA)
# opção do comando date: +%T (Time)
HORAINICIAL=`date +%T`
#
# Variáveis para validar o ambiente, verificando se o usuário e "root", versão do ubuntu e kernel
# opções do comando id: -u (user)
# opções do comando: lsb_release: -r (release), -s (short), 
# opões do comando uname: -r (kernel release)
# opções do comando cut: -d (delimiter), -f (fields)
# opção do shell script: piper | = Conecta a saída padrão com a entrada padrão de outro comando
# opção do shell script: acento crase ` ` = Executa comandos numa subshell, retornando o resultado
# opção do shell script: aspas simples ' ' = Protege uma string completamente (nenhum caractere é especial)
# opção do shell script: aspas duplas " " = Protege uma string, mas reconhece $, \ e ` como especiais
USUARIO=`id -u`
UBUNTU=`lsb_release -rs`
KERNEL=`uname -r | cut -d'.' -f1,2`
#
# Variável do caminho do Log dos Script utilizado nesse curso (VARIÁVEL MELHORADA)
# opções do comando cut: -d (delimiter), -f (fields)
# $0 (variável de ambiente do nome do comando)
VARLOGPATH="/var/log/$(echo $0 | cut -d'/' -f2)"
#
# Variável do caminho para armazenar os Log's de instalação
LOG=$VARLOGPATH
#
# Declarando as variaveis de Download do SAMBA4: https://www.samba.org/samba/download/
SAMBA4="https://download.samba.org/pub/samba/samba-latest.tar.gz"
#
# Verificando se o usuário e Root, Distribuição e >=18.04 e o Kernel >=4.15 <IF MELHORADO)
# [ ] = teste de expressão, && = operador lógico AND, == comparação de string, exit 1 = A maioria dos erros comuns na execução
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
# Script de instalação do SAMBA4 no GNU/Linux Ubuntu Server 18.04.x
# opção do comando echo: -e (enable interpretation of backslash escapes), \n (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
#
echo -e "Instalação do SAMBA4 no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet...\n"
sleep 5
echo
#
echo -e "Adicionando o Repositório Universal do Apt, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	add-apt-repository universe &>> $LOG
echo -e "Repositório adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Adicionando o Repositório Multiversão do Apt, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	add-apt-repository multiverse &>> $LOG
echo -e "Repositório adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando as listas do Apt, aguarde..."
	#opção do comando: &>> (redirecionar a entrada padrão)
	apt update &>> $LOG
echo -e "Listas atualizadas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando o sistema, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando apt: -y (yes)
	apt -y upgrade &>> $LOG
echo -e "Sistema atualizado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Removendo software desnecessários, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando apt: -y (yes)
	apt -y autoremove &>> $LOG
echo -e "Software removidos com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o SAMBA-4, aguarde..."
echo
#
echo -e "Instalando as dependências do SAMBA4, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando apt: -y (yes), \ (bar left) quedra de linha na opção do apt
	apt install -y acl attr autoconf bind9utils bison build-essential debhelper dnsutils docbook-xml docbook-xsl \
	flex gdb libjansson-dev krb5-user krb5-config libacl1-dev libaio-dev libarchive-dev libattr1-dev libblkid-dev \
	libbsd-dev libcap-dev libcups2-dev libgnutls28-dev libgpgme-dev libjson-perl libldap2-dev libncurses5-dev \
	libpam0g-dev libparse-yapp-perl libpopt-dev libreadline-dev nettle-dev perl perl-modules-5.26 pkg-config \
	python-all-dev python-crypto python-dbg python-dev python-dnspython python3-dnspython python-gpg \
	python3-gpg python-markdown python3-markdown python3-dev xsltproc zlib1g-dev liblmdb-dev lmdb-utils \
	winbind libpam-winbind libnss-winbind ntp ntpdate
echo -e "Dependências instaladas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Download e instalação do SAMBA4, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando wget: -O (file)
	wget $SAMBA4 &>> $LOG
	# opção do comando tar: -z (gzip), -x (extract), -v (verbose), -f (file)
	tar -zxvf samba-latest.tar.gz &>> $LOG
	# acessando diretório do dahdi-linux
	cd samba-*/ &>> $LOG
	# preparação e configuração do source para compilação
	./configure --sysconfdir=/etc/samba/ --mandir=/usr/share/man/ --enable-debug --enable-selftest &>> $LOG
	# desfaz o processo de compilação anterior
	make clean  &>> $LOG
	# compila todas as opções do software
	make all &>> $LOG
	# testa a compilação em busca de erros
	# make test &>> $LOG
	# executa os comandos para instalar o programa
	make install &>> $LOG
	# exportação de variável de ambiente do SAMBA4 no PATH de execução
	export PATH=/usr/local/samba/bin/:/usr/local/samba/sbin/:$PATH
	# opção do comando cd: .. (dois pontos sequenciais - Subir uma pasta)
	cd ..
echo -e "SAMBA4 instalado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Desabilitando os serviços no Systemd, aguarde..."
	systemctl mask smbd nmbd winbind &>> $LOG
	systemctl disable smbd nmbd winbind &>> $LOG
echo -e "Serviços desabilitado com sucesso!!!, continuando com o script"
sleep 5
echo
#
echo -e "Criando o serviço do SAMBA4 no Systemd, aguarde..."
	cp -v conf/samba-ad-dc.service /etc/systemd/system/ &>> $LOG
	systemctl daemon-reload &>> $LOG
	systemctl enable samba-ad-dc &>> $LOG
	systemctl start samba-ad-dc &>> $LOG
echo -e "Serviço criado com sucesso!!!, continuando com o script"
sleep 5
echo
#
echo -e "Instalação do SAMBA4 feita com Sucesso!!!"
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
