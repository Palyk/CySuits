<?php
$key = 'bngjijsgrjkhgjfdsf';
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 'On');
$body = file_get_contents('php://input');
$body = json_decode($body,true);
$link = new mysqli('mysql.cs.iastate.edu', 'dbu309dk01', 'SwPjjbV9zw9','db309dk01');
$query = $link->prepare('SELECT id,game_type FROM game_state');
$query->execute();
$query->bind_result($id,$game_type);
$result = [
    'rooms' => [],
    'error' => 0
];

while ($query->fetch()) {
    array_push($result['rooms'],[
        'id' => $id,
        'game_type' => $game_type,
        'players' => []
    ]);
}

$link = new mysqli('mysql.cs.iastate.edu', 'dbu309dk01', 'SwPjjbV9zw9','db309dk01');
$query = $link->prepare('SELECT game_state_id,username FROM player_state');
$query->execute();
$query->bind_result($game_state_id,$username);

while ($query->fetch()) {
    foreach($result['rooms'] as $i => $room){
        if($room['id']==$game_state_id){
            array_push($result['rooms'][$i]['players'],$username);
        }
    }
}

echo json_encode($result);
