<?php
$key = 'bngjijsgrjkhgjfdsf';
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 'On');
$body = file_get_contents('php://input');
$body = json_decode($body,true);
$result = [];
if($body['username']  && $body['password']){
    $link = new mysqli('mysql.cs.iastate.edu', 'dbu309dk01', 'SwPjjbV9zw9','db309dk01');
    $query = $link->prepare('SELECT password,id FROM user AS u WHERE u.username=?');
    $username = $body['username'];
    $query->bind_param("s",$username);
    $query->execute();
    $query->bind_result($password,$id);

    if($query->fetch()){
        if($password == $body['password'])
        $result = [
            'id' => $id,
            'key' => $key,
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
