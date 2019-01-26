<?php
$key = 'bngjijsgrjkhgjfdsf';
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 'On');
$body = file_get_contents('php://input');
$body = json_decode($body,true);
if($body['key']==$key){
    $link = new mysqli('mysql.cs.iastate.edu', 'dbu309dk01', 'SwPjjbV9zw9','db309dk01');
    $query = $link->prepare('INSERT INTO game_state (dealer_cards,minimum_bet,game_type,big_blind,little_blind,pot,player_current) VALUES (?,?,?,?,?,?,?)');
    $dealer_cards = json_encode([]);
    $minimum_bet = 0;
    $game_type = 0;
    $big_blind = 0;
    $little_blind = 0;
    $pot = 0;
    $player_current = 0;
    $query->bind_param("siiiiii",$dealer_cards,$minimum_bet,$game_type,$big_blind,$little_blind,$pot,$player_current);
    $query->execute();

    $id = mysqli_insert_id($link);

    $result = [
        'id' => $id,
        'error' => 0
    ];
}else{
    $result = [
        'error' => 2
    ];
}
echo json_encode($result);
