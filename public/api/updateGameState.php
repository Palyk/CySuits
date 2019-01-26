<?php
$key = 'bngjijsgrjkhgjfdsf';
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 'On');
$body = file_get_contents('php://input');
$body = json_decode($body,true);
if($body['key']==$key && $body['id']){
    $link = new mysqli('mysql.cs.iastate.edu', 'dbu309dk01', 'SwPjjbV9zw9','db309dk01');
    $query = $link->prepare('UPDATE game_state SET dealer_cards=?,minimum_bet=?,game_type=?,big_blind=?,little_blind=?,pot=?,player_current=?,host_id,timer WHERE id=?');
    $id = $body['id'];
    $dealer_cards = json_encode($body['dealer_cards']);
    $minimum_bet = $body['minimum_bet'];
    $game_type = $body['game_type'];
    $big_blind = $body['big_blind'];
    $little_blind = $body['little_blind'];
    $pot = $body['pot'];
    $player_current = $body['player_current'];
    $host_id = $body['host_id'];
    $timer = $body['timer'];
    $query->bind_param("siiiiiiiii",$dealer_cards,$minimum_bet,$game_type,$big_blind,$little_blind,$pot,$player_current,$host_id,$timer,$id);
    $query->execute();

    $link = new mysqli('mysql.cs.iastate.edu', 'dbu309dk01', 'SwPjjbV9zw9','db309dk01');
    $query = $link->prepare('UPDATE player_state SET username=?,game_state_id=?,bet=?,insurance=?,cards=? WHERE id=?');

    foreach($body['players'] as $player){
        $username = $player['username'];
        $bet = $player['bet'];
        $insurance = $player['insurance'];
        $cards = json_encode($player['cards']);
        $player_id = $player['id'];
        $query->bind_param("siiisi",$username,$id,$bet,$insurance,$cards,$player_id);
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
