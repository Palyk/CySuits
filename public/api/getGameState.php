<?php
$key = 'bngjijsgrjkhgjfdsf';
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 'On');
$body = file_get_contents('php://input');
$body = json_decode($body,true);
if($body['key']==$key && $body['id']){
    $link = new mysqli('mysql.cs.iastate.edu', 'dbu309dk01', 'SwPjjbV9zw9','db309dk01');
    $query = $link->prepare('SELECT dealer_cards,minimum_bet,game_type,big_blind,little_blind,pot,player_current,host_id,timer FROM game_state AS g WHERE g.id=?');
    $id = $body['id'];
    $query->bind_param("i",$id);
    $query->execute();
    $query->bind_result($dealer_cards,$minimum_bet,$game_type,$big_blind,$little_blind,$pot,$player_current,$host_id,$timer);

    if($query->fetch()){
        $result = [
            'dealer_cards' => json_decode($dealer_cards,true),
            'minimum_bet' => $minimum_bet,
            'game_type' => $game_type,
            'big_blind' => $big_blind,
            'little_blind' => $little_blind,
            'pot' => $pot,
            'player_current' => $player_current,
            'host_id' => $host_id,
            'timer' => $timer,
            'players' => [],
            'error' => 0
        ];
    }else{
        $result = [
            'error' => 1
        ];
    }

    $link = new mysqli('mysql.cs.iastate.edu', 'dbu309dk01', 'SwPjjbV9zw9','db309dk01');
    $query = $link->prepare('SELECT id,username,bet,insurance,cards FROM player_state AS p WHERE p.game_state_id=?');
    $query->bind_param("i",$id);
    $query->execute();
    $query->bind_result($player_id,$username,$bet,$insurance,$cards);

    while ($query->fetch()) {
        array_push($result['players'],[
            'id' => $player_id,
            'username' => $username,
            'bet' => $bet,
            'insurance' => $insurance,
            'cards' => json_decode($cards,true),
        ]);
    }
}else{
	$result = [
	    'error' => 2
    ];
}
echo json_encode($result);
