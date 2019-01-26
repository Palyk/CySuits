<?php
$key = 'bngjijsgrjkhgjfdsf';
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 'On');
$body = file_get_contents('php://input');
$body = json_decode($body,true);
if($key==$body['key'] && $body['user_id']){
	$link = new mysqli('mysql.cs.iastate.edu', 'dbu309dk01', 'SwPjjbV9zw9','db309dk01');
	$query = $link->prepare('SELECT tableu_up,tableu_down,foundation,waste,stockpile,score FROM solitaire_state AS s WHERE s.user_id=?');
	$user_id = $body['user_id'];
	$query->bind_param("i",$user_id);
	$query->execute();
    $query->bind_result($tableu_up,$tableu_down,$foundation,$waste,$stockpile,$score);

    if($query->fetch()){
        $result = [
            'tableu_up' => $tableu_up,
            'tableu_down' => $tableu_down,
            'foundation' => $foundation,
            'waste' => $waste,
            'stockpile' => $stockpile,
            'score' => $score,
            'error' => 0
        ];
    }else{
        $result = [
            'error' => 1
        ];
    }
}else{
    $result = [
        'error' => 2
    ];
}
echo json_encode($result);
