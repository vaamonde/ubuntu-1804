#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 04/08/2020
# Data de atualização: 04/08/2020
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
# Testado e homologado para a versão do Rocket.Chat 3.4
#
# O Rocket.Chat é um servidor de bate-papo na Web, desenvolvido em JavaScript, usando a estrutura de pilha completa 
# do Meteor. É uma ótima solução para comunidades e empresas que desejam hospedar seu próprio serviço de bate-papo 
# em particular ou para desenvolvedores que desejam criar e evoluir suas próprias plataformas de bate-papo.
#
# Informações que serão solicitadas na configuração via Web do Rocket.Chat
#
# Site Oficial do Projeto: https://rocket.chat/
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
#
# Variável da Data Inicial para calcular o tempo de execução do script (VARIÁVEL MELHORADA)
# opção do comando date: +%T (Time)
HORAINICIAL=$(date +%T)
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
USUARIO=$(id -u)
UBUNTU=$(lsb_release -rs)
KERNEL=$(uname -r | cut -d'.' -f1,2)
#
# Variável do caminho do Log dos Script utilizado nesse curso (VARIÁVEL MELHORADA)
# opções do comando cut: -d (delimiter), -f (fields)
# $0 (variável de ambiente do nome do comando)
LOG="/var/log/$(echo $0 | cut -d'/' -f2)"
#
# Declarando as variáveis de download do Rocket.Chat (Links atualizados no dia 22/07/2020)
KEYSRVMONGODB="https://www.mongodb.org/static/pgp/server-4.2.asc"
KEYSRVNODEJS="https://deb.nodesource.com/setup_14.x"
ROCKETCHAT="https://releases.rocket.chat/latest/download"
#
# Verificando se o usuário é Root, Distribuição é >=18.04 e o Kernel é >=4.15 <IF MELHORADO)
# [ ] = teste de expressão, && = operador lógico AND, == comparação de string, exit 1 = A maioria dos erros comuns na execução
clear
if [ "$USUARIO" == "0" ] && [ "$UBUNTU" == "18.04" ] && [ "$KERNEL" == "4.15" ]
	then
		echo -e "O usuário é Root, continuando com o script..."
		echo -e "Distribuição é >=18.04.x, continuando com o script..."
		echo -e "Kernel é >= 4.15, continuando com o script..."
		sleep 5
	else
		echo -e "Usuário não é Root ($USUARIO) ou Distribuição não é >=18.04.x ($UBUNTU) ou Kernel não é >=4.15 ($KERNEL)"
		echo -e "Caso você não tenha executado o script com o comando: sudo -i"
		echo -e "Execute novamente o script para verificar o ambiente."
		exit 1
fi
#
# Script de instalação do Rocket.Chat no GNU/Linux Ubuntu Server 18.04.x
# opção do comando echo: -e (enable interpretation of backslash escapes), \n (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
# opção do comando cut: -d (delimiter), -f (fields)
echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
#
clear
echo -e "Instalação do Rocket.Chat no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a instalação do Rocket.Chat acesse a URL: http://`hostname -I | cut -d' ' -f1`:30000\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet..."
sleep 5
#
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
clear
#
echo -e "Instalando o Rocket.Chat, aguarde...\n"
#
echo -e "Adicionando o repositório do MongoDB, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando wget: -q (quiet), -O (output document file)
	# opção do comando cp: -v (verbose)
	wget -qO - $KEYSRVMONGODB | apt-key add - &>> $LOG
	cp -v conf/mongodb-org-4.2.list /etc/apt/sources.list.d/ &>> $LOG
echo -e "Repositório do MongoDB adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o MongoDB, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)
	# opção do comando apt: -y (yes)
	# opção do comando cp: -v (verbose)
  	apt -y install mongodb-org build-essential &>> $LOG
	cp -v /etc/mongod.conf /etc/mongod.conf.bkp &>> $LOG
	cp -v conf/mongod.conf /etc/mongod.conf &>> $LOG
echo -e "MongoDB instalado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Editando o arquivo de configuração do MongoDB, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)
  	vim /etc/mongod.conf
	systemctl enable mongod &>> $LOG
	systemctl restart mongod &>> $LOG
echo -e "Arquivo editado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Configurando o conjunto de Réplicas do MongoDB, pressione <Enter> para acessar o MongoDB"
	# opção do comando: &>> (redirecionar a saida padrão)
    # digite o comando: rs.initiate() - após o término digite o comando: exit
	read
	mongo
echo -e "Conjunto de Réplicas do MongoDB configurada com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Adicionando o repositório do Node.js, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (yes)
	# opção do comando wget: -q (quiet), -O (output document file)
	# opção do comando cp: -v (verbose)
	# opção do comando curl: -s (silent), -L (location)
	apt -y install curl npm &>> $LOG
	curl -sL $KEYSRVNODEJS | sudo -E bash - &>> $LOG
echo -e "Repositório do Node.js adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
$
echo -e "Instalando o Node.js, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)
	# opção do comando apt: -y (yes)
  	apt -y install nodejs software-properties-common graphicsmagick &>> $LOG
echo -e "Node.js instalado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Baixando e descompactando o Rocket.Chat do site Oficial, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)
	# opção do comando rm: -v (verbose)
	# opção do comando curl: -L (location), -o (output file)
	# opção do comando tar: -x (extract), -z (gzip), -v (verbose), -f (file)
	rm -v rocket.chat.tgz &>> $LOG
	curl -L $ROCKETCHAT -o rocket.chat.tgz &>> $LOG
  	tar -xzvf rocket.chat.tgz &>> $LOG
echo -e "Rocket.Chat baixado e descompactado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o Rocket.Chat, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)
	# opção do comando cd: - (return to source directory)
	# opção do comando mv: -v (verbose)
	mv -v bundle/ /opt/Rocket.Chat &>> $LOG
	cd /opt/Rocket.Chat/programs/server &>> $LOG
	npm install &>> $LOG
	cd - &>> $LOG
echo -e "Rocket.chat instalado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Configurando a segurança do Rocket.Chat, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)
	# opção do comando useradd: -M (no create home)
	# opção do comando usermod: -L (lock)
	# opção do comando chown: -R (recursive), -v (verbose), user:group
	useradd -M rocketchat &>> $LOG
	usermod -L rocketchat &>> $LOG
	chown -Rv rocketchat:rocketchat /opt/Rocket.Chat &>> $LOG
echo -e "Segurança do Rocket.chat configurada com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Definindo as Variáveis de Ambiente de Teste do Rocket.Chat, aguarde..."
	export PORT=30000
	export ROOT_URL=http://0.0.0.0:30000/
	export MONGO_URL=mongodb://localhost:27017/rocketchat
	export MONGO_OPLOG_URL=mongodb://localhost:27017/local?replSet=rs01
	cd /opt/Rocket.Chat
	node main.js
	cd - &>> $LOG
echo -e "Variáveis do Rocket.chat configuradas com sucesso!!!, continuando com o script..."
sleep 5
echo
#	
echo -e "Configurando o serviço Rocket.Chat, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)
	cp -v conf/rocketchat.service /etc/systemd/system/ &>> $LOG
	systemctl daemon-reload &>> $LOG
	systemctl enable rocketchat &>> $LOG
	systemctl start rocketchat &>> $LOG
echo -e "Serviço do Rocket.chat configurado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Verificando as portas de conexão do Rocket.Chat, aguarde..."
	# opção do comando netstat: a (all), n (numeric)
	# opção do comando grep: \| (função OU)
	netstat -an | grep '30000\|27017'
echo -e "Portas verificadas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do Rocket.Chat feita com Sucesso!!!."
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
