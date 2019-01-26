<?php
$key = 'bngjijsgrjkhgjfdsf';
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 'On');
$body = file_get_contents('php://input');
$body = json_decode($body,true);
if($body['key']==$key && $body['game_state_id'] && $body['username']){
    $link = new mysqli('mysql.cs.iastate.edu', 'dbu309dk01', 'SwPjjbV9zw9','db309dk01');
    $query = $link->prepare('INSERT INTO player_state (username,game_state_id,bet,insurance,cards) VALUES (?,?,?,?,?)');
    $username = $body['username'];
    $game_state_id = $body['game_state_id'];
    $bet = 0;
    $insurance = 0;
    $cards = json_encode([]);
    $query->bind_param("siiis",$username,$game_state_id,$bet,$insurance,$cards);
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
