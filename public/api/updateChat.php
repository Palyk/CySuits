<?php
$key = 'bngjijsgrjkhgjfdsf';
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 'On');
$body = file_get_contents('php://input');
$body = json_decode($body,true);
if($body['key']==$key){
    $link = new mysqli('mysql.cs.iastate.edu', 'dbu309dk01', 'SwPjjbV9zw9','db309dk01');
    $query = $link->prepare('INSERT INTO message (game_state_id,username,text,time) VALUES (?,?,?,?)');

    foreach($body['messages'] as $message){
        $game_state_id = $body['game_state_id'];
        $username = $message['username'];
        $text = $message['text'];
        $time = $message['time'];
        $query->bind_param("isss",$game_state_id,$username,$text,$time);
        $query->execute();
    }
    $result = [
        'error' => 0
    ];
}else{
    $result = [
        'error' => 2
    ];
}
echo json_encode($result);
