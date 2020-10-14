#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 22/07/2020
# Data de atualização: 22/07/2020
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x

#Configuração da Placa de Rede no GNU/Linux Ubuntu 18.04.x LTS
#UDEV controlado pelo Systemd nomeando as Placas de Rede
#Site: https://netplan.io/examples

#Verificando os dispositivos PCI de placa de rede instalados
sudo lspci -v | grep -i ethernet
sudo lcpci -v -s 00:03.0

#Verificando os detalhes do hardware de placa de rede instalada
sudo lshw -class network

#Verificando as configurações de endereçamento da placa de rede instalada
sudo ifconfig -a
sudo ip address

#Verificando as configurações de gateway (route)
sudo route -n
sudo ip route

#Verificando as configurações de DNS (resolução de nomes)
sudo cat /etc/resolv.conf

#Verificando as informações de cache de DNS (resolução de nomes)
sudo systemd-resolve --status
sudo systemd-resolve --statistics

#Não se utiliza mais os comandos ifdown e ifup
sudo ifdown enp0s3
sudo ifup enp0s3

#Opção ifconfig down e up ainda e utilizado e do ip link set
sudo ifconfig enp0s3 down
sudo ifconfig enp0s3 up
sudo ip link set enp0s3 down
sudo ip link set enp0s3 up

#Diretório de configuração da placa de rede
cd /etc/netplan/

#Arquivo de configurações da placa de rede
/etc/netplan/50-cloud-init.yaml

#Configuração do endereçamento IPv4 Dynamic (Dinâmico)
network:
	ethernets:
		enp0s3:
			dhcp4: yes
	version: 2
	
#Aplicando as configurações
sudo netplan --debug apply
sudo netplan ip leases enp0s3

#Configuração do endereçamento IPv4 Static (Estático)
network:
	ethernets:
		enp0s3:
			dhcp4: false
			addresses: [172.16.1.20/24]
			gateway4: 172.16.1.254
			nameservers:
				addresses: [172.16.1.254, 8.8.8.8, 8.8.4.4]
				search: [pti.intra]
	version: 2

#Aplicando as configurações
sudo netplan --debug apply

#Configuração do endereçamento IPv4 Static (Estático)
network:
	ethernets:
		enp0s3:
			dhcp4: false
			addresses: 
			- 172.16.1.20/24
			gateway4: 172.16.1.254
			nameservers:
				addresses: 
				- 172.16.1.254
				- 8.8.8.8 
				- 8.8.4.4
				search: 
				- pti.intra
	version: 2

#Aplicando as configurações
sudo netplan --debug apply
	
#Configurações de múltiplos endereços IP
network:
	ethernets:
		enp0s3:
			dhcp4: false
			addresses: 
			- 192.168.1.100/24
			- 192.168.2.100/24
			- 192.168.3.100/24
			gateway4: 192.168.1.1
			nameservers:
				addresses:
				- 10.0.0.1
				- 8.8.8.8 
				- 8.8.4.4
				search: 
				- pti.intra
	version: 2

#Aplicando as configurações
sudo netplan --debug apply

#Configurações de múltiplos endereços de gateway
network:
	ethernets:
		enp0s3:
			dhcp4: false
			addresses: 
			- 192.168.1.100/24
			- 192.168.2.100/24
			- 192.168.3.100/24
			nameservers:
				addresses:
				- 10.0.0.1
				- 8.8.8.8 
				- 8.8.4.4
				search: 
				- pti.intra
			routers:
				- to: 0.0.0.0/0
         		via: 9.0.0.1
         		metric: 100
       			- to: 0.0.0.0/0
         		via: 10.0.0.1
         		metric: 100
       			- to: 0.0.0.0/0
         		via: 11.0.0.1
         		metric: 100
	version: 2
	
#Configurações de bonds 802.3d:
network:
	bonds:
		bond0:
			dhcp4: yes
			interfaces:
				- enp3s0
				- enp4s0
			parameters:
				mode: active-backup
				primary: enp3s0
	version: 2

#Configurações de bridges:

#Configurações de vlans:

#Configurações de wi-fi:
network:
	wifis:
		wlp2s0b1:
		dhcp4: no
		dhcp6: no
		addresses: [192.168.0.21/24]
		gateway4: 192.168.0.1
		nameservers:
			addresses: [192.168.0.1, 8.8.8.8]
		access-points:
			"pti-intra":
			password: "pti@2018"
	version: 2