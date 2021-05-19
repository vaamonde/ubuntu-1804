#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 10/02/2019
# Data de atualização: 19/05/2021
# Versão: 0.09
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x

001: openssh.sh;		SSH: 22
002: lamp.sh;			HTTP: 80, MYSQL: 3306
003: wordpress.sh;		HTTP: 80, MYSQL: 3306
004: webmin.sh;			HTTPS: 10000
005: netdata.sh;		HTTP: 19999
006: loganalyzer.sh;	HTTP: 80, MYSQL: 3306, SYSLOG: 514
007: docker.sh;			HTTP: 9000
008: openfire.sh;		HTTP: 9090
009: zoneminder.sh;		HTTP: 80, MYSQL: 3306
010: asterisk.sh;		SIP: 5060
011: bareos.sh;			HTTP: 80, MYSQL: 3306, BACULA: 9102, 9103
012: owncloud.sh;		HTTP: 80, MYSQL: 3306,
013: ansible.sh;		HTTP: 4440
014: glpi.sh;			HTTP: 80, MYSQL: 3306
015: grafana.sh;		HTTP: 3000
016: tomcat.sh;			HTTP: 8080
017: graylog.sh;		HTTP: 19000, MONGODB: 27017, 9200
018: zabbix.sh;			HTTP: 80, ZABBIX-AGENT: 10050, 10051
019: ntopng.sh;		    HTTP: 3001
020: fusion.sh;         HTTP: 80, MYSQL: 3306
021: postgresql.sh;		POSTGRE: 5432
022: guacamole.sh:      HTTP: 8080, 4822
023: unifi.sh;			HTTP: 8080, HTTP: 8443, MONGODB: 27017
024: openproject.sh;	HTTP: 80, POSTGRE: 45432
025: lemp.sh;			HTTP: 80, MARIADB: 3306
026: wekan.sh:			HTTP: 3000, MONGODB: 27019
027: rocketcjat.sh:		HTTP: 3000, MONGODB: 27017
028: ocsinventory.sh:	HTTP: 80, MYSQL: 3306
029: bacula.sh:			HTTP: 80, MYSQL: 3306, BACULA: 9101, 9102, 9103 BACULUM: 9095, 9096
030: dnsdhcp.sh:		BIND9: 53, ISC DHCP: 67