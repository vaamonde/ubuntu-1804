#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 25/05/2021
# Data de atualização: 02/06/2021
# Versão: 0.04
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
# Testado e homologado para a versão do OpenSSL 1.1.x
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

#Encodings (also used as extensions)
#    .DER = The DER extension is used for binary DER encoded certificates. These files may also bear the 
#	  CER or the CRT extension.   Proper English usage would be “I have a DER encoded certificate” not “I 
#	  have a DER certificate”.
#    .PEM = The PEM extension is used for different types of X.509v3 files which contain ASCII (Base64) 
#	  armored data prefixed with a “—– BEGIN …” line.

#Common Extensions
#    .CRT = The CRT extension is used for certificates. The certificates may be encoded as binary DER or 
#	 as ASCII PEM. The CER and CRT extensions are nearly synonymous.  Most common among *nix systems
#    .CER = alternate form of .crt (Microsoft Convention) You can use MS to convert .crt to .cer (.both 
#	 DER encoded .cer, or base64[PEM] encoded .cer)  The .cer file extension is also recognized by IE as 
#	 a command to run a MS cryptoAPI command (specifically rundll32.exe cryptext.dll,CryptExtOpenCER) which
#	 displays a dialogue for importing and/or viewing certificate contents.
#    .KEY = The KEY extension is used both for public and private PKCS#8 keys. The keys may be encoded as
#	 binary DER or as ASCII PEM.

#The only time CRT and CER can safely be interchanged is when the encoding type can be identical.  (
#ie  PEM encoded CRT = PEM encoded CER)

#
# Site Oficial do Projeto: https://www.openssl.org/
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
# Vídeo de configuração do OpenSSH no GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=ecuol8Uf1EE&t
# Vídeo de instalação do LAMP Server no Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=6EFUu-I3
# Vídeo de instalação do Bind9 DNS e ISC DHCP Server no Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=NvD9Vchsvbk
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
# Declarando as variáveis utilizadas na geração da chave privada e certificados do OpenSSL
PASSPHRASE="vaamonde"
BITS="4096" #opções: 1024, 2048, 3072 ou 4096)
CRIPTO="sha256" #opções: sha224, sha256, sha384 ou sha512)
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
	for name in openssl libssl1.0.0 libssl1.1 apache2 bind9
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
# opção do comando hostname: -I (all IP address), -A (all FQDN name), -d (domain)
# opções do comando cut: -d (delimiter), -f (fields)
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
clear
#
echo
echo -e "Configuração do OpenSSL no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a configuração do TLS/SSL no Apache2 acessar a URL: https://`hostname -I | cut -d' ' -f1`/"
echo -e "Confirmar o acesso com o Nome FQDN na URL: https://`hostname -A | cut -d' ' -f1`/"
echo -e "Confirmar o acesso com o Nome Domínio na URL: https://`hostname -d | cut -d' ' -f1`/"
echo -e "Confirmar o acesso com o Nome CNAME na URL: https://www.`hostname -d | cut -d' ' -f1`/\n"
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
echo -e "Criando a estrutura de diretórios do CA e dos Certificados, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando mkdir: -v (verbose), {} (agrupa comandos em blocos)
	mkdir -v /etc/ssl/{newcerts,certs,crl,private,requests} &>> $LOG
echo -e "Estrutura de diretórios criada com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Atualizando os arquivos de configuração da CA e dos Certificados, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão adicionando)
	# opção do comando touch: {} (agrupa comandos em blocos)
	# opção do comando cp: -v (verbose)
	touch /etc/ssl/{index.txt,index.txt.attr} &>> $LOG
	echo "1234" > /etc/ssl/serial
	cp -v conf/pti-ca.conf /etc/ssl/pti-ca.conf &>> $LOG
	cp -v conf/pti-ssl.conf /etc/ssl/pti-ssl.conf &>> $LOG
echo -e "Arquivos atualizados com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Primeira Etapa: Criando a CA (Certificate Authority) Interna, aguarde...\n"
sleep 5
#
echo -e "Criando o Chave Privada Criptografada de $BITS bits da CA, senha padrão: $PASSPHRASE, aguarde..." 
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando rm: -v (verbose)
	# opção do comando openssl: genrsa (Generation of RSA Private Key),
	#							-aes256 ()
	#							-out (output file), 
	#							-passout (accept password arguments output), 
	#							pass: (The actual password is password), 
	#							4096 (size key bit: 1024, 2048, 3072 or 4096)
	openssl genrsa -aes256 -out /etc/ssl/private/ca-ptikey.key -passout pass:$PASSPHRASE $BITS &>> $LOG
echo -e "Chave privada criptografada da CA criada com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Removendo a senha da chave privada criptografada da CA, senha padrão: $PASSPHRASE, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando mv: -v (verbose)
	# opção do comando openssl: rsa (RSA Private Key),
	#							-in (input file KEY),
	#							-out (output file KEY),
	#							-passin (accept password arguments input),
	#							pass: (The actual password is password)
	# opção do comando rm: -v (verbose)
	mv -v /etc/ssl/private/ca-ptikey.key /etc/ssl/private/ca-ptikey.key.old &>> $LOG
	openssl rsa -in /etc/ssl/private/ca-ptikey.key.old -out /etc/ssl/private/ca-ptikey.key -passin pass:$PASSPHRASE &>> $LOG
	rm -v /etc/ssl/private/ca-ptikey.key.old &>> $LOG
echo -e "Senha da chave privada criptografada da CA removida com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Verificando o arquivo de chave privada criptografada da CA, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando openssl: rsa (RSA Private Key), 
	#							-noout (omits the output of the encoded version), 
	#							-modulus (internal data called a modulus), 
	#							-in (input file KEY), 
	#							md5 (MD5 checksums)
	openssl rsa -noout -modulus -in /etc/ssl/private/ca-ptikey.key | openssl md5 &>> $LOG
echo -e "Arquivo de chave privada da CA verificada com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Editando o arquivo configuração da CA, pressione <Enter> para continuar."
	# opção do comando: &>> (redirecionar a saída padrão)
	read
	vim /etc/ssl/pti-ca.conf
echo -e "Arquivo editado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Criando a CA Interna, confirme as mensagens do arquivo: pti-ca.conf, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando openssl: req (PKCS#10 X.509 Certificate Signing Request (CSR) Management),
	#							-new (new PEM),
	#							-x509 (X.509 Certificate Data Management),
	#							-key (input file KEY RSA),
	#							-out (output file PEM),
	#							-days (),
	#							-set_serial (),
	#							-extensions (),
	#							-config ().
	# Criando o arquivo PEM, mensagens que serão solicitadas na criação da CA
	# 	Country Name (2 letter code): BR <-- pressione <Enter>
	# 	State or Province Name (full name): Brasil <-- pressione <Enter>
	# 	Locality Name (eg, city): Sao Paulo <-- pressione <Enter>
	# 	Organization Name (eg, company): Bora para Pratica <-- pressione <Enter>
	# 	Organization Unit Name (eg, section): Procedimentos em TI <-- pressione <Enter>
	# 	Common Name (eg, server FQDN or YOUR name): pti.intra <-- pressione <Enter>
	# 	Email Address: pti@pti.intra <-- pressione <Enter>
	openssl req -new -x509 -$CRIPTO -key /etc/ssl/private/ca-ptikey.key -out /etc/ssl/certs/ca-pticert.pem \
	-days 3650 -set_serial 0 -extensions v3_ca -config /etc/ssl/pti-ca.conf
echo -e "CA criada com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Verificando o arquivo PEM (Privacy Enhanced Mail) da CA, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando openssl: x509 (X.509 Certificate Data Management), 
	#							-noout (omits the output of the encoded version), 
	#							-modulus (internal data called a modulus),
	#							-text (Print the in text), 
	#							-in (input file PEM), 
	#							md5 (MD5 checksums)
	openssl x509 -noout -modulus -in /etc/ssl/certs/ca-pticert.pem | openssl md5 &>> $LOG
	openssl x509 -noout -text -in /etc/ssl/certs/ca-pticert.pem &>> $LOG
echo -e "Arquivo PEM da CA verificado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Segunda Etapa: Criando o Certificado de Servidor Assinado do Apache2, aguarde...\n"
sleep 5
#
echo -e "Criando o Chave Privada Criptografada de $BITS do Apache2, senha padrão: $PASSPHRASE, aguarde..." 
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando openssl: genrsa (Generation of RSA Private Key),
	#							-aes256 (),
	#							-out (output file), 
	#							-passout (accept password arguments output), 
	#							pass: (The actual password is password), 
	#							4096 (size key bit: 1024, 2048, 3072 or 4096)
	openssl genrsa -aes256 -out /etc/ssl/private/apache2-ptikey.key -passout pass:$PASSPHRASE $BITS &>> $LOG
echo -e "Chave privada criptografada do Apache2 criada com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Removendo a senha da chave privada criptografada do Apache2, senha padrão: $PASSPHRASE, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando mv: -v (verbose)
	# opção do comando openssl: rsa (RSA Private Key),
	#							-in (input file KEY),
	#							-out (output file KEY),
	#							-passin (accept password arguments input),
	#							pass: (The actual password is password)
	# opção do comando rm: -v (verbose)
	mv -v /etc/ssl/private/apache2-ptikey.key /etc/ssl/private/apache2-ptikey.key.old &>> $LOG
	openssl rsa -in /etc/ssl/private/apache2-ptikey.key.old -out /etc/ssl/private/apache2-ptikey.key \
	-passin pass:$PASSPHRASE &>> $LOG
	rm -v /etc/ssl/private/apache2-ptikey.key.old &>> $LOG
echo -e "Senha da chave privada criptografada do Apache2 removida com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Verificando o arquivo de chave privada criptografada do Apache2, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando openssl: rsa (RSA Private Key), 
	#							-noout (omits the output of the encoded version), 
	#							-modulus (internal data called a modulus), 
	#							-in (input file KEY), 
	#							md5 (MD5 checksums)
	openssl rsa -noout -modulus -in /etc/ssl/private/apache2-ptikey.key | openssl md5 &>> $LOG
echo -e "Arquivo de chave privada do Apache2 verificado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Editando o arquivo configuração do Certificado do Apache2, pressione <Enter> para continuar."
	# opção do comando: &>> (redirecionar a saída padrão)
	read
	vim /etc/ssl/pti-ssl.conf
echo -e "Arquivo editado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Criando o arquivo CSR (Certificate Signing Request), confirme as mensagens do arquivo: pti-ssl.conf, aguarde..."
	# opção do comando openssl: req (PKCS#10 X.509 Certificate Signing Request (CSR) Management), 
	#							-new (new CSR),
	#							-sha256 ()
	#							-nodes (),
	# 							-key (input file RSA), 
	#							-out (output file CSR),
	#							-extensions (), 
	#							-config (external configuration file)
	# Criando o arquivo CSR, mensagens que serão solicitadas na criação do CSR
	# 	Country Name (2 letter code): BR <-- pressione <Enter>
	# 	State or Province Name (full name): Brasil <-- pressione <Enter>
	# 	Locality Name (eg, city): Sao Paulo <-- pressione <Enter>
	# 	Organization Name (eg, company): Bora para Pratica <-- pressione <Enter>
	# 	Organization Unit Name (eg, section): Procedimentos em TI <-- pressione <Enter>
	# 	Common Name (eg, server FQDN or YOUR name): pti.intra <-- pressione <Enter>
	# 	Email Address: pti@pti.intra <-- pressione <Enter>
	openssl req -new -$CRIPTO -nodes -key /etc/ssl/private/apache2-ptikey.key -out \
	/etc/ssl/requests/apache2-pticsr.csr -extensions v3_req -config /etc/ssl/pti-ssl.conf
echo -e "Criação do CSR feito com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Verificando o arquivo CSR (Certificate Signing Request) do Apache2, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando openssl: req (PKCS#10 X.509 Certificate Signing Request (CSR) Management), 
	#							-text (Print the in text), 
	# 							-noout (omits the output of the encoded version), 
	#							-in (input file CSR)
	openssl req -text -noout -in /etc/ssl/requests/apache2-pticert.csr &>> $LOG
echo -e "Arquivo CSR verificado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Criando o certificado assinado CRT (Certificate Request Trust), do Apache2, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão
	# opção do comando openssl: x509 (X.509 Certificate Data Management),  
	#							-req (PKCS#10 X.509 Certificate Signing Request (CSR) Management),
	#							-days (validate certificate file),
	#							-sha256 (),							
	#							-in (input file CSR),
	#							-CA (file ca),
	#							-CAkey (private share key CA),
	#							-CAcreatesrial (),
	#							-out (output file CRT)
	#							-extensions (),
	#							-extfile ().
	openssl x509 -req -days 3650 -$CRIPTO -in /etc/ssl/requests/apache2-pticsr.csr -CA \
	/etc/ssl/certs/ca-pticert.pem -CAkey /etc/ssl/private/ca-ptikey.key -CAcreateserial \
	-out /etc/ssl/certs/apache2-pticrt.crt -extensions v3_req -extfile /etc/ssl/pti-ssl.conf
echo -e "Criação do certificado assinado do Apache2 feito com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Verificando o arquivo CRT (Certificate Request Trust) do Apache2, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando openssl: x509 (X.509 Certificate Data Management), 
	#							-noout (omits the output of the encoded version),
	#							-text (), 
	#							-modulus (internal data called a modulus), 
	#							-in (input file CRT), 
	#							md5 (MD5 checksums)
	openssl x509 -noout -modulus -in /etc/ssl/certs/apache2-pticrt.crt | openssl md5 &>> $LOG
	openssl x509 -text -noout -in /etc/ssl/certs/apache2-pticrt.crt &>> $LOG
echo -e "Arquivo CRT do Apache2 verificado com sucesso!!!, continuando com o script...\n"
sleep 5
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
	cp -v /etc/ssl/certs/apache2-pticert.crt /var/www/html/download/ &>> $LOG
echo -e "Diretório criado com sucesso!!!, continuando com o script...\n"
sleep 2
#
echo -e "Habilitando o suporte ao SSL e o Site HTTPS do Apache2, aguarde..."
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
