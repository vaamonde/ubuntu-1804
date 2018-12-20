#!/bin/bash
echo -en "Verificando conflito de Software, aguarde...\n"
	for name in mysql-server mysql-common apache2
	do
  		[[ $(dpkg -s $name 2> /dev/null) ]] || { echo -en "Conflito de Software do: $name .: OK\n";deps=1; }
	done
		[[ $deps -ne 1 ]] && { echo -en "\n\nO software: $name precisa ser removido. \nUse o comando 'apt purge $name'\n";exit 1; } || echo "Conflito de Software.: OK"
		sleep 5
