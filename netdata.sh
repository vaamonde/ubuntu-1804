#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 11/11/2018
# Data de atualização: 18/02/2019
# Versão: 0.05
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
#
# O Netdata é uma ferramenta para visualizar e monitorar métricas em tempo real, otimizado para acumular todos os tipos de
# dados, como uso da CPU, atividade do disco, consultas SQL, visitas a um site, etc. A ferramenta é projetada para visualizar 
# o agora com o máximo de detalhes possível, permitindo que o usuário tenha uma visão do que está acontecendo e do que acaba
# de acontecer em seu sistema ou aplicativo, sendo uma opção ideal para resolver problemas de desempenho em tempo real.
# https:\\(ip do servidor):(porta de utilização). Exemplo: https:\\172.16.1.20:19999
#
# Site oficial: https://github.com/netdata/netdata
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
# Vídeo de instalação do LAMP Server no Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=6EFUu-I3u4s
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
# Variável do download do Netdata
# opção do comando git clone --depth=1: Crie um clone superficial com um histórico truncado para o número especificado de confirmações
NETDATA="https://github.com/firehol/netdata.git --depth=1"
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
#
# Verificando se as dependêncais do Netdata estão instaladas
# opção do dpkg: -s (status), opção do echo: -e (intepretador de escapes de barra invertida), -n (permite nova linha)
# || (operador lógico OU), 2> (redirecionar de saída de erro STDERR), && = operador lógico AND, { } = agrupa comandos em blocos
# [ ] = testa uma expressão, retornando 0 ou 1, -ne = é diferente (NotEqual)
echo -n "Verificando as dependências, aguarde... "
	for name in mysql-server mysql-common apache2
	do
  		[[ $(dpkg -s $name 2> /dev/null) ]] || { echo -en "\n\nO software: $name precisa ser instalado. \nUse o comando 'apt install $name'\n";deps=1; }
	done
		[[ $deps -ne 1 ]] && echo "Dependências.: OK" || { echo -en "\nInstale as dependências acima e execute novamente este script\n";exit 1; }
		sleep 5
#
# Script de instalação do Netdata no GNU/Linux Ubuntu Server 18.04.x
# opção do comando echo: -e (enable interpretation of backslash escapes), \n (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
clear
echo -e "Instalação do Netdata no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a instalação do Netdata acessar a URL: http://`hostname -I`:19999/\n"
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
echo -e "Instalando o Netdata, aguarde..."
echo
#
echo -e "Instalando as dependências do Netdata, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (yes), \ (bar left) quedra de linha na opção do apt
	apt -y install zlib1g-dev gcc make git autoconf autogen automake pkg-config uuid-dev python python-mysqldb python-pip \
	python-dev python3-dev libmysqlclient-dev python-ipaddress &>> $LOG
echo -e "Instalação das dependências feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Fazendo a clonagem do Netdata, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	git clone $NETDATA &>> $LOG
echo -e "Clonagem do Netdata feito com sucesso!!!, continuando com o script..."
sleep 5
echo
#				 
echo -e "Instalando o Netdata, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando echo |: faz a função de Enter no Script
	cd netdata/
	echo | ./netdata-installer.sh &>> $LOG
echo -e "Instalação do Netdata feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Verificando a porta de conexão do Netdata, aguarde..."
	# opção do comando netstat: -a (all), -n (numeric)
	netstat -an | grep 19999
echo -e "Porta de conexão verificada com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Netdata instalado com sucesso!!!, pressione <Enter> para continuar com o script."
read
sleep 5
clear
#
echo -e "Editando o arquivo de monitoramento do MySQL, pressione <Enter> para editar"
	read
	sleep 5
	vim /usr/lib/netdata/conf.d/python.d/mysql.conf
echo -e "Arquivo editado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Reinicializando o serviço do Netdata, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	sudo service netdata restart &>> $LOG
echo -e "Serviço reinicializado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do Netdata feita com Sucesso!!!"
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
