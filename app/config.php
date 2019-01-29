<?php
define('ENV', 'dev');

define('DB', array(
    'dsn' => (ENV === 'dev') ? 'mysql:host=localhost;dbname=edtickets' : 'mysql:host=localhost;dbname=edtickets',
    'user' => (ENV === 'dev') ? 'root' : 'root',
    'pass' => (ENV === 'dev') ? '' : ''
));

?>