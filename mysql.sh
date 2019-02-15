#Autor: Robson Vaamonde
#Site: www.procedimentosemti.com.br
#Facebook: facebook.com/ProcedimentosEmTI
#Facebook: facebook.com/BoraParaPratica
#YouTube: youtube.com/BoraParaPratica
#Data de criação: 13/02/2019
#Data de atualização: 15/02/2019
#Versão: 0.02

#Instalando o SGBD MySQL (ou MariaDB)
sudo apt update && sudo apt install mysql-server mysql-client mysql-common
sudo apt update && sudo apt install mariadb-server mariadb-client mariadb-common

#Gerenciadores de Banco de Dados MySQL ou MariaDB
sudo apt update && sudo apt install mysql-workbench emma phpmyadmin (precisa do Apache2)

#Aplicando as políticas de segurança no SGDB MySQL (ou MariaDB)
sudo mysql_secure_installation
1. Connecting to MySQL using a blank password (Press y|Y for Yes, any other key for No:) <Enter>
2. New password root: pti@2018 <Enter>
3. Re-enter new password root: pti@2018 <Enter>
4. Remove anonymous users? (Press y|Y for Yes, any other key for No:) y <Enter>
5. Disalow root login remotely (Press y|Y for Yes, any other key for No:) <Enter>
6. Remove test database and access to it? (Press y|Y for Yes, any other key for No:) <Enter>
7. Reload privilege tables now? (Press y|Y for Yes, any other key for No:) y <Enter>

#Acessando o SGBD do MySQL com o usuário root do MySQL
sudo mysql -u root -p

#Verificando os Bancos de Dados Existentes
SHOW DATABASES;

#Criando o nosso Banco de Dados AulaEAD
CREATE DATABASE aulaead;

#Criando usuários no SGDB MySQL
CREATE USER 'aulaead' IDENTIFIED BY 'aulaead';

#Aplicando as permissões de acesso ao Banco de Dados AulaEAD
GRANT USAGE ON *.* TO 'aulaead' IDENTIFIED BY 'aulaead';
GRANT ALL PRIVILEGES ON aulaead.* TO 'aulaead';
FLUSH PRIVILEGES;
EXIT

##Acessando o SGBD do MySQL
sudo mysql -u aulaead -p

#Utilizando o Banco e Dados AulaEAD
SHOW DATABASES;
USE aulaead;

#Criando a Tabela Alunos e Verificando suas Informações
CREATE TABLE alunos(
	matricula VARCHAR(6) NOT NULL,
	nome VARCHAR(6) NOT NULL,
	cidade VARCHAR(30) NULL,
	PRIMARY KEY(matricula));
DESC alunos;
SELECT * FROM alunos;

#Criando a Tabela Cursos e Verificando suas Informações
CREATE TABLE cursos(
	codcurso VARCHAR(6) NOT NULL,
	nomecurso VARCHAR(30) NOT NULL,
	PRIMARY KEY(codcurso));
DESC cursos;
SELECT * FROM cursos;

#Criando a Tabela Matriculas e Verificando suas Informações
CREATE TABLE matriculas(
	matricula VARCHAR(6) NOT NULL,
	codcurso VARCHAR(6) NOT NULL);
DESC matriculas;
SELECT * FROM matriculas;

#Visualizando as Tabelas Criadas
SHOW TABLES;

#Inserindo dados dentro da Tabela Alunos
INSERT INTO alunos VALUES ('000001', 'Robson Vaamonde', 'Guarulhos');
INSERT INTO alunos VALUES ('000002', 'Leandro Ramos', 'São Paulo');
INSERT INTO alunos VALUES ('000003', 'José de Assis', 'São Paulo');
SELECT * FROM alunos;

#Inserindo dados dentro da Tabela Cursos
INSERT INTO cursos VALUES ('000001', 'Debian Linux');
INSERT INTO cursos VALUES ('000002', 'Ubuntu Linux');
INSERT INTO cursos VALUES ('000003', 'CentOS Linux');
SELECT * FROM cursos;

#Inserindo dados dentro da Tabela Matriculas
INSERT INTO matriculas VALUES ('000001', '000001');
INSERT INTO matriculas VALUES ('000001', '000002');
INSERT INTO matriculas VALUES ('000002', '000003');
INSERT INTO matriculas VALUES ('000003', '000001');
SELECT * FROM matriculas;

#Verificando informações mais detalhes das Tabelas;
SELECT matricula, nome FROM alunos;
SELECT * FROM matriculas WHERE codcurso = '000001';
SELECT * FROM alunos WHERE cidade LIKE 'S%';
SELECT * FROM alunos WHERE nome LIKE '%a%' AND cidade = 'São Paulo';
SELECT COUNT(*) FROM alunos;

#Ordendando as informações das Tabelas
SELECT * FROM cursos ORDER BY codcurso DESC;

#Agrupando os valores das Tabelas
SELECT codcurso FROM matriculas GROUP BY codcurso;
SELECT codcurso, COUNT(*) FROM matriculas GROUP BY codcurso;

#Juntando Tabelas para consultas integradas
SELECT * FROM cursos JOIN matriculas;
SELECT * FROM cursos JOIN matriculas ON cursos.codcurso = matriculas.codcurso;
SELECT cursos.nomecurso, matriculas.matricula FROM cursos JOIN matriculas ON cursos.codcurso = matriculas.codcurso;
SELECT nomecurso, COUNT(*) FROM cursos JOIN matriculas ON cursos.codcurso = matriculas.codcurso GROUP BY nomecurso;

#Alterando uma Tabela e adicionando uma nova Coluna
ALTER TABLE matriculas ADD COLUMN codmatricula VARCHAR(6) NOT NULL FIRST;
DESC matriculas;
SELECT * FROM matriculas;

#Atualizando a Tabela com novos valores em uma Coluna
UPDATE matriculas SET codmatricula='000001' WHERE matricula='000001' AND codcurso='000001';
UPDATE matriculas SET codmatricula='000002' WHERE matricula='000001' AND codcurso='000002';
UPDATE matriculas SET codmatricula='000003' WHERE matricula='000002';				
UPDATE matriculas SET codmatricula='000004' WHERE matricula='000003';
SELECT * FROM matriculas;
UPDATE matriculas SET codcurso='000003' WHERE codmatricula='000001';

#Fazendo Backup da Base de Dados do MySQL
mysqldump -u root -p aulaead > aulaead.sql
mysqldump -u root -p aulaead < aulaead.sql

#Deletando registros em uma Tabela;
DELETE FROM matriculas WHERE matricula='000001';
SELECT * FROM matriculas;
				
#Deletando uma Tabela
DROP TABLE matriculas;
SHOW TABLES;

#Deletando um Banco de Dados
DROP DATABASE aulaead;
SHOW DATABASES;
