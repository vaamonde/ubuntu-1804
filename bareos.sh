#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 10/02/2019
# Data de atualização: 10/02/2019
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
# Testado e homologado para a versão do BareOS-18.2.x
#
# O BareOS Server Bareos é uma bifurcação do projeto de código aberto Bacula versão 5.2. Em 2010, o desenvolvedor da 
# comunidade do Bacula, Marco Van Wieringen, começou a coletar contribuições das comunidades que foram rejeitadas ou 
# negligenciadas em começou a desenvolver sua própria vresão. Este trabalho foi mais tarde a base da criação do software 
# BareOS e desde então foi enriquecido com varios novos recursos.
#
# O BareOS é um conjunto de programas de computador que permite ao administrador do sistema gerenciar o backup, a recuperação
# e a verificação de dados de computadores em uma rede de que tenha diferentes tipos de sistemas operacionais. O BareOS também
# pode ser executado inteiramente em um único computador e pode fazer backup para vários tipos de mídia, incluindo fita e 
# disco. O Bareos é relativamente fácil de usar e eficiente, além de oferecer muitos recursos avançados de gerenciamento de 
# armazenamento que facilitam a localização e a recuperação de arquivos perdidos ou danificados. Devido ao seu design modular,
# o BareOS é escalonável para pequenos sistemas de computadores individuais a sistemas que consistem em centenas de 
# computadores localizados em uma grande rede.
#
# Site Oficial do Projeto: https://www.bareos.org/en/
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
# Vídeo de atualização do Sistema: https://www.youtube.com/watch?v=esnu8TAepHU
# Vídeo de configuração da Placa de Rede: https://www.youtube.com/watch?v=zSUd4k108Zk
# Vídeo de configuração do Hostname e Hosts: https://www.youtube.com/watch?v=J7eyb5ynjZA
# Vídeo de instalação do LAMP Server no Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=6EFUu-I3
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
# opção do comando create: create (criação), database (base de dados), base (banco de dados)
# opção do comando create: create (criação), user (usuário), identified by (indentificado por - senha do usuário), password (senha)
# opção do comando grant: grant (permissão), usage (uso em | uso na), *.* (todos os bancos/tabelas), to (para), user (usário)
# identified by (indentificado por - senha do usuário), password (senha)
# opões do comando GRANT: grant (permissão), all (todos privilegios), on (em ou na | banco ou tabela), *.* (todos os bancos/tabelas)
# to (para), user@'%' (usuário @ localhost), identified by (indentificado por - senha do usuário), password (senha)
# opção do comando FLUSH: flush (atualizar), privileges (recarregar as permissões)
USER="root"
PASSWORD="pti@2018"
DATABASE="CREATE DATABASE bareos;"
USERDATABASE="CREATE USER 'bareos'@'localhost' IDENTIFIED BY 'bareos';"
GRANTDATABASE="GRANT USAGE ON *.* TO 'bareos'@'localhost' IDENTIFIED BY 'bareos';"
GRANTALL="GRANT ALL PRIVILEGES ON bareos.* TO 'bareos'@'localhost' IDENTIFIED BY 'bareos' WITH GRANT OPTION;"
FLUSH="FLUSH PRIVILEGES;"
#
# Variáveis de instalação do BareOS
RELEASE="http://download.bareos.org/bareos/release/latest/xUbuntu_18.04/"
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
# Verificando se as dependêncais do BareOS estão instaladas
# opção do dpkg: -s (status), opção do echo: -e (intepretador de escapes de barra invertida), -n (permite nova linha)
# || (operador lógico OU), 2> (redirecionar de saída de erro STDERR), && = operador lógico AND, { } = agrupa comandos em blocos
# [ ] = testa uma expressão, retornando 0 ou 1, -ne = é diferente (NotEqual)
echo -n "Verificando as dependências, aguarde... "
	for name in mysql-server mysql-common
	do
  		[[ $(dpkg -s $name 2> /dev/null) ]] || { echo -en "\n\nO software: $name precisa ser instalado. \nUse o comando 'apt install $name'\n";deps=1; }
	done
		[[ $deps -ne 1 ]] && echo "Dependências.: OK" || { echo -en "\nInstale as dependências acima e execute novamente este script\n";exit 1; }
		sleep 5
#
# Script de instalação do BareOS no GNU/Linux Ubuntu Server 18.04.x
# opção do comando echo: -e (enable interpretation of backslash escapes), \n (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
#
echo -e "Instalação do BareOS no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a instalação do BareOS acessar a URL: http://`hostname -I`/\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet...\n"
sleep 5
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
echo -e "Instalando o BareOS, aguarde...\n"
#
echo -e "Instalando as dependências do BareOS, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)

echo -e "Source List criado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o BareOS e criando a Base de Dados, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)

echo -e "BareOS instalado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do BareOS feita com Sucesso!!!."
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
