#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 16/05/2021
# Data de atualização: 16/05/2021
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
# Testado e homologado para a versão do Bind9 v9.11.x e do ISC DHCP Server
#
# O Bind DNS Server BIND (Berkeley Internet Name Domain ou, como chamado previamente, Berkeley Internet 
# Name Daemon) é o servidor para o protocolo DNS mais utilizado na Internet, especialmente em sistemas 
# do tipo Unix, onde ele pode ser considerado um padrão de facto. Foi criado por quatro estudantes de 
# graduação, membros de um grupo de pesquisas em ciência da computação da Universidade de Berkeley, e 
# foi distribuído pela primeira vez com o sistema operacional 4.3 BSD. Atualmente o BIND é suportado e 
# mantido pelo Internet Systems Consortium.
#
# O ISC DHCP Server dhcpd (uma abreviação de "daemon DHCP") é um programa de servidor DHCP que opera
# como um daemon em um servidor para fornecer serviço de protocolo de configuração dinâmica de hosts 
# (DHCP) a uma rede. Essa implementação, também conhecida como ISC DHCP, é uma das primeiras e mais 
# conhecidas, mas agora existem várias outras implementações de software de servidor DHCP disponíveis.
#
# Site Oficial do Projeto Bind9: https://www.isc.org/bind/
# Site Oficial do Projeto ICS DHCP: https://www.isc.org/dhcp/
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
# Vídeo de configuração do OpenSSH no GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=ecuol8Uf1EE&t
#
# Variável da Data Inicial para calcular o tempo de execução do script (VARIÁVEL MELHORADA)
# opção do comando date: +%T (Time)
HORAINICIAL=$(date +%T)
#
# Variáveis para validar o ambiente, verificando se o usuário é "root", versão do ubuntu e kernel
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
# Script de instalação do Bind9 DNS Server integrado com o ICS DHCP Server no GNU/Linux Ubuntu Server 18.04.x
# opção do comando echo: -e (enable interpretation of backslash escapes), \n (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
# opção do comando cut: -d (delimiter), -f (fields)
echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
clear
#
echo
echo -e "Instalação do Bind9 integrado com o ICS DHCP no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet...\n"
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
echo -e "Instalando o Bind9 DNS Server e ISC DHCP Server, aguarde...\n"
sleep 5
#
echo -e "Instalando o Bind9 e ISC DHCP, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)
	# opção do comando apt: -y (yes)
	apt -y bind9 bind9utils dnsutils net-tools isc-dhcp-server &>> $LOG
echo -e "Bind9 e ISC DHCP instalado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Editando o arquivo hostname, pressione <Enter> para continuar."
	read
	vim /etc/hostname
echo -e "Arquivo editado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Editando o arquivo hosts, pressione <Enter> para continuar."
	read
	vim /etc/hosts
echo -e "Arquivo editado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Editando o arquivo 50-cloud-init.yaml, pressione <Enter> para continuar."
	# opção do comando: &>> (redirecionar a saida padrão)
	read
	vim /etc/netplan/50-cloud-init.yaml
echo -e "Arquivo editado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Atualizando o arquivo de configuração do ISC DHCP Server, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)
	# opção do comando mv: -v (verbose)
	# opção do comando cp: -v (verbose)
	mv -v /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bkp &>> $LOG
	cp -v conf/dhcpd.conf /etc/dhcp/dhcpd.conf &>> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Atualizando os arquivos de configuração do Bind9 DNS Server, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)
	# opção do comando mv: -v (verbose)
	# opção do comando cp: -v (verbose)
	mv -v /etc/bind/named.conf /etc/bind/named.conf.bkp &>> $LOG
	mv -v /etc/bind/named.conf.options /etc/bind/named.conf.options.bkp &>> $LOG
	mv -v /etc/bind/named.conf.local /etc/bind/named.conf.local.bkp &>> $LOG
	cp -v conf/named.conf /etc/bind/named.conf &>> $LOG
	cp -v conf/named.conf.options /etc/bind/named.conf.options &>> $LOG
	cp -v conf/named.conf.local /etc/bind/named.conf.local &>> $LOG
	cp -v conf/pti.intra.zone /var/lib/bind/pti.intra.zone &>> $LOG
	cp -v conf/pti.intra.rev.zone /var/lib/bind/pti.intra.rev.zone &>> $LOG
echo -e "Arquivos atualizados com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Atualizando a Chave do Bind9 DNS Server no ISC DHCP Server, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)
	# opção do comando cp: -v (verbose)
	# opção do comando chown: -v (verbose), root (user), root (group)
	# opção do comando chmod: -v (verbose), 640 (User=RW-, Group=R--, Other=---)
	cp -v /etc/bind/rndc.key /etc/dhcp/ddns-keys/ &>> $LOG
	chown -v root:root /etc/dhcp/ddns-keys/rndc.key &>> $LOG
	chmod -v 640 /etc/dhcp/ddns-keys/rndc.key &>> $LOG
echo -e "Atualização da chave feita com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Editando o arquivo named.conf, pressione <Enter> para continuar."
	# opção do comando: &>> (redirecionar a saida padrão)
	read
	vim /etc/bind/named.conf
echo -e "Arquivo editado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Editando o arquivo named.conf.options, pressione <Enter> para continuar."
	# opção do comando: &>> (redirecionar a saida padrão)
	read
	vim /etc/bind/named.conf.options
echo -e "Arquivo editado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Editando o arquivo named.conf.local, pressione <Enter> para continuar."
	# opção do comando: &>> (redirecionar a saida padrão)
	read
	vim /etc/bind/named.conf.local
echo -e "Arquivo editado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Editando o arquivo pti.intra.zone, pressione <Enter> para continuar."
	# opção do comando: &>> (redirecionar a saida padrão)
	read
	vim /var/lib/bind/pti.intra.zone
echo -e "Arquivo editado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Editando o arquivo pti.intra.rev.zone, pressione <Enter> para continuar."
	# opção do comando: &>> (redirecionar a saida padrão)
	read
	vim /var/lib/bind/pti.intra.rev.zone
echo -e "Arquivo editado com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Inicializando os serviços do Bind9 DNS Server, ISC DHCP Server e Netplan, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)
	netplan --debug apply &>> $LOG
	systemctl start isc-dhcp-server &>> $LOG
	systemctl start bind9 &>> $LOG
echo -e "Serviços inicializados com com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Verificando as portas de Conexões do Bind9 DNS Server e do ISC DHCP Server, aguarde..."
	# opção do comando netstat: -a (all), -n (numeric)
	netstat -an | grep '53\|67'
echo -e "Portas de conexões verificadas com sucesso!!!, continuando com o script...\n"
sleep 5
#
echo -e "Instalação do Bind9 DNS Server integrado com o ICS DHCP Server feita com Sucesso!!!."
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
