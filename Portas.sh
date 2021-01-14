#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 10/02/2019
# Data de atualização: 14/01/2021
# Versão: 0.05
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x

001: openssh.sh;		SSH: 22
002: lamp.sh;			HTTP: 80, MYSQL: 3306
003: wordpress.sh;		HTTP: 80
004: webmin.sh;			HTTPS: 10000
005: netdata.sh;		HTTP: 19999
006: loganalyzer.sh;	HTTP: 80
007: docker.sh;			HTTP: 9000
008: openfire.sh;		HTTP: 9090
009: zoneminder.sh;		HTTP: 80
010: asterisk.sh;		5060
011: bareos.sh;			HTTP: 80, 9102, 9103
012: ansible.sh;		HTTP: 4440
013: glpi.sh;			HTTP: 80
014: grafana.sh;		HTTP: 30000
015: graylog.sh;		HTTP: 19000, 27017, 9200
016: tomcat.sh;			HTTP: 8080
017: zabbix.sh;			HTTP: 80, 10050, 10051
018: fusion.sh;         HTTP: 80
019: ntopng.sh;		    HTTP: 3001
020: postgresql.sh;		5432
021: guacamole.sh:      HTTP: 8080, 4822