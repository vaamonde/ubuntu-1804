#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 09/11/2018
# Data de atualização: 20/01/2019
# Versão: 0.03
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
#
# Vídeo de instalação do LAMP Server no Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=6EFUu-I3u4s
#
# Wordpress: é um sistema livre e aberto de gestão de conteúdo para internet (do inglês: Content Management System - CMS),
# baseado em PHP com banco de dados MySQL, executado em um servidor interpretador, voltado principalmente para a criação de
# páginas eletrônicas (sites) e blogs online. Criado a partir do extinto b2/cafelog, por Ryan Boren e Matthew Mullenweg, e
# distribuído gratuitamente sob a GNU General Public License.
#
# Site oficial: https://wordpress.org/
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
# Declarando as variaveis para o download do Wordpress
WORDPRESS="https://wordpress.org/latest.zip"
#
# Declarando as variaveis para criação da Base de Dados do Wordpress
USER="root"
PASSWORD="pti@2018"
# opção do comando create: create (criação), database (base de dados), base (banco de dados)
DATABASE="CREATE DATABASE wordpress;"
# opção do comando create: create (criação), user (usuário), identified by (indentificado por - senha do usuário), password (senha)
USERDATABASE="CREATE USER 'wordpress' IDENTIFIED BY 'wordpress';"
# opção do comando grant: grant (permissão), usage (uso em | uso na), *.* (todos os bancos/tabelas), to (para), user (usário)
# identified by (indentificado por - senha do usuário), password (senha)
GRANTDATABASE="GRANT USAGE ON *.* TO 'wordpress' IDENTIFIED BY 'wordpress';"
# opões do comando GRANT: grant (permissão), all (todos privilegios), on (em ou na | banco ou tabela), *.* (todos os bancos/tabelas)
# to (para), user@'%' (usuário @ localhost), identified by (indentificado por - senha do usuário), password (senha)
GRANTALL="GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress';"
# opção do comando FLUSH: flush (atualizar), privileges (recarregar as permissões)
FLUSH="FLUSH PRIVILEGES;"
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
# Script de instalação do Wordpress no GNU/Linux Ubuntu Server 18.04.x
# opção do comando echo: -e (enable) habilita interpretador, \n = (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando sleep: 5 (seconds
clear
echo -e "Instalação do Wordpress no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a instalação do Wordpress acessar a URL: http://`hostname -I`/wp/\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet..."
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
echo -e "Instalando as dependências do Wordpress, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando apt: -y (yes)
	apt -y install unzip &>> $LOG
echo -e "Dependências instaladas com sucesso!!!, continuando com o script"
sleep 5
echo
#
echo -e "Removendo os software desnecessários, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando apt: -y (yes)
	apt -y autoremove &>> $LOG
echo -e "Software removidos com Sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o Wordpress, aguarde..."
echo
#
echo -e "Baixando o Wordpress do site oficial, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	wget $WORDPRESS &>> $LOG
echo -e "Wordpress baixado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Descompactando o Wordpress, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	unzip latest.zip &>> $LOG
echo -e "Descompactação feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Copiando os arquivos de configuração do Wordpress, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando mv: -v (verbose)
	# opção do comando cp: -v (verbose)
	mv -v wordpress/ /var/www/html/wp &>> $LOG
	cp -v conf/htaccess /var/www/html/wp/.htaccess &>> $LOG
	cp -v conf/wp-config.php /var/www/html/wp/ &>> $LOG
echo -e "Arquivos copiados com sucesso!!!, continuando com o script..."
sleep 5
echo
#				 
echo -e "Alterando as permissões dos arquivos e diretórios do Wordpress, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando chmod: -R (recursive), -f (silent), -v (verbose), 755 (Dono=RWX,Grupo=R-X,Outros=R-X)
	# opção do comando chown: -R (recursive), -f (silent), -v (verbose), dono.grupo (alteraçaõ do dono e grupo)
	chmod -Rfv 755 /var/www/html/wp/ &>> $LOG
	chown -Rfv www-data.www-data /var/www/html/wp/ &>> $LOG
echo -e "Permissões alteradas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Criando a Base de Dados do Wordpress, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando mysql: -u (user), -p (password) -e (execute)
	mysql -u $USER -p$PASSWORD -e "$DATABASE" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$USERDATABASE" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$GRANTDATABASE" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$GRANTALL" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$FLUSH" mysql &>> $LOG
echo -e "Base de Dados criada com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do Wordpress feita com sucesso!!! Pressione <Enter> para continuar."
read
sleep 3
clear
#
echo -e "Editando o arquivo de configuração da Base de Dados do Wordpress, aguarde..."
	echo -e "Pressione <Enter> para editar o arquivo: wp-config.php"
		# opção do comando sleep: 3 (seconds)
		read
		sleep 3
	vim /var/www/html/wp/wp-config.php
echo -e "Arquivo editado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Editando o arquivo de configuração do htaccess do Wordpress, aguarde..."
	echo -e "Pressione <Enter> para editar o arquivo: .htaccess"
		# opção do comando sleep: 3 (seconds)
		read
		sleep 3
	vim /var/www/html/wp/.htaccess
echo -e "Arquivo editado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do Wordpress feito com Sucesso!!!"
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
