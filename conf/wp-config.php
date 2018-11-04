<?php
/**
 * Modificado por: Robson Vaamonde
 * Site: www.procedimentosemti.com.br
 * Facebook: facebook.com/ProcedimentosEmTI
 * Facebook: facebook.com/BoraParaPratica
 * YouTube: youtube.com/BoraParaPratica
 * Data de criação: 31/05/2016
 * Data de atualização: 30/07/2016
 * Versão: 0.4
 * Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
 * Kernel >= 4.4.x
*/
 
/** Nome da base de dados do WordPress*/
define('DB_NAME', 'wordpress');

/** Nome do usuário da Base de Dados do MySQL para WordPress*/
define('DB_USER', 'wordpress');

/** Senha do usuário da Base de Dados do MySQL para WordPress*/
define('DB_PASSWORD', 'wordpress');

/** Nome do Servidor do MySQL que é o Localhost*/
define('DB_HOST', 'localhost');

/** Configuração dos caracteres da Base de Dados, deixar o padrão*/
define('DB_CHARSET', 'utf8');

/** Configuração do Collate, deixar o padrão*/
define('DB_COLLATE', '');

/** Prefixo padrão das tabelas do Wordpress*/
$table_prefix  = 'wp_';

/** Configuração do Debug do Wordpress, deixar desativado (padrão false)*/
define('WP_DEBUG', false);

/** Bloco de configuração Global, deixar o padrão*/

/**#@+ */
define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
define('LOGGED_IN_KEY',    'put your unique phrase here');
define('NONCE_KEY',        'put your unique phrase here');
define('AUTH_SALT',        'put your unique phrase here');
define('SECURE_AUTH_SALT', 'put your unique phrase here');
define('LOGGED_IN_SALT',   'put your unique phrase here');
define('NONCE_SALT',       'put your unique phrase here');
/**#@-*/

if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');
require_once(ABSPATH . 'wp-settings.php');
