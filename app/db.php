<?php

function db_connect (){
    $dsn = DB['dsn'];
    $user = DB['user'];
    $pass = DB['pass'];
    $options = array( PDO :: MYSQL_ATTR__INIT_COMMAND => 'SET NAMES utf8');

    try{
        $db = new PDO($dsn, $user, $pass,  $options);

    }catch ( PDOException $e){
        echo '<p>Error!:<mark>'. $e->getMessage().'</mark></p>';
        die();
    }
}

function db_query ($sql, $data = array(), $is_search = false, $search_one = false) {
    $db = db_connect();

    $mysql = $db->prepare( $sql );
    $mysql->execute( $data );

    if ($is_search){
        /*Para consultas de tipo READ */
        if($search_one){
            /*Para Buscar un solo Registro */
        }else{
            /*Para todos los registros */
        }
    }else{
        /*Para consultas de tipo , CREATE, DELETE y UPDATE */
        $db = null;
        return true;

    }
}