#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 25/05/2021
# Data de atualização: 26/05/2021
# Versão: 0.02
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
# Testado e homologado para a versão do OpenSSL
#
# OpenSSL é uma implementação de código aberto dos protocolos SSL e TLS. A biblioteca (escrita na 
# linguagem C) implementa as funções básicas de criptografia e disponibiliza várias funções utilitárias.
# Também estão disponíveis wrappers que permitem o uso desta biblioteca em várias outras linguagens. 
#
# O OpenSSL está disponível para a maioria dos sistemas do tipo Unix, incluindo Linux, Mac OS X, as 
# quatro versões do BSD de código aberto e também para o Microsoft Windows. O OpenSSL é baseado no 
# SSLeay de Eric Young e Tim Hudson. O OpenSSL é utilizado para gerar certificados de autenticação 
# de serviços/protocolos em servidores (servers).
#
# O Transport Layer Security (TLS), assim como o seu antecessor Secure Sockets Layer (SSL), é um 
# protocolo de segurança projetado para fornecer segurança nas comunicações sobre uma rede de 
# computadores. Várias versões do protocolo encontram amplo uso em aplicativos como navegação na web, 
# email, mensagens instantâneas e voz sobre IP (VoIP). Os sites podem usar o TLS para proteger todas 
# as comunicações entre seus servidores e navegadores web.
#
# Site Oficial do Projeto: https://www.openssl.org/
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
# Vídeo de configuração do OpenSSH no GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=ecuol8Uf1EE&t
# Vídeo de instalação do LAMP Server no Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=6EFUu-I3
# Vídeo de instalação do Bind9 DNS e ISC DHCP Server no Ubuntu Server 18.04.x LTS: 
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
# Declarando a variável de Senha (passphrase) utilizada na geração da chave privada do OpenSSL
PASSPHRASE="vaamonde"
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
# Verificando se as dependências do OpenSSL estão instaladas
# opção do dpkg: -s (status), opção do echo: -e (interpretador de escapes de barra invertida), -n (permite nova linha)
# || (operador lógico OU), 2> (redirecionar de saída de erro STDERR), && = operador lógico AND, { } = agrupa comandos em blocos
# [ ] = testa uma expressão, retornando 0 ou 1, -ne = é diferente (NotEqual)
echo -n "Verificando as dependências do OpenSSL, aguarde... "
	for name in openssl apache2 bind9
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
# Script de configuração do OpenSSL no GNU/Linux Ubuntu Server 18.04.x
# opção do comando echo: -e (enable interpretation of backslash escapes), \n (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
clear
#
echo
echo -e "Configuração do OpenSSL no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a configuração do TLS/SSL no Apache2 acessar a URL: https://`hostname -I | cut -d' ' -f1`/"
echo -e "Confirmar o acesso com o Nome FQDN na URL: https://`hostname -A | cut -d' ' -f1`/"
echo -e "Confirmar o acesso com o Nome Domínio na URL: https://`hostname -d | cut -d' ' -f1`/\n"
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
echo -e "Configuração do OpenSSL e TLS/SSL no Apache2, aguarde...\n"
#
echo -e "Atualizando o arquivo de configuração do OpenSSL, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando cp: -v (verbose)
	cp -v conf/pti-ssl.conf /etc/ssl/pti-ssl.conf &>> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Editando o arquivo configuração do OpenSSL, pressione <Enter> para continuar."
	# opção do comando: &>> (redirecionar a saída padrão)
	read
	vim /etc/ssl/pti-ssl.conf
echo -e "Arquivo editado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Criando o Chave Privada Criptografada de 4096 bits, senha padrão: $PASSPHRASE, aguarde..." 
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando rm: -v (verbose)
	# opção do comando openssl: genrsa (Generation of RSA Private Key),
	#							-des3 ()
	#							-out (output file), -passout (accept password arguments output), 
	#							pass: (The actual password is password), 
	#							4096 (size key bit: 1024, 2048, 3072 or 4096)
	rm -v pti-intra.* &>> $LOG
	openssl genrsa -des3 -out pti-intra.key -passout pass:$PASSPHRASE 4096 &>> $LOG
echo -e "Chave privada criptografada criada com sucesso!!!, continuando com o script...\n"
sleep 2
#
echo -e "Verificando o arquivo de chave privada criptografada criada, senha padrão: $PASSPHRASE, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando openssl: rsa (), 
	#							-noout (omits the output of the encoded version), 
	#							-modulus (), 
	#							-in (input file KEY), 
	#							md5 ()
	openssl rsa -noout -modulus -in pti-intra.key | openssl md5
echo -e "Arquivo de chave privada verificado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Criando o CA (Certified Authority - Root Certificate) e o arquivo PEM (PEM Privacy Enhanced Mail), senha padrão: $PASSPHRASE, aguarde..."
	# opção do comando openssl: req (PKCS#10 X.509 Certificate Signing Request (CSR) Management), 
	#							-x509 (X.509 Certificate Data Management), 
	#							-new (new PEM), 
	#							-key (input file RSA), 
	#							-sha256 (), 
	#							-days (validate certificated), 
	#							-out (output file PEM), 
	#							-config (external configuration file)
	# Criando o arquivo PEM, mensagens que serão solicitadas na criação da CA
	# 	Country Name (2 letter code): BR <-- pressione <Enter>
	# 	State or Province Name (full name): Brasil <-- pressione <Enter>
	# 	Locality Name (eg, city): Sao Paulo <-- pressione <Enter>
	# 	Organization Name (eg, company): Bora para Pratica <-- pressione <Enter>
	# 	Organization Unit Name (eg, section): Procedimentos em TI <-- pressione <Enter>
	# 	Common Name (eg, server FQDN or YOUR name): ptispo01ws01.pti.intra <-- pressione <Enter>
	# 	Email Address: pti@pti.intra <-- pressione <Enter>
	openssl req -x509 -new -nodes -key pti-intra.key -sha256 -days 3650 -out pti-intra.pem -config /etc/ssl/pti-ssl.conf
echo -e "Criação do CA feito sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Criando o arquivo CSR (Certificate Signing Request), com nome FQDN: `hostname`, senha padrão: $PASSPHRASE, aguarde..."
	# opção do comando openssl: req (PKCS#10 X.509 Certificate Signing Request (CSR) Management), 
	#							-new (new CSR),
	#							-sha256 ()
	#							-nodes ()
	# 							-key (input file RSA), 
	#							-out (output file CSR), 
	#							-config (external configuration file)
	# Criando o arquivo CSR, mensagens que serão solicitadas na criação do CSR
	# 	Country Name (2 letter code): BR <-- pressione <Enter>
	# 	State or Province Name (full name): Brasil <-- pressione <Enter>
	# 	Locality Name (eg, city): Sao Paulo <-- pressione <Enter>
	# 	Organization Name (eg, company): Bora para Pratica <-- pressione <Enter>
	# 	Organization Unit Name (eg, section): Procedimentos em TI <-- pressione <Enter>
	# 	Common Name (eg, server FQDN or YOUR name): ptispo01ws01.pti.intra <-- pressione <Enter>
	# 	Email Address: pti@pti.intra <-- pressione <Enter>
	openssl req -new -sha256 -nodes -key pti-intra.key -out pti-intra.csr -config /etc/ssl/pti-ssl.conf
echo -e "Criação do CSR feito com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Verificando o arquivo CSR (Certificate Signing Request) criado, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando openssl: req (PKCS#10 X.509 Certificate Signing Request (CSR) Management), 
	#							-text (Print the in text), 
	# 							-noout (omits the output of the encoded version), 
	#							-in (input file CSR)
	openssl req -text -noout -in pti-intra.csr &>> $LOG
echo -e "Arquivo CSR verificado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Criando o certificado assinado CRT (Certificate Request Trust), com nome FQDN: `hostname`, senha padrão: $PASSPHRASE, aguarde..."
	# opção do comando openssl: x509 (X.509 Certificate Data Management),  
	#							-req (PKCS#10 X.509 Certificate Signing Request (CSR) Management),
	#							-days (validate certificate file),
	#							-sha256 ()
	#							-in (input file CSR),
	#							-CA (input file PEM),
	#							-CAkey (input file KEY),
	#							-CAcreateserial (), 
	#							-out (output file CRT)
	#							-extfile (external configuration file)
	#							-extensions ()
	openssl x509 -req -days 3650 -sha256 -in pti-intra.csr -CA pti-intra.pem -CAkey pti-intra.key -CAcreateserial \
	-out pti-intra.crt -extfile /etc/ssl/pti-ssl.conf -extensions v3_ca
echo -e "Criação do certificado assinado feito com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Verificando o arquivo CRT (Certificate Request Trust) criado, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando openssl: x509 (X.509 Certificate Data Management), 
	#							-noout (omits the output of the encoded version), 
	#							-modulus (), 
	#							-in (input file CRT), 
	#							md5 ()
	openssl x509 -noout -modulus -in pti-intra.crt | openssl md5 &>> $LOG
echo -e "Arquivo CRT verificado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Atualizando os Diretórios do OpenSSL com o novo certificado criado, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando cp: -v (verbose)
	cp -v pti-intra.crt /etc/ssl/certs/ &>> $LOG
	cp -v pti-intra.key /etc/ssl/private/ &>> $LOG
echo -e "Arquivos atualizados com sucesso!!!, continuando com o script...\n"
sleep 2
#
echo -e "Atualizando o arquivo de configuração do Apache2 HTTPS, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando mv: -v (verbose)
	# opção do comando cp: -v (verbose)
	mv -v /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bkp &>> $LOG
	cp -v conf/default-ssl.conf /etc/apache2/sites-available/ &>> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Editando o arquivo de configuração do Apache2 HTTPS, pressione <Enter> para continuar"
	read
	vim /etc/apache2/sites-available/default-ssl.conf
echo -e "Arquivo editado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Criando o diretório de Download para baixar a Unidade Certificadora, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando mkdir: -v (verbose)
	# opção do comando chown: -v (verbose), www-data (user), www-data (group)
	# opção do comando cp: -v (verbose)
	mkdir -v /var/www/html/download/ &>> $LOG
	chown -v www-data:www-data /var/www/html/download/ &>> $LOG
	cp -v pti-intra.crt /var/www/html/download/ &>> $LOG
	cp -v pti-intra.pem /var/www/html/download/ &>> $LOG
echo -e "Diretório criado com sucesso!!!, continuando com o script...\n"
sleep 2
#
echo -e "Habilitando o suporte ao SSL e o Site HTTPS do Apache2, pressione <Enter> para continuar"
	# opção do comando: &>> (redirecionar a saída padrão)
	a2enmod ssl &>> $LOG
	a2enmod headers &>> $LOG
	a2ensite default-ssl &>> $LOG
	apache2ctl configtest &>> $LOG
echo -e "Site HTTPS do Apache2 habilitado com sucesso!!!, continuando com o script...\n"
sleep 2
#
echo -e "Reinicializando o serviço do Apache2, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	systemctl restart apache2 &>> $LOG
echo -e "Serviço reinicializado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Verificando as portas de conexões do Apache2, aguarde..."
	# opção do comando netstat: a (all), n (numeric)
	# opção do comando grep: -i (ignore case)
	netstat -an | grep ':80\|:443'
echo -e "Portas verificadas com sucesso!!!, continuando com o script...\n"
sleep 5
#	
echo -e "Configuração do OpenSSL e TLS/SSL do Apache2 feita com Sucesso!!!."
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
