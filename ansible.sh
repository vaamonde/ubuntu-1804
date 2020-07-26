#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 10/02/2019
# Data de atualização: 23/07/2020
# Versão: 0.02
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
# Testado e homologado para a versão do Ansible 2.7.x
#
# O Ansible é uma ferramenta de provisionamento de software de código aberto, gerenciamento de configuração e 
# implementação de aplicativos. Ele é executado em muitos sistemas semelhantes ao Unix/Linux e pode configurar 
# tanto sistemas semelhantes ao Unix/Linux quanto o Microsoft Windows. Inclui sua própria linguagem declarativa 
# para descrever a configuração do sistema. Foi escrito por Michael DeHaan e adquirido pela Red Hat em 2015. Ao 
# contrário dos produtos concorrentes, o Ansible não tem agente ele se conecta remotamente via SSH ou PowerShell 
# para executar suas tarefas.
#
# Site Oficial do Projeto: https://www.ansible.com/
#
# O AWX Project (AWX) é um projeto de código aberto do software Ansible Tower patrocinado pela Red Hat. Ele nos 
# permite controlar melhor o uso do projeto Ansible em ambientes de TI, fornecendo uma interface de usuário baseada 
# na web e um mecanismo de tarefas baseados no Ansible. É uma ferramenta de automatização de tarefas, nos permitindo 
# fazer o deploy de aplicações, provisionar servidores, automatizar tarefas, e outras funções.
#
# Site Oficial do Projeto: https://github.com/ansible/awx
#
# Outros projeto de Front End para o Ansible
# Rundeck: https://www.rundeck.com/
# Polemarch: https://polemarch.org/
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
# Vídeo de atualização do Sistema: https://www.youtube.com/watch?v=esnu8TAepHU
# Vídeo de configuração da Placa de Rede: https://www.youtube.com/watch?v=zSUd4k108Zk
# Vídeo de configuração do Hostname e Hosts: https://www.youtube.com/watch?v=J7eyb5ynjZA
#
# Variável da Data Inicial para calcular o tempo de execução do script (VARIÁVEL MELHORADA)
# opção do comando date: +%T (Time)
HORAINICIAL=`date +%T`
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
USUARIO=`id -u`
UBUNTU=`lsb_release -rs`
KERNEL=`uname -r | cut -d'.' -f1,2`
#
# Variável do caminho do Log dos Script utilizado nesse curso (VARIÁVEL MELHORADA)
# opções do comando cut: -d (delimiter), -f (fields)
# $0 (variável de ambiente do nome do comando)
LOG="/var/log/$(echo $0 | cut -d'/' -f2)"
#
# Declarando a variável de download do Ansible (Link atualizado no dia 22/07/2020)
PPA="ppa:ansible/ansible"
#
# Verificando se o usuário é Root, Distribuição é >=18.04 e o Kernel é >=4.15 <IF MELHORADO)
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
# Script de instalação do Ansible no GNU/Linux Ubuntu Server 18.04.x
# opção do comando echo: -e (enable interpretation of backslash escapes), \n (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
#
echo -e "Instalação do Ansible no GNU/Linux Ubuntu Server 18.04.x\n"
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
echo -e "Instalando o Ansible é o AWX, aguarde...\n"
#
echo -e "Adicionando o repositório do Ansible, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
  	apt-add-repository -y $PPA
  	apt update
echo -e "Repositório do Ansible adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando as dependências do Ansible, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
  	apt -y install software-properties-common python
echo -e "Dependências do Ansible instaladas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o Ansible, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)
  	apt -y install ansible
echo -e "Ansible instalado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o Front End do Ansible, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)
  	apt -y install
echo -e "Front End do Ansible instalado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do Ansible feita com Sucesso!!!."
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
