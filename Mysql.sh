#Autor: Robson Vaamonde
#Site: www.procedimentosemti.com.br
#Facebook: facebook.com/ProcedimentosEmTI
#Facebook: facebook.com/BoraParaPratica
#YouTube: youtube.com/BoraParaPratica
#Data de criação: 13/02/2019
#Data de atualização: 18/11/2020
#Versão: 0.07

#Instalando o SGBD (Sistema de Gerenciamento de Banco de Dados) MySQL ou MariaDB
sudo apt update && sudo apt install mysql-server mysql-client mysql-common
sudo apt update && sudo apt install mariadb-server mariadb-client mariadb-common

#Gerenciadores Gráficos do SGBD MySQL ou MariaDB
sudo apt update && sudo apt install mysql-workbench
sudo apt update && sudo apt install emma
sudo apt update && sudo apt install phpmyadmin (precisa do Apache2 e PHP)

#Recomendações antes de instalar o PhpMyAdmin: 
#1. Instalar o LAMP: sudo apt install lamp-server^ perl python (nesse cenário vai ser instalado o MySQL)
#(caso queira o MariaDB: sudo apt install apache2 mariadb-server mariadb-client mariadb-common php7.2-fpm php7.2-common\
#php7.2-mbstring php7.2-xmlrpc php7.2-soap php7.2-gd php7.2-xml php7.2-intl php7.2-mysql php7.2-cli php7.2-zip php7.2-curl)
#2. Instalar as Dependências do PhpMyAdmin: sudo apt install php7.2-mbstring php-gettext php7.2-dev libmcrypt-dev php-pear
#3. Habilitar os Módulos do PHP no Apache2: sudo phpenmod mcrypt && sudo phpenmod mbstring
#4. Reinicializar o Apache2: sudo systemctl restart apache2
#5. Instalar o PhpMyAdmin: sudo apt update && sudo apt -y install phpmyadmin

#Aplicando as políticas de segurança no SGDB MySQL ou MariaDB

#Políticas de Segurança do MySQL
sudo mysql_secure_installation
1. Connecting to MySQL using a blank password (Press y|Y for Yes, any other key for No:) <Enter>
2. New password root: aulaead <Enter>
3. Re-enter new password root: aulaead <Enter>
4. Remove anonymous users? (Press y|Y for Yes, any other key for No:) y <Enter>
5. Disallow root login remotely (Press y|Y for Yes, any other key for No:) <Enter>
6. Remove test database and access to it? (Press y|Y for Yes, any other key for No:) <Enter>
7. Reload privilege tables now? (Press y|Y for Yes, any other key for No:) y <Enter>

#Políticas de Segurança do MariaDB
#(Obs: na instalação é associado a senha do seu usuário para o root do MariaDB)
sudo mysql_secure_installation
1. Enter current password for root (enter for none): pti@2019 <Enter>
2. Change the root password? [Y/n]: y <Enter>
3. New password: aulaead <Enter>
4. Re-enter new password: aulaead <Enter>
5. Remove anonymous users? [Y/n]: y <Enter>
6. Disallow root login remotely? [Y/n]: n <Enter>
7. Remove test database and access to it? [Y/n]: n <Enter>
8. Reload privilege tables now? [Y/n]: y <Enter>

#Localização dos arquivos de configuração do SGBD do MySQL ou MariaDB
/etc/mysql <-- Diretório de configuração do SGBD MySQL ou MariaDB
/etc/mysql/mysql.conf.d/ <-- Configurações do Servidor SGBD do MySQL
/etc/mysql/mysql.conf.d/mysqld.cnf <-- Arquivo de configuração do Servidor SGBD do MySQL
/etc/mysql/mariadb.conf.d/ <-- Configurações do Servidor SGBD do MariaDB
/etc/mysql/mariadb.conf.d/50-server.cnf <-- Arquivo de configuração do Servidor SGBD do MariaDB

#Atualizando o arquivo de configuração do SGBD do MySQL ou MariaDB
sudo cp -v /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.old
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf

#Verificando o Serviço do SGBD do MySQL ou MariaDB
sudo systemctl status mysql
sudo systemctl restart mysql
sudo systemctl stop mysql
sudo systemctl start mysql

#Verificando o Porta de Conexão do SGDB do MySQL ou MariaDB
#(opções do comando netstat: -a all | -n numeric)
sudo netstat -an | grep 3306

#Acessando o SGBD do MySQL ou MariaDB com o usuário root do MySQL/MariaDB
#(opções do comando mysql: -u user | -p password)
sudo mysql -u root -p

#Verificando os Bancos de Dados Existentes no SGBD do MySQL ou MariaDB
SHOW DATABASES;

#Criando o nosso Banco de Dados AulaEAD no SGBD do MySQL ou MariaDB
#Verificando o nosso Banco de Dados criado no SGBD do MySQL ou MariaDB
CREATE DATABASE aulaead;
SHOW DATABASES;

#Permitindo que o usuário Root administre o servidor Remotamente do MySQL ou MariaDB
#(opções do comando GRANT: grant (permissão), all (todos privilégios), on (em ou na | banco ou tabela), *.* (todos os bancos/tabelas))
#(opções do comando GRANT: to (para), user@'%' (usuário @ localhost), identified by (identificado por - senha do usuário))
#Obs: no MySQL versão >= 8.0.x o comando de permissão para o usuário root mudou:
#Primeiro cirar o usuário: CREATE USER 'vaamonde'@'localhost' IDENTIFIED WITH mysql_native_password BY 'vaamonde';
#Segundo aplicar as permissões: GRANT ALL PRIVILEGES ON *.* TO 'vaamonde'@'localhost';
#Terceiro aplicar todas as mudanças: FLUSH PRIVILEGES;
GRANT ALL ON *.* TO root@'%' IDENTIFIED BY 'aulaead'

#Criando usuários no SGBD do MySQL ou MariaDB
#(opções do comando CREATE: create (criação), user (usuário), identified by (identificado por - senha do usuário))
CREATE USER 'aulaead' IDENTIFIED BY 'aulaead';

#Aplicando as permissões de acesso ao Banco de Dados AulaEAD no SGBD do MySQL ou MariaDB
#(opções do comando GRANT: grant (permissão), usage (uso em banco ou tabela), on (em ou na | banco ou tabela), *.* (todos os bancos/tabelas))
#(opções do comando GRANT: to (para), 'aulaead' (usuário), identified by (identificado por - senha do usuário))
#(opções do comando GRANT: all (todos privilégios), privileges (privilégios), on (em ou na | banco ou tabela), aulaead.* (banco/tabelas), to (para) 'aulaead' (usuário))
GRANT USAGE ON *.* TO 'aulaead' IDENTIFIED BY 'aulaead';
GRANT ALL PRIVILEGES ON aulaead.* TO 'aulaead';
FLUSH PRIVILEGES;
EXIT

##Acessando o SGBD do MySQL ou MariaDB com o usuário AulaEAD
#(opções do comando mysql: -u user | -p password)
mysql -u aulaead -p

#Utilizando o Banco e Dados AulaEAD no SGBD do MySQL ou MariaDB
SHOW DATABASES;
USE aulaead;

#Criando a Tabela Alunos e Verificando suas Informações no SGBD do MySQL ou MariaDB
CREATE TABLE alunos(
	matricula VARCHAR(6) NOT NULL,
	nome VARCHAR(30) NOT NULL,
	cidade VARCHAR(30) NULL,
	PRIMARY KEY(matricula));
DESC alunos;
SELECT * FROM alunos;

#Criando a Tabela Cursos e Verificando suas Informações no SGBD do MySQL ou MariaDB
CREATE TABLE cursos(
	codcurso VARCHAR(6) NOT NULL,
	nomecurso VARCHAR(30) NOT NULL,
	PRIMARY KEY(codcurso));
DESC cursos;
SELECT * FROM cursos;

#Criando a Tabela Matriculas e Verificando suas Informações no SGBD do MySQL ou MariaDB
CREATE TABLE matriculas(
	matricula VARCHAR(6) NOT NULL,
	codcurso VARCHAR(6) NOT NULL);
DESC matriculas;
SELECT * FROM matriculas;

#Visualizando as Tabelas Criadas no SGBD do MySQL ou MariaDB
SHOW TABLES;

#Utilizando o conceito do CRUD (Create INSERT, Read SELECT, Update UPDATE and Delete DELETE) no SGBD MySQL ou MariaDB

#Inserindo dados dentro da Tabela Alunos no SGBD do MySQL ou MariaDB
INSERT INTO alunos VALUES ('000001', 'Robson Vaamonde', 'Guarulhos');
INSERT INTO alunos VALUES ('000002', 'Leandro Ramos', 'São Paulo');
INSERT INTO alunos VALUES ('000003', 'José de Assis', 'São Paulo');
SELECT * FROM alunos;

#Inserindo dados dentro da Tabela Cursos no SGBD do MySQL ou MariaDB
INSERT INTO cursos VALUES ('000001', 'Debian Linux');
INSERT INTO cursos VALUES ('000002', 'Ubuntu Linux');
INSERT INTO cursos VALUES ('000003', 'CentOS Linux');
SELECT * FROM cursos;

#Inserindo dados dentro da Tabela Matriculas no SGBD do MySQL ou MariaDB
INSERT INTO matriculas VALUES ('000001', '000001');
INSERT INTO matriculas VALUES ('000001', '000002');
INSERT INTO matriculas VALUES ('000002', '000003');
INSERT INTO matriculas VALUES ('000003', '000001');
SELECT * FROM matriculas;

#Verificando informações mais detalhadas das Tabelas no SGBD do MySQL ou MariaDB
SELECT matricula, nome FROM alunos;
SELECT * FROM matriculas WHERE codcurso = '000001';
SELECT * FROM alunos WHERE cidade LIKE 'S%';
SELECT * FROM alunos WHERE nome LIKE '%m%' AND cidade = 'São Paulo';
SELECT COUNT(*) FROM alunos;

#Ordenando as informações das Tabelas no SGBD do MySQL ou MariaDB
SELECT * FROM cursos ORDER BY codcurso DESC;
SELECT * FROM cursos ORDER BY nomecurso DESC;

#Agrupando os valores das Tabelas no SGBD do MySQL ou MariaDB
SELECT codcurso FROM matriculas GROUP BY codcurso;
SELECT codcurso, COUNT(*) FROM matriculas GROUP BY codcurso;

#Juntando Tabelas para consultas integradas no SGBD do MySQL ou MariaDB
SELECT * FROM cursos JOIN matriculas;
SELECT * FROM cursos JOIN matriculas ON cursos.codcurso = matriculas.codcurso;
SELECT cursos.nomecurso, matriculas.matricula FROM cursos JOIN matriculas ON cursos.codcurso = matriculas.codcurso;
SELECT nomecurso, COUNT(*) FROM cursos JOIN matriculas ON cursos.codcurso = matriculas.codcurso GROUP BY nomecurso;

#Alterando uma Tabela e adicionando uma nova Coluna no SGBD do MySQL ou MariaDB
ALTER TABLE matriculas ADD COLUMN codmatricula VARCHAR(6) NOT NULL FIRST;
DESC matriculas;
SELECT * FROM matriculas;

#Atualizando a Tabela com novos valores em uma Coluna no SGBD do MySQL ou MariaDB
UPDATE matriculas SET codmatricula='000001' WHERE matricula='000001' AND codcurso='000001';
UPDATE matriculas SET codmatricula='000002' WHERE matricula='000001' AND codcurso='000002';
UPDATE matriculas SET codmatricula='000003' WHERE matricula='000002';				
UPDATE matriculas SET codmatricula='000004' WHERE matricula='000003';
SELECT * FROM matriculas;
UPDATE matriculas SET codcurso='000003' WHERE codmatricula='000001';

#Deletando registros em uma Tabela no SGBD do MySQL ou MariaDB
SELECT * FROM matriculas;
DELETE FROM matriculas WHERE matricula='000001';
SELECT * FROM matriculas;
				
#Deletando uma Tabela no SGBD do MySQL ou MariaDB
SHOW TABLES;
DROP TABLE matriculas;
SHOW TABLES;
DROP TABLE cursos, alunos;
SHOW TABLES;

#Deletando um Banco de Dados no SGBD do MySQL ou MariaDB
SHOW DATABASES;
DROP DATABASE aulaead;
SHOW DATABASES;
