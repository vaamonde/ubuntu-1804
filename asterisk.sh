#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 06/01/2019
# Data de atualização: 10/02/2019
# Versão: 0.10
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
# Testado e homologado para a versão do Asterisk 16.1.1
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
# iLBC = O iLBC (internet Low Bitrate Codec) é um codec de voz GRATUITO adequado para comunicação de voz robusta sobre IP. 
# O codec é projetado para fala de banda estreita e resulta em uma taxa de bits de carga útil de 13,33 kbit / s com um 
# comprimento de quadro de codificação de 30 ms e 15,20 kbps com um comprimento de codificação de 20 ms.
#
# H.323 =  é um conjunto de padrões da ITU-T que define um conjunto de protocolos para o fornecimento de comunicação de áudio 
# e vídeo numa rede de computadores. O H.323 é um protocolo relativamente antigo que está atualmente sendo substituído pelo SIP.
#
# Site Oficial do Asterisk: https://www.asterisk.org/
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
LOG="/var/log/$(echo $0 | cut -d'/' -f2)"
#
# Declarando as variaveis de Download do Asterisk: http://downloads.asterisk.org/pub/telephony/
DAHDI="http://downloads.asterisk.org/pub/telephony/dahdi-linux/dahdi-linux-current.tar.gz"
DAHDITOOLS="http://downloads.asterisk.org/pub/telephony/dahdi-tools/dahdi-tools-current.tar.gz"
LIBPRI="http://downloads.asterisk.org/pub/telephony/libpri/libpri-current.tar.gz"
ASTERISK="http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-16-current.tar.gz"
PTBRCORE="https://www.asterisksounds.org/pt-br/download/asterisk-sounds-core-pt-BR-sln16.zip"
PTBREXTRA="https://www.asterisksounds.org/pt-br/download/asterisk-sounds-extra-pt-BR-sln16.zip"
SOUNDS="/var/lib/asterisk/sounds/pt_BR"
COUNTRYCODE="55"
#
# Exportando o recurso de Noninteractive do Debconf para não solicitar telas de configuração
export DEBIAN_FRONTEND="noninteractive"
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
# Script de instalação do Asterisk no GNU/Linux Ubuntu Server 18.04.x
# opção do comando echo: -e (enable interpretation of backslash escapes), \n (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
#
echo -e "Instalação do Asterisk no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet...\n"
echo -e "Após a instalação, para acessar o CLI do Asterisk, digite o comando: asterisk -rvvvv"
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
echo -e "Adicionando o Repositório Multiversão do Apt, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	add-apt-repository multiverse &>> $LOG
echo -e "Repositório adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando as listas do Apt, aguarde..."
	#opção do comando: &>> (redirecionar a saída padrão)
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
echo -e "Instalando o Asterisk, aguarde..."
echo
#
echo -e "Instalando as dependências do Asterisk, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (yes) | $(uname -r) = kernel-release, \ (bar left) quedra de linha na opção do apt
	apt install -y build-essential libssl-dev libelf-dev libncurses5-dev libnewt-dev libxml2-dev linux-headers-$(uname -r) \
	libsqlite3-dev uuid-dev subversion libjansson-dev sqlite3 autoconf automake libtool libedit-dev flex bison libtool \
	libtool-bin unzip sox openssl zlib1g-dev unixodbc unixodbc-dev &>> $LOG
echo -e "Dependências instaladas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Download e instalação do DAHDI, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando wget: -O (file)
	wget -O dahdi-linux.tar.gz $DAHDI &>> $LOG
	# opção do comando tar: -z (gzip), -x (extract), -v (verbose), -f (file)
	tar -zxvf dahdi-linux.tar.gz &>> $LOG
	# acessando diretório do dahdi-linux
	cd dahdi-linux*/ &>> $LOG
	# preparação e configuração do source para compilação
	./configure  &>> $LOG
	# desfaz o processo de compilação anterior
	make clean  &>> $LOG
	# compila todas as opções do software
	make all  &>> $LOG
	# executa os comandos para instalar o programa
	make install  &>> $LOG
	# opção do comando cd: .. (dois pontos sequenciais - Subir uma pasta)
	cd ..
echo -e "DAHDI instalado com sucesso!!!, continuando com o script..."
sleep 5
echo	
#
echo -e "Download e instalação do DAHDI Tools, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando wget: -O (file)
	wget -O dahdi-tools.tar.gz $DAHDITOOLS &>> $LOG
	# opção do comando tar: -z (gzip), -x (extract), -v (verbose), -f (file)
	tar -zxvf dahdi-tools.tar.gz &>> $LOG
	# acessando diretório do dahdi-tools
	cd dahdi-tools*/ &>> $LOG
	# atualize os arquivos de configuração gerados
	autoreconf -i  &>> $LOG
	# preparação e configuração do source para compilação
	./configure &>> $LOG
	# desfaz o processo de compilação anterior
	make clean  &>> $LOG
	# compila todas as opções do software
	make all  &>> $LOG
	# executa os comandos para instalar o programa
	make install  &>> $LOG
	# opção do comando cd: .. (dois pontos sequenciais - Subir uma pasta)
	cd ..
echo -e "DAHDI Tools instalado com sucesso!!!, continuando com o script..."
sleep 5
echo	
#
echo -e "Download e instalação do LIBPRI, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando wget: -O (file)
	wget -O libpri.tar.gz $LIBPRI &>> $LOG
	# opção do comando tar: -z (gzip), -x (extract), -v (verbose), -f (file)
	tar -zxvf libpri.tar.gz &>> $LOG
	# acessando diretório do libpri
	cd libpri*/ &>> $LOG
	# preparação e configuração do source para compilação
	./configure &>> $LOG
	# desfaz o processo de compilação anterior
	make clean  &>> $LOG
	# compila todas as opções do software
	make all &>> $LOG
	# executa os comandos para instalar o programa
	make install &>> $LOG
	# opção do comando cd: .. (dois pontos sequenciais - Subir uma pasta)
	cd ..
echo -e "LIBPRI instalado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Download e instalação do Asterisk, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando wget: -O (file)
	wget -O asterisk.tar.gz $ASTERISK &>> $LOG
	# opção do comando tar: -z (gzip), -x (extract), -v (verbose), -f (file)
	tar -zxvf asterisk.tar.gz &>> $LOG
	# acessando diretório do asterisk
	cd asterisk*/ &>> $LOG
	# resolvendo as dependências do suporte a Música e Sons em MP3
	bash contrib/scripts/get_mp3_source.sh &>> $LOG
	# resolvendo as dependências do suporte ao Codec iLBC
	bash contrib/scripts/get_ilbc_source.sh &>> $LOG
	# instalando as dependência do MP3 e ILBC utilizando o debconf-set-selections
	# opção do comando | (piper): (Conecta a saída padrão com a entrada padrão de outro comando)
	echo "libvpb1 libvpb1/countrycode $COUNTRYCODE" | debconf-set-selections &>> $LOG
	# opção do comando yes: yes é um comando utilizado, normalmente, em conjunto com outro, para responder sempre 
	# positivamente (ou negativamente) às perguntas do segundo programa
	yes | bash contrib/scripts/install_prereq install &>> $LOG
	# preparação e configuração do source para compilação
	./configure &>> $LOG
	# desfaz o processo de compilação anterior
	make clean  &>> $LOG
	# menu de seleção de configuração do Asterisk (recomendado)
	make menuselect
	clear
	echo -e "Compilando e instalando o Asterisk, aguarde...."
	# compila todas as opções do software marcadas nas opções do make menuselect
	make all &>> $LOG
	# executa os comandos para instalar o programa com as opções do make maneselect
	make install &>> $LOG
	# instala um conjunto de arquivos de configuração de amostra para o Asterisk
	make samples &>> $LOG
	# instala um conjunto de configuração básica para o Asterisk
	make basic-pbx &>> $LOG
	# instala um conjunto de documentção para o Asterisk
	# habilitar esse recurso, o processo de compilação demora bastante
	#make progdocs &>> $LOG
	# instala um conjunto de scripts de inicialização do Asterisk (systemctl)
	make config &>> $LOG
	# instala um conjunto de scripts de configuração dos Logs do Asterisk (rsyslog)
	make install-logrotate &>> $LOG
	# inicializando o serviço do Asterisk
	sudo systemctl start asterisk &>> $LOG
	# opção do comando cd: .. (dois pontos sequenciais - Subir uma pasta)
	cd ..
echo -e "Asterisk instalado com sucesso!!!, continuando com o script..."
sleep 5
echo		
#
echo -e "Download e configuração do Sons em Português/Brasil do Asterisk, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando mkdir: -v (verbose)
	mkdir -v $SOUNDS &>> $LOG
	# copiando o script convert.sh para conversão dos formatas de sons para o padrão do Asterisk
	# opção do comando cp: -v (verbose)
	cp -v conf/convert.sh $SOUNDS &>> $LOG
	# acessando o diretório dos sons em pt_BR
	cd $SOUNDS &>> $LOG
	# opção do comando wget: -O (file)
	wget -O core.zip $PTBRCORE &>> $LOG
	wget -O extra.zip $PTBREXTRA &>> $LOG
	# opção do comando unzip: -o (overwrite)
	unzip -o core.zip &>> $LOG
	unzip -o extra.zip &>> $LOG
	# converte os sons da pasta para outros formatos
	bash convert.sh &>> $LOG
	# opção do comando cd: - (traço, rollback voltar a pasta anterior)
	cd - &>> $LOG
echo -e "Configuração do Sons em Português/Brasil feito com sucesso!!!!, continuado com o script..."
sleep 5
echo
#
echo -e "Atualizando os arquivos de Ramais SIP, Plano de Discagem e Módulos, aguarde..."
	# fazendo o backup das confgurações originais dos arquivos de configuração
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando mv: -v (verbose)
	# opção do comando cp: -v (verbose)
	mv -v /etc/asterisk/sip.conf /etc/asterisk/sip.conf.bkp &>> $LOG
	mv -v /etc/asterisk/extensions.conf /etc/asterisk/extensions.conf.bkp &>> $LOG
	mv -v /etc/asterisk/modules.conf /etc/asterisk/modules.conf.bkp &>> $LOG
	# atualizando os arquivos de configurações
	# opção do comando cp: -v (verbose)
	cp -v conf/sip.conf /etc/asterisk/sip.conf &>> $LOG
	cp -v conf/extensions.conf /etc/asterisk/extensions.conf &>> $LOG
	cp -v conf/modules.conf /etc/asterisk/modules.conf &>> $LOG
echo -e "Arquivos atualizados com sucesso!!!, continuando com o script"
sleep 5
clear
#
echo -e "Configuração da Segurança do Asterisk, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# criando o grupo do asterisk
	groupadd asterisk &>> $LOG
	# criando o usuário asterisk
	# opções do comando useradd: -r (system account), -d (home directory), -g (group GID), asterisk (user)
	useradd -r -d /var/lib/asterisk -g asterisk asterisk &>> $LOG
	# alteração do grupos do usuário asterisk
	# opções do comando usermod: -a (append), -G (groups), asterisk (user)
	usermod -aG audio,dialout asterisk &>> $LOG
	# alteração do dono e grupo padrão das pastas do asterisk
	# opções do comando chown: -R (recursive), -v (verbose), Asterisk.Asterisk (Usuário.Grupo)
	chown -Rv asterisk.asterisk /etc/asterisk &>> $LOG
	chown -Rv asterisk.asterisk /var/{lib,log,spool}/asterisk &>> $LOG
	chown -Rv asterisk.asterisk /usr/lib/asterisk  &>> $LOG
	# opção do comando chmod: -R (recursive), -v (verbose), 775 (Dono=RWX,Grupo=RWX=Outros=R-X)
	chmod -Rv 775 /var/lib/asterisk/sounds/pt_BR &>> $LOG
	echo -e "Editando o arquivo de configuração padrão do Asterisk, pressione <Enter> para editar"
		read
		vim /etc/default/asterisk
	echo -e "Arquivo editado com sucesso!!!, continuando com o script..."
	sleep 5
	echo
	echo -e "Editando o arquivo e inicialização do Asterisk, pressione <Enter> para editar"
		read
		vim /etc/asterisk/asterisk.conf
		echo -e "Arquivo editado com sucesso!!!, continuando com o script..."
	sleep 5
	echo
	# habilitando o serviço do asterisk
	sudo systemctl enable asterisk &>> $LOG
	# reinicializando o serviços do asterisk
	sudo systemctl restart asterisk &>> $LOG
echo -e "Configuração da segurança do Asterisk feita com sucesso!!!, continuando com o script..."
sleep 5
clear
#
echo -e "Verificando a porta de Conexão do Protocolo SIP, aguarde..."
	#opção do comando netstat: -a (all), -n (numeric)
	netstat -an | grep 5060
echo -e "Porta de conexão verificada com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do Asterisk feita com Sucesso!!!"
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
