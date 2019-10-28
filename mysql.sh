#Autor: Robson Vaamonde
#Site: www.procedimentosemti.com.br
#Facebook: facebook.com/ProcedimentosEmTI
#Facebook: facebook.com/BoraParaPratica
#YouTube: youtube.com/BoraParaPratica
#Data de criação: 13/02/2019
#Data de atualização: 28/10/2019
#Versão: 0.03

#Instalando o SGBD (Sistema de Gerenciamento de Banco de Dados) MySQL ou MariaDB
sudo apt update && sudo apt install mysql-server mysql-client mysql-common
sudo apt update && sudo apt install mariadb-server mariadb-client mariadb-common

#Gerenciadores Gráficos do SGBD MySQL ou MariaDB
sudo apt update && sudo apt install mysql-workbench
sudo apt update && sudo apt install emma
sudo apt update && sudo apt install phpmyadmin (precisa do Apache2 e PHP)

#Aplicando as políticas de segurança no SGDB MySQL ou MariaDB
sudo mysql_secure_installation
1. Connecting to MySQL using a blank password (Press y|Y for Yes, any other key for No:) <Enter>
2. New password root: pti@2019 <Enter>
3. Re-enter new password root: pti@2019 <Enter>
4. Remove anonymous users? (Press y|Y for Yes, any other key for No:) y <Enter>
5. Disalow root login remotely (Press y|Y for Yes, any other key for No:) <Enter>
6. Remove test database and access to it? (Press y|Y for Yes, any other key for No:) <Enter>
7. Reload privilege tables now? (Press y|Y for Yes, any other key for No:) y <Enter>

#Verificando o Serviço do SGBD do MySQL ou MariaDB
sudo systemctl status mysql
sudo systemctl restart mysql
sudo systemctl stop mysql
sudo systemctl start mysql

#Verificando o Porta de Conexão do SGDB do MySQL ou MariaDB
sudo netstat -an | grep 3306

#Acessando o SGBD do MySQL ou MariaDB com o usuário root do MySQL/MariaDB
sudo mysql -u root -p

#Verificando os Bancos de Dados Existentes no SGBD do MySQL ou MariaDB
SHOW DATABASES;

#Criando o nosso Banco de Dados AulaEAD no SGBD do MySQL ou MariaDB
CREATE DATABASE aulaead;
SHOW DATABASES;

#Criando usuários no SGBD do MySQL ou MariaDB
CREATE USER 'aulaead' IDENTIFIED BY 'aulaead';

#Aplicando as permissões de acesso ao Banco de Dados AulaEAD no SGBD do MySQL ou MariaDB
GRANT USAGE ON *.* TO 'aulaead' IDENTIFIED BY 'aulaead';
GRANT ALL PRIVILEGES ON aulaead.* TO 'aulaead';
FLUSH PRIVILEGES;
EXIT

##Acessando o SGBD do MySQL ou MariaDB com o usuário AulaEAD
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

#Ordendando as informações das Tabelas no SGBD do MySQL ou MariaDB
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
