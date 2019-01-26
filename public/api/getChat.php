<?php
$key = 'bngjijsgrjkhgjfdsf';
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 'On');
$body = file_get_contents('php://input');
$body = json_decode($body,true);
if($body['key']==$key){
    $link = new mysqli('mysql.cs.iastate.edu', 'dbu309dk01', 'SwPjjbV9zw9','db309dk01');
    if($body['game_state_id']){
        $id = $body['game_state_id'];
    }else{
        $id = 0;
    }
    $query = $link->prepare('SELECT username,text,time FROM message AS m WHERE m.game_state_id=?');

    $query->bind_param("s",$id);
    $query->execute();
    $query->bind_result($username,$text,$time);

    $result = [
        'messages' => [],
        'error' => 0
    ];
    while ($query->fetch()) {
        array_push($result['messages'],[
            'username' => $username,
            'text' => $text,
            'time' => $time
        ]);
    }
}else{
    $result = [
        'error' => 2
    ];
}
echo json_encode($result);
