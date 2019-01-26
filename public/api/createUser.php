<?php
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 'On');
$body = file_get_contents('php://input');
$body = json_decode($body,true);
if($body['password'] && $body['username']){
    $link = new mysqli('mysql.cs.iastate.edu', 'dbu309dk01', 'SwPjjbV9zw9','db309dk01');
    $query = $link->prepare('INSERT INTO user (username,password,permission,currency) VALUES (?,?,?,?)');
    $username = $body['username'];
    $password = $body['password'];
    $permission = 0;
    $currency = 0;
    $query->bind_param("ssii",$username,$password,$permission,$currency);
    $query->execute();

    $user_id = mysqli_insert_id($link);

    $link = new mysqli('mysql.cs.iastate.edu', 'dbu309dk01', 'SwPjjbV9zw9','db309dk01');
    $query = $link->prepare('INSERT INTO solitaire_state (tableu_up,tableu_down,foundation,waste,stockpile,score,user_id) VALUES (?,?,?,?,?,?,?)');
    $tableu_up = json_encode([]);
    $tableu_down = json_encode([]);
    $foundation = json_encode([]);
    $waste = json_encode([]);
    $stockpile = json_encode([]);
    $score = 0;
    $query->bind_param("sssssii",$tableu_up,$tableu_down,$foundation,$waste,$stockpile,$score,$user_id);
    $query->execute();

    $result = [
        'error' => 0
    ];
}else{
    $result = [
        'error' => 2
    ];
}
echo json_encode($result);
