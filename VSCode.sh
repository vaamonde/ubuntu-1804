#!/bin/bash
#Autor: Robson Vaamonde
#Procedimentos em TI: http://procedimentosemti.com.br
#Bora para Prática: http://boraparapratica.com.br
#Robson Vaamonde: http://vaamonde.com.br
#Facebook Procedimentos em TI: https://www.facebook.com/ProcedimentosEmTi
#Facebook Bora para Prática: https://www.facebook.com/BoraParaPratica
#Instagram Procedimentos em TI: https://www.instagram.com/procedimentoem
#YouTUBE Bora Para Prática: https://www.youtube.com/boraparapratica
#LinkedIn Robson Vaamonde: https://www.linkedin.com/in/robson-vaamonde-0b029028/
#Data de criação: 23/07/2021
#Data de atualização: 23/07/2021
#Versão: 0.02
#Testado e homologado no Linux Mint 20.x e VSCode 1.58.x

#Links Oficial do VSCode e do Marketplace
Link do Visual Studio Code: https://code.visualstudio.com/
Link do Marketplace: https://marketplace.visualstudio.com/VSCode

#Baixando o VSCode para o GNU/Linux Mint 20.x
https://code.visualstudio.com/download
	Versão: .deb (Debian, Ubuntu 64 Bits)
		Salvar aquivo

#Instalando o VSCode utilizando o Gdebi-Gtk do Linux Mint 20.x
code_1.xxxx_amd64
	Instalar Pacote
		Fechar

#Verificando as entradas dos novos repositórios no MintUpdate do Linux Mint 20.x
Menu
	MintUpdate
		Editar
			Fontes de Programas
				(Digite a senha do seu usuário)
					Repositórios Adicionais
						Habilitado: Microsoft / Stable - code
					Chaves de Autenticação
						Microsoft (Release signing)
			Fechar
	Fechar

#Verificando o VSCode no Linux Mint 20.x
Menu
	Busca Indexada
		vscode
			Dark Theme
			Notifications: Pacote PT-BR
			Disable: Mostrar página inicial na inicialização

#Instalando o Vim, Git e o Python no Linux Mint 20.x
Terminal ou Ctrl+Shift+``
	sudo apt update 
	sudo apt install vim git python 
	exit

#Configurando os Aplicativos de Preferencias.
Menu
	Busca Indexada
		Aplicativos de Preferencias
			Texto puro: Visual Studio Code
			Código fonte: Visual Studio Code

#Instalando e Configurando as Principais Extensões que utilizo no Meu Dia a Dia
Portuguese (Brazil) Language Pack for Visual Studio Code
	(Sem necessidade de configuração)

Brazilian Portuguese - Code Spell Checker
	F1
		Show Spell Checker Configuration Info
			Language
				English (en_us)
				Portuguese (pt_br)
				Portuguese - Brazil (pt-br)
			File Types and Programming Languages
				shellscript, python, markdown, etc...
				
Code Speel Checker
	F1
		Code Speel Checker
			C Spell: Language: pt,pt-BR
			C Spell: Max Duplicate Problems: 5000
			C Speell: Max Number Of Problems: 100000
			Editor: Tab Size: 4
			Editor: Detect Indentation: False
			Editor: Insert Spaces: False

Bats (Bash Automated Testing System)
	(Sem necessidade de configuração)

Bash Beautify
	(Sem necessidade de configuração)

Shell-Format
	(Sem necessidade de configuração)

ShellCheck
	(Sem necessidade de configuração)

Cisco IOS Systax
	(Sem necessidade de configuração)

Cisco IOS-XR Systax
	(Sem necessidade de configuração)

Pylance
	(Sem necessidade de configuração)

Python
	(Sem necessidade de configuração)