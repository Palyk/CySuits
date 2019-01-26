<?php
$key = 'bngjijsgrjkhgjfdsf';
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 'On');
$body = file_get_contents('php://input');
$body = json_decode($body,true);
if($body['key']==$key && $body['id']){
    $link = new mysqli('mysql.cs.iastate.edu', 'dbu309dk01', 'SwPjjbV9zw9','db309dk01');
    $query = $link->prepare('SELECT currency,permission FROM user AS u WHERE u.id=?');
    $id = $body['id'];
    $query->bind_param("i",$id);
    $query->execute();
    $query->bind_result($currency,$permission);

    if($query->fetch()){
        $result = [
            'currency' => $currency,
            'permission' => $permission,
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
