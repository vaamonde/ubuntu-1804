#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 06/01/2019
# Data de atualização: 06/01/2019
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
#
# O Asterisk é um software livre, de código aberto, que implementa em software os recursos encontrados em um PABX 
# convencional, utilizando tecnologia de VoIP. Ele foi criado pelo Mark Spencer em 1999.
# Inicialmente desenvolvido pela empresa Digium, hoje recebe contribuições de programadores ao redor de todo o mundo. 
# Seu desenvolvimento é ativo e sua área de aplicação muito promissora.
#
# DAHDI = DAHDI (Digium\Asterisk Hardware Device Interface) é uma coleção de drivers de código aberto, para o Linux, 
# que são usados para fazer interface com uma variedade de hardware relacionado à telefonia.
#
# DAHDI Tools = contém uma variedade de utilitários de comandos do usuário que são usados para configurar e testar os 
# drivers de hardware desenvolvidos pela Digium e Zapatel.
#
# LIBPRI = A biblioteca libpri permite que o Asterisk se comunique com conexões ISDN. Você só precisará disso se for 
# usar o DAHDI com hardware de interface ISDN (como placas T1 / E1 / J1 / BRI).
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
#
# Variável da Data Inicial para calcular o tempo de execução do script
# opção do comando date: +%s (seconds since)
DATAINICIAL=`date +%s`
#
# Variáveis para validar o ambiente, verificando se o usuário e "root", versão do ubuntu e kernel
# opções do comando id: -u (user), opções do comando: lsb_release: -r (release), -s (short), 
# opões do comando uname: -r (kernel release), opções do comando cut: -d (delimiter), -f (fields)
# opção do caracter: | (piper) Conecta a saída padrão com a entrada padrão de outro comando
# opção do shell script: acento crase ` ` = Executa comandos numa subshell, retornando o resultado
# opção do shell script: aspas simples ' ' = Protege uma string completamente (nenhum caractere é especial)
# opção do shell script: aspas duplas " " = Protege uma string, mas reconhece $, \ e ` como especiais
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
# Declarando as variaveis de Download do Asterisk
DAHDI="git://git.asterisk.org/dahdi/linux dahdi-linux"
DAHDITOOLS="git://git.asterisk.org/dahdi/tools dahdi-tools"
LIBPRI="http://gerrit.asterisk.org/libpri libpri"
ASTERISK="http://gerrit.asterisk.org/asterisk asterisk"
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
# Script de instalação do Asterisk no GNU/Linux Ubuntu Server 18.04.x
# opção do comando hostname: -I (all IP address)
echo
echo -e "Instalação do Asterisk no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet..."
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
echo -e "Adicionando o Repositório Multiverse do Apt, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	add-apt-repository multiverse &>> $LOG
echo -e "Repositório adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando as listas do Apt, aguarde..."
	 opção do comando: &>> (redirecionar a entrada padrão)
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
echo -e "Instalando o Asterisk, aguarde..."
echo
#
echo -e "Instalando as dependências do Asterisk, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando apt: -y (yes) | $(uname -r) = kernel-release
	apt install -y build-essential libssl-dev libelf-dev libncurses5-dev libnewt-dev libxml2-dev linux-headers-$(uname -r) libsqlite3-dev uuid-dev subversion libjansson-dev sqlite3 autoconf automake libtool libedit-dev flex bison libtool libtool-bin &>> $LOG
echo -e "Dependências instaladas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Download e instalação do DAHDI, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando git: clone (clonar projeto)
	git clone $DAHDI &>> $LOG
	cd dahdi-linux*/
	#preparação e configuração do source para compilação
	./configure  &>> $LOG
	#desfaz o processo de compilação anterior
	make clean  &>> $LOG
	#compila todas as opções do software
	make all  &>> $LOG
	#executa os comandos para instalar o programa
	make install  &>> $LOG
	cd ..
echo -e "DAHDI instalado com sucesso!!!, continuando com o script..."
sleep 5
echo	
#
echo -e "Download e instalação do DAHDI Tools, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando git: clone (clonar projeto)
	git clone $DAHDITOOLS &>> $LOG
	cd dahdi-tools*/
	#atualize os arquivos de configuração gerados
	autoreconf -i  &>> $LOG
	#preparação e configuração do source para compilação
	./configure &>> $LOG
	#desfaz o processo de compilação anterior
	make clean  &>> $LOG
	#compila todas as opções do software
	make all  &>> $LOG
	#executa os comandos para instalar o programa
	make install  &>> $LOG
	cd ..
echo -e "DAHDI Tools instalado com sucesso!!!, continuando com o script..."
sleep 5
echo	
#
echo -e "Download e instalação do LIBPRI, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando git: clone (clonar projeto)
	git clone $LIBPRI &>> $LOG
	cd libpri*/ &>> $LOG
	#preparação e configuração do source para compilação
	./configure &>> $LOG
	#desfaz o processo de compilação anterior
	make clean  &>> $LOG
	#compila todas as opções do software
	make all &>> $LOG
	#executa os comandos para instalar o programa
	make install &>> $LOG
	cd ..
echo -e "LIBPRI instalado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Download e instalação do Asterisk, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando git: clone (clonar projeto)
	git clone $ASTERISK &>> $LOG
	cd asterisk*/
	#preparação e configuração do source para compilação
	./configure &>> $LOG
	#desfaz o processo de compilação anterior
	make clean  &>> $LOG
	#compila todas as opções do software
	make all &>> $LOG
	#executa os comandos para instalar o programa
	make install &>> $LOG
	#instala um conjunto de arquivos de configuração de amostra para o Asterisk
	make samples &>> $LOG
	#instala um conjunto de configuração básica para o Asterisk
	make basic-pbx &>> $LOG
	#instala um conjunto de scripts de inicialização do Asterisk
	make config &>> $LOG
	#instala um conjunto de scripts de configuração dos Logs do Asterisk
	make install-logrotate &>> $LOG
	#inicializando o serviço do Asterisk
	sudo service asterisk start &>> $LOG
	cd ..
echo -e "Asterisk instalado com sucesso!!!, continuando com o script..."
sleep 5
echo	
#
echo -e "Instalação do Asterisk feita com Sucesso!!!"
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
