#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 09/08/2020
# Data de atualização: 09/08/2020
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
# Testado e homologado para a versão do NTopNG 4.0.x
#
# NTop-NG é um software para monitorar o tráfego em uma rede de computadores. Ele foi projetado para ser um 
# substituto de alto desempenho e baixo recurso para o NTop. O NTop-NG é um software de código aberto lançado 
# sob a Licença Pública Geral GNU (GPLv3) para software. Versões de código-fonte estão disponíveis para os 
# sistemas operacionais: Unix, Linux, BSD, Mac OS X e Windows. O mecanismo do NTop-NG é escrito na linguagem 
# de programação C ++, sua interface da web é opcional e foi desenvolvida na linguagem Lua.
#
# OBSERVAÇÃO IMPORTANTE: para o NTop-NG funcionar corretamente em um Infraestrutura de Redes de Computadores,
# recomendamos que a Porta de Conexão do Switch que vai conectar o Servidor do NTop-NG seja configurada no
# Modo Mirroring/Monitoring (ou em alguns casos no modo Trunk)
#
# Informações que serão solicitadas na configuração via Web do NTopNG
#
# Site Oficial do Projeto: https://www.ntop.org/
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
# Declarando as variáveis de download do NTopNG (Links atualizados no dia 09/08/2020)
NTOPNG="http://apt-stable.ntop.org/18.04/all/apt-ntop-stable.deb"
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
# Script de instalação do NTopNG no GNU/Linux Ubuntu Server 18.04.x
# opção do comando echo: -e (enable interpretation of backslash escapes), \n (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
# opção do comando cut: -d (delimiter), -f (fields)
echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
clear
#
echo -e "Instalação do NTopNG no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a instalação do NTopNG acesse a URL: http://`hostname -I | cut -d' ' -f1`:3001\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet..."
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
#
echo -e "Instalando o NTopNG, aguarde...\n"
#
echo -e "Fazendo o download do Repositório do NTopNG do site Oficial, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando rm: -v (verbose)
	# opção do comando wget: -O (output document file)
	rm -v ntopng.deb &>> $LOG
	wget $NTOPNG -O ntopng.deb &>> $LOG
echo -e "Download do repositório do NTopNG feito com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o Repositório do NTopNG, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando dpkg: -i (install)
	dpkg -i ntopng.deb &>> $LOG
	apt update &>> $LOG
echo -e "Repositório do NTopNG instalado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando as Dependências do NTopNG, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (yes)
	apt -y install software-properties-common wget &>> $LOG
echo -e "Dependências instaladas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o NTopNG, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (yes)
	apt -y install ntopng ntopng-data &>> $LOG
echo -e "NTopNG instalado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Configurando o NTopNG, pressione <Enter> para continuar."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando cp: -v (verbose)
	read
	sleep 3
	cp -v /etc/ntopong/ntopng.conf /etc/ntopong/ntopng.conf.bkp &>> $LOG
	cp -v conf/ntopng.conf /etc/ntopong/ntopng.conf &>> $LOG
	vim /etc/ntopong/ntopng.conf
echo -e "NTopNG configurado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Configurando a Interface do NTopNG, pressione <Enter> para continuar."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando cp: -v (verbose)
	read
	sleep 3
	cp -v conf/ntopng.start /etc/ntopong/ntopng.start &>> $LOG
	vim /etc/ntopong/ntopng.start
echo -e "Interface do NTopNG configurada com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Iniciando o serviço do NTopNG, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	systemctl enable ntopng &>> $LOG
	systemctl restart ntopng &>> $LOG
echo -e "Serviço do NTopNG iniciado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Verificando a porta de conexão do NTopNG, aguarde..."
	# opção do comando netstat: -a (all), -n (numeric)
	netstat -an | grep 3001
echo -e "Porta de conexão verificada com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do NTopNG feita com Sucesso!!!."
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
