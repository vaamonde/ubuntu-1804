#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 14/04/2021
# Data de atualização: 14/04/2021
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x

#Localizando os Hard Disk no servidor Ubuntu
sudo lshw -class disk

#Verificando os disco com os comandos: Fdisk, Cfdisk e Parted
sudo fdisk -l (sem suporte a GPT somente MBR)
sudo parted -l (com suporte a GPT e MBR)
sudo cfdisk -P s (sem suporte a GPT somente MBR)

#Verificando os Hard Disk SDC e SDD
sudo cfdisk -P s /dev/sdc
sudo cfdisk -P s /dev/sdd

#Verificando o UUID dos Hard Disk
sudo blkid

#Utilizando o fdisk para criar o particionamento no Hard Disk SDC
sudo fdisk /dev/sdc
	n <-- nova partição
	p <-- primaria
	1 <-- primeira partição
		<-- valor do primeiro cilindro DEFAULT
		<-- valor do cilindro final, tudo DEFAULT
	p <-- imprime na tela o particionamento
	t <-- mudar o tipo de partição
		<-- fd RAID auto-configuração
	w <-- sair e gravar as informações de partição

#Utilizando o fdisk para criar o particionamento no Hard Disk SDD
sudo fdisk /dev/sdd
	n <-- nova partição
	p <-- primaria
	1 <-- primeira partição
		<-- valor do primeiro cilindro DEFAULT
		<-- valor do cilindro final, tudo DEFAULT
	p <-- imprime na tela o particionamento
	t <-- mudar o tipo de partição
		<-- fd RAID auto-configuração
	w <-- sair e gravar as informações de partição

#Listando o diretório /dev/ para verificar os arquivos de bloco dos Hard Disk
sudo ls -lha /dev/s*

#Criando o RAID-1 com os Hard Disk SDC e SDD
#Opção do comando mdadm: -C (create md device), -v (verbose), -l (RAID type), -n (number device)
sudo mdadm -C -v /dev/md1 -l 1 -n 2 /dev/sdc1 /dev/sdd1

#Criando o sistema de arquivos EXT4 no MD1
sudo mkfs.ext4 /dev/md1

#Verificando o RAID-1 criado no MD1
#Opção do comado mdadm: -D (), -E ()
sudo cat /proc/mdstat
sudo mdadm -D /dev/md1
sudo mdadm -E /dev/sdc1
sudo watch cat /proc/mdstat

#Verificando os detalhes dos RAID-1
sudo mdadm --detail --scan

#Atualizando o arquivo /etc/mdadm/mdadm.conf
sudo mdadm --detail --scan | grep /1 > > /etc/mdadm/mdadm.conf

#Editando o arquivo mdadm.conf
sudo vim /etc/mdadm/mdadm.conf

#Atualizando o initramfs
sudo update-initramfs -u

#Reinicializar o Servidor para testar o RAID-1
sudo reboot

#Montando o disco do RAID-1 manualmente com o comando mount
sudo mkdir /arquivos
sudo mount /dev/md1 /arquivos
sudo mount -l | grep /arquivos
sudo cd /arquivos
sudo mkdir teste{1..9}
sudo ls -lha
sudo cd /
sudo umount /arquivos
sudo mount -l | grep /arquivos