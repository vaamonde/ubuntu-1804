#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 12/11/2018
# Data de atualização: 12/11/2018
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
#
# O Docker é uma tecnologia de software que fornece contêineres, promovido pela empresa Docker, Inc. O Docker fornece uma 
# camada adicional de abstração e automação de virtualização de nível de sistema operacional no Windows e no Linux. O Docker
# usa as características de isolação de recurso do núcleo do Linux como cgroups e espaços de nomes do núcleo, e um sistema de
# arquivos com recursos de união, como OverlayFS e outros para permitir "contêineres" independentes para executar dentro de 
# uma única instância Linux, evitando a sobrecarga de iniciar e manter máquinas virtuais (VMs).
#
# Site oficial: https://www.docker.com/docker-community
#
# O Portainer.io uma solução de gerenciamento para o Docker, com ele é possível gerenciar facilmente os seus hosts Docker e 
# clusters com Docker Swarm através de uma interface web limpa, simples e intuitiva.
#
# Site oficial: https://portainer.io/
#
# Variável da Data Inicial para calcular o tempo de execução do script
DATAINICIAL=`date +%s`
#
# Variáveis para validar o ambiente, verificando se o usuário e "root", versão do ubuntu e kernel
USUARIO=`id -u`
UBUNTU=`lsb_release -rs`
KERNEL=`uname -r | cut -d'.' -f1,2`
#
# Variável do caminho do Log dos Script utilizado nesse curso
VARLOGPATH="/var/log/"
#
# Variável para criação do arquivo de Log dos Script
LOGSCRIPT=`echo $0 | cut -d'/' -f2`
#
# Variável do caminho para armazenar os Log's de instalação
LOG=$VARLOGPATH/$LOGSCRIPT
#
# Variável do download do Docker
DOCKERGPG="https://download.docker.com/linux/ubuntu/gpg"
DOCKERDEB="deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
DOCKERKEY="0EBFCD88"
#
# Verificando se o usuário e Root
if [ "$USUARIO" == "0" ]
	then
		echo -e "O usuário e Root, continuando com o script..."
	else
		echo -e "Usuário não e Root, execute o comando: sudo -i, execute novamente o script."
		exit 1
fi
#
# Verificando se a distribuição e 18.04.x
if [ "$UBUNTU" == "18.04" ]
	then
		echo -e "Distribuição e 18.04.x, continuando com o script..."
	else
		echo -e "Distribuição não homologada, instale a versão 18.04.x e execute novamente o script."
		exit 1
fi
#		
# Verificando se o Kernel e 4.15
if [ "$KERNEL" == "4.15" ]
	then
		echo -e "Kernel e >= 4.15, continuando com o script..."
		sleep 5
	else
		echo -e "Kernel não homologado, instale a versão do Ubuntu 18.04.x e atualize o sistema."
		exit 1
fi
#
# Script de instalação do Docker e Portainer no GNU/Linux Ubuntu Server 18.04.x
clear
echo -e "Instalação do Docker e Portainer no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a instalação do Portainer acessar a URL: http://`hostname -I`:9000/\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet..."
sleep 5
echo
#
echo -e "Adicionando o Repositório Universal do Apt, aguarde..."
	add-apt-repository universe &>> $LOG
echo -e "Repositório adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando as listas do Apt, aguarde..."
	apt update &>> $LOG
echo -e "Listas atualizadas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando o sistema, aguarde..."
	apt -y upgrade &>> $LOG
echo -e "Sistema atualizado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Removendo software desnecessários, aguarde..."
	apt -y autoremove &>> $LOG
echo -e "Software removidos com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o Docker e o Portainer, aguarde..."
echo
#
echo -e "Instalando as dependências do Docker, aguarde..."
	apt -y install apt-transport-https ca-certificates curl software-properties-common linux-image-generic linux-image-extra-virtual &>> $LOG
echo -e "Instalação das dependências feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Adicionando as Chaves GPG do Docker, aguarde..."
	curl -fsSL $DOCKERGPG | apt-key add -
echo -e "Chaves adicionadas com sucesso!!!, continuando com o script..."
sleep 5
echo
#				 
echo -e "Verificando as Chaves do GPG do Docker, aguarde..."
	apt-key fingerprint $DOCKERKEY &>> $LOG
echo -e "Chaves verificadas com sucesso com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Adicionando o repositório do Docker, aguarde..."
	add-apt-repository "$DOCKERDEB" &>> $LOG
echo -e "Repositório adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando novamente as listas do Apt, aguarde..."
	apt update &>> $LOG
echo -e "Listas atualizadas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o Docker, aguarde..."
	apt -y install docker-ce cgroup-lite &>> $LOG
echo -e "Docker instalado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Adicionando o usuário Root do Grupo do Docker, aguarde..."
	usermod -a -G docker $USER &>> $LOG
echo -e "Usuário adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Iniciando o Serviço Docker, aguarde..."
	sudo service docker start &>> $LOG
echo -e "Serviço iniciado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Docker instalado com sucesso!!!, pressione <Enter> para continuar com o script."
read
sleep 5
clear
#
echo -e "Iniciando o Container de teste do Docker, aguarde..."
	docker run hello-world
echo -e "Container iniciado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Iniciando o Container de teste do Ubuntu, aguarde..."
	docker run -it ubuntu bash
echo -e "Container iniciado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Container criados com sucesso!!!, pressione <Enter> para continuar com o script."
read
sleep 5
clear
#
echo -e "Instalando o Portainer, aguarde..."
sleep 3
echo
#
echo -e "Criando o volue do Portainer, aguarde..."
	docker volume create portainer_data &>> $LOG
echo -e "Volume criado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Criando o Container do Portainer, aguarde..."
	docker run --name portainer -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer &>> $LOG
echo -e "Container criado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Verificando a porta de conexão do Portainer, aguarde..."
	netstat -an | grep 9000
echo -e "Porta de conexão verificada com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do Docker e Portainer feita com Sucesso!!!"
	DATAFINAL=`date +%s`
	SOMA=`expr $DATAFINAL - $DATAINICIAL`
	RESULTADO=`expr 10800 + $SOMA`
	TEMPO=`date -d @$RESULTADO +%H:%M:%S`
echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo."
read
exit 1
