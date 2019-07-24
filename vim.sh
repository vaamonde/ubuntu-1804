#!/bin/bash
#Autor: Robson Vaamonde
#Site: www.procedimentosemti.com.br
#Facebook: facebook.com/ProcedimentosEmTI
#Facebook: facebook.com/BoraParaPratica
#YouTube: youtube.com/BoraParaPratica
#Data de criação: 24/07/2019
#Data de atualização: 24/07/2019
#Versão: 0.01

#Comandos básicos de do Editor de Texto VIM

#Instalando o Editor de Texto VIM no Debian, Ubuntu ou Linux Mint
sudo apt update && sudo apt install vim vim-common

#Iniciando o editor de Texto VIM
man vim
vim

#Modos do editor de Texto VIM
Modo 				Tecla 							Rodapé 				Descrição 
---------------------------------------------------------------------------------------------------------
de Inserção         i ou Insert                     -- INSERÇÃO --		Inserção de texto
de Comandos         <Esc>                           Comandos de manipulação de texto
de Linha de comando <Esc> shift : (dois pontos)     :					Comandos de manipulação arquivo 
de Visual           <Esc> v                         -- VISUAL --		Seleção visual de texto
de Busca            <Esc> /                         /					Busca de padrões no texto
de Reposição        <Esc> shift R ou Insert/Insert  -- SUBSTITUIÇÃO --	Inserção sobreescrevendo
---------------------------------------------------------------------------------------------------------

#Ajuda do editor de Texto VIM (q = quit)
<Esc> shift :help <Enter>
<Esc> shift :q <Enter>
<Esc> F1

#Saindo do editor de Texto VIM (q = quit | ! = forçado)
<Esc> shift :q <Enter>
<Esc> shift :q! <Enter>

#Salvando arquivo no editor de Texto VIM (w = write | wq = write/quit | x = write/quit)
<Esc> shift :w teste01.txt <Enter>
<Esc> shift :wq <Enter>
<Esc> shift :x <Enter>

#Criando um novo arquivo no editor de Texto VIM
<Esc> shift :enew <Enter>

#Abrindo um arquivo no editor de Texto VIM (e = explorer | o = open below)
<Esc> shift :e teste01.txt <Enter>
<Esc> shift :o teste01.txt <Enter>
<Esc> shift :e. selecione o arquivo <Enter>

#Executando comandos externos no editor de Texto VIM
<Esc> shift :!ls -lh <Enter>

#Habilitando recursos no editor de Texto VIM
<Esc> shift :set number <Enter>	<-- mostra número da linha
<Esc> shift :set ignorecase <Enter>	<-- ignora case insensitive na busca
<Esc> shift :set syntax on <Enter> <-- identificação da linguagem
<Esc> shift :set autoindent <Enter> <-- identação automática
<Esc> shift :set showmatch <Enter> <-- completa as chaves e colchetes quando você os fecha

#Arquivo de confiração do VIM
ls -lha /etc/vim/vimrc
cat /etc/vim/vimrc
sudo vim /etc/vim/

#Deletando caracteres e linhas no editor de Texto VIM (x = delete char | d = delete | dw = delete next word)
<Esc> x		<-- deleta carácter por carácter
<Esc> dw	<-- deleta palavra por palavra
<Esc> dd	<--	deleta uma linha inteira

#Desfazendo uma alteração no editor de Texto VIM (u = undo)
<Esc> u	

#Copiando palavras ou linhas no editor de Texto VIM (y = yank)
<Esc> v		<-- selecionar o texto com os direcionadores
<Esc> y		<-- copia o texto
<Esc> yy	<-- copiando a linha inteira

#Colando palavras ou linhas no editor de Texto VIM (p = paste after)
<Esc> i		<-- colar o curso no local que deseja colar
<Esc> p		<-- colar o texto

#Localizando palavras no editor de Texto VIM (/ = find | n = next find)
<Esc> /palavra <Enter>
n			<-- localiza próxima ocorrência

#Dividindo a tela horizontalmente no editor de Texto VIM (split = dividir)
:split
Ctrl W

#Dividindo a tela verticalmente no editor de Texto VIM (vsplit = dividir tela vertical)
:vsplit
Ctrl W
