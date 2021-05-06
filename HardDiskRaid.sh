#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 14/04/2021
# Data de atualização: 06/05/2021
# Versão: 0.02
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x

#Fdisk: é um programa orientado a menus para criação e manipulação de tabelas de partição, ele 
#compreende tabelas de partição do tipo DOS e etiquetas de disco do tipo BSD ou SUN. O fdisk 
#não entende GPTs (tabelas de partição GUID) e não foi projetado para partições grandes, nesses 
#casos, use o GNU mais avançado dividido. O fdisk não usa o modo e os cilindros compatíveis com 
#DOS como unidades de exibição por padrão.
#
#Cfdisk: é um editor de partições do Linux, semelhante ao fdisk, mas com uma interface de usuário 
#diferente (ncurses). Faz parte do pacote de programas utilitários do Linux, o util-linux. 
#
#Parted: (o nome sendo a conjunção das duas palavras PARTition e EDitor) é um editor de partições 
#livre, usado para criar e excluir partições. Isso é útil para criar espaço para novos sistemas 
#operacionais, reorganizar o uso do disco rígido, copiar dados entre discos rígidos e imagens de disco.
#
#Mdadm: é um utilitário Linux usado para gerenciar e monitorar dispositivos RAID de software, é usado 
#em distribuições Linux modernas no lugar de utilitários RAID de software mais antigos, como raidtools2 
#ou raidtools.
#
#Mkfs: é um comando usado para formatar um dispositivo de armazenamento em bloco com um sistema de 
#arquivos específico. O comando é parte dos sistemas operacionais UNIX e tipo UNIX.
#
#Mount ou Umount: tem a função de montar ou desmontar um dispositivo na hierarquia do sistema de arquivos 
#do Linux, muito utilizado para acessar partições em Hard Disk, Pendrive, CD-Rom, DVD, etc... 
#
#Fstab: O arquivo /etc/fstab permite que as partições do sistema sejam montadas facilmente especificando 
#somente o dispositivo ou o ponto de montagem. Este arquivo contém parâmetros sobre as partições que são 
#lidos pelo comando mount. 

#Localizando os Hard Disk no servidor Ubuntu
sudo lshw -class disk

#Verificando os Hard Disk com os comandos: Fdisk, Cfdisk e Parted
#opção do comando fdisk: -l (list)
#opção do comando parted: -l (list)
sudo fdisk -l (sem suporte a GPT somente MBR)
sudo parted -l (com suporte a GPT e MBR)
sudo cfdisk (sem suporte a GPT somente MBR)

#Listando os Hard Disk e Partições montadas
sudo lsblk

#Verificando o UUID (Universally Unique IDentifier) dos Hard Disk
sudo blkid

#Utilizando o fdisk para criar o particionamento no Hard Disk SDC
sudo fdisk /dev/sdb
	n <-- adicionar uma nova partição
	p <-- primaria (0 primaria, 0 estendida, 4 livres)
	1 <-- primeira partição (1-4, padrão 1)
		<-- valor do primeiro cilindro (padrão 2048)
		<-- valor do último cilindro (padrão tudo alocado)
	p <-- imprime na tela o particionamento
	t <-- mudar o tipo de partição
		<-- fd Linux RAID auto-detecção (valor em Hexadecimal)
	p <-- imprime na tela o particionamento
	w <-- sair e gravar as informações de partição

#Utilizando o fdisk para criar o particionamento no Hard Disk SDD
sudo fdisk /dev/sdc
	n <-- adicionar uma nova partição
	p <-- primaria (0 primaria, 0 estendida, 4 livres)
	1 <-- primeira partição (1-4, padrão 1)
		<-- valor do primeiro cilindro (padrão 2048)
		<-- valor do último cilindro (padrão tudo alocado)
	p <-- imprime na tela o particionamento
	t <-- mudar o tipo de partição
		<-- fd Linux RAID auto-detecção (valor em Hexadecimal)
	p <-- imprime na tela o particionamento
	w <-- sair e gravar as informações de partição

#Listando o conteúdo do diretório: /dev/ para verificar os arquivos de bloco dos Hard Disk
#opções do comando ls: -l (long listing), -h (--human-readable), -a (--all)
sudo ls -lha /dev/sd*

#Criando o RAID-1 com os Hard Disk SDC e SDD utilizando o mdadm
#Opção do comando mdadm: -C (create), -v (verbose), -l (level), -n (raid-devices)
#opções do comando ls: -l (long listing), -h (--human-readable), -a (--all)
sudo mdadm -C -v /dev/md1 -l 1 -n 2 /dev/sdb1 /dev/sdc1
	Continue creating array? y <Enter>
sudo ls -lha /dev/md*

#Criando o sistema de arquivos EXT4 no RAID-1 MD1
#opção do comando mkfs.ext4: -v (verbose)
sudo mkfs.ext4 -v /dev/md1

#Verificando o RAID-1 criado no MD1
#Opção do comado mdadm: -D (--detail), -E (--examine)
sudo cat /proc/mdstat
sudo mdadm -D /dev/md1
sudo mdadm -E /dev/sdb1
sudo mdadm -E /dev/sdc1

#Verificando os detalhes dos RAID-1
#Opção do comado mdadm: -D (--detail), -s (--scan)
sudo mdadm -D -s

#Atualizando o arquivo de configuração do RAID-1 /etc/mdadm/mdadm.conf
#Opção do comado mdadm: -D (--detail), -s (--scan)
#opção do redirecionador >>: (Redireciona a saída padrão, anexando)
sudo mdadm -D -s >> /etc/mdadm/mdadm.conf

#Editando o arquivo mdadm.conf
sudo vim /etc/mdadm/mdadm.conf

#Atualizando o initramfs
#Opção do comando update-initramfs: -u (update)
sudo update-initramfs -u

#Reinicializar o Servidor para testar o RAID-1
sudo reboot

#Montando o disco do RAID-1 manualmente com o comando mount
#opção do comando mkdir: -v (verbose)
#opção do comando mount: -v (verbose), -l (list)
#opção do bloco de agrupamento {}: (Agrupa comandos em um bloco)
#opções do comando ls: -l (long listing), -h (--human-readable), -a (--all)
#opção do redirecionamento |: (Conecta a saída padrão com a entrada padrão de outro comando)
sudo mkdir -v /arquivos
sudo mount -v /dev/md1 /arquivos
sudo mount -l | grep /arquivos
sudo cd /arquivos
sudo mkdir -v teste{1..9}
sudo touch teste{1..9}.txt
sudo ls -lha
sudo cd /
sudo umount /arquivos
sudo mount -l | grep /arquivos

#Configurando a montagem automática do RAID-1 no arquivo Fstab
sudo vim /etc/fstab