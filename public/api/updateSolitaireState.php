<?php
$key = 'bngjijsgrjkhgjfdsf';
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 'On');
$body = file_get_contents('php://input');
$body = json_decode($body,true);
if($body['key']==$key && $body['user_id']){
    $link = new mysqli('mysql.cs.iastate.edu', 'dbu309dk01', 'SwPjjbV9zw9','db309dk01');
    $query = $link->prepare('UPDATE solitaire_state SET tableu_up=?,tableu_down=?,foundation=?,waste=?,stockpile=?,score=? WHERE user_id=?');

    $tableu_up = $body['tableu_up'];
    $tableu_down = $body['tableu_down'];
    $foundation = $body['foundation'];
    $waste = $body['waste'];
    $stockpile = $body['stockpile'];
    $score = $body['score'];
    $user_id = $body['user_id'];
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
