#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 10/11/2018
# Data de atualização: 20/01/2019
# Versão: 0.02
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
#
# Vídeo de instalação do LAMP Server no Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=6EFUu-I3u4s
#
# Vídeo de instalação do Wordpress no LAMP do Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=Fs2B7kLdlm4
#
# Webmin é um programa de gerenciamento de servidor, que roda em plataformas Unix/Linux. Com ele você pode usar também o 
# Usermin e o Virtualmin. O Webmin funciona como um centralizador de configurações do sistema, monitoração dos serviços e de
# servidores, fornecendo uma interface amigável, e que quando configurado com um servidor web, pode ser acessado de qualquer
# local, através de um navegador: https:\\(ip do servidor):(porta de utilização). Exemplo: https:\\172.16.1.20:10000
#
# Variável da Data Inicial para calcular o tempo de execução do script
# opção do comando date: +%s (seconds since)
DATAINICIAL=`date +%s`
#
# Variáveis para validar o ambiente, verificando se o usuário e "root", versão do ubuntu e kernel
# opções do comando id: -u (user), opções do comando: lsb_release: -r (release), -s (short), 
# opções do comando uname: -r (kernel release), opções do comando cut: -d (delimiter), -f (fields)
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
# opção do caracter: | (piper) Conecta a saída padrão com a entrada padrão de outro comando
# opção do shell script: acento crase ` ` = Executa comandos numa subshell, retornando o resultado
# opção do shell script: aspas simples ' ' = Protege uma string completamente (nenhum caractere é especial)
# opções do comando cut: -d (delimiter), -f (fields)
LOGSCRIPT=`echo $0 | cut -d'/' -f2`
#
# Variável do caminho para armazenar os Log's de instalação
LOG=$VARLOGPATH/$LOGSCRIPT
#
# Variável do download do Webmin - (Link de download atualizado em: 20/01/2019)
WEBMIN="https://prdownloads.sourceforge.net/webadmin/webmin_1.900_all.deb"
#
# Verificando se o usuário e Root
# == comparação de string, exit 1 = A maioria dos erros comuns na execução
if [ "$USUARIO" == "0" ]
	then
		echo -e "O usuário e Root, continuando com o script..."
	else
		echo -e "Usuário não e Root, execute o comando: sudo -i, execute novamente o script."
		exit 1
fi
#
# Verificando se a distribuição e 18.04.x
# == comparação de string, exit 1 = A maioria dos erros comuns na execução
if [ "$UBUNTU" == "18.04" ]
	then
		echo -e "Distribuição e 18.04.x, continuando com o script..."
	else
		echo -e "Distribuição não homologada, instale a versão 18.04.x e execute novamente o script."
		exit 1
fi
#		
# Verificando se o Kernel e 4.15
# == comparação de string, exit 1 = A maioria dos erros comuns na execução
# opção do comando sleep: 5 (seconds)
if [ "$KERNEL" == "4.15" ]
	then
		echo -e "Kernel e >= 4.15, continuando com o script..."
		sleep 5
	else
		echo -e "Kernel não homologado, instale a versão do Ubuntu 18.04.x e atualize o sistema."
		exit 1
fi
#
# Script de instalação do Webmin no GNU/Linux Ubuntu Server 18.04.x
# opção do comando echo: -e (enable) habilita interpretador, \n = (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando sleep: 5 (seconds
clear
echo -e "Instalação do Webmin no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a instalação do Webmin acessar a URL: https://`hostname -I`:10000/\n"
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
echo -e "Atualizando as listas do Apt, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
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
echo -e "Instalando o Webmin, aguarde..."
echo
#
echo -e "Instalando as dependências do Webmin, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando apt: -y (yes)
	apt -y install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python &>> $LOG
echo -e "Instalação das dependências feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Fazendo o download do Webmin, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	wget $WEBMIN &>> $LOG
echo -e "Download do Webmin feito com sucesso!!!, continuando com o script..."
sleep 5
echo
#				 
echo -e "Instalando o Webmin, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando dpkg: -i (install)
	WEBMINVERSION=`echo webmin*`
	dpkg -i $WEBMINVERSION &>> $LOG
echo -e "Instalação do Webmin feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Verificando a porta de conexão do Webmin, aguarde..."
	# opção do comando netstat: -a (all), -n (numeric)
	netstat -an | grep 10000
echo -e "Porta de conexão verificada com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do Webmin feito com Sucesso!!!"
	# opção do comando date: +%s (seconds since)
	# opção do caracter ` ` (crase): executa o comando em um subshell 
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
