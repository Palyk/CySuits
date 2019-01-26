<?php
$key = 'bngjijsgrjkhgjfdsf';
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 'On');
$body = file_get_contents('php://input');
$body = json_decode($body,true);
if($body['key']==$key && $body['id']){
    $link = new mysqli('mysql.cs.iastate.edu', 'dbu309dk01', 'SwPjjbV9zw9','db309dk01');
    $query = $link->prepare('UPDATE user SET username=?,password=?,currency=?,permission=? WHERE id=?');
    $username = $body['username'];
    $password = $body['password'];
    $currency = $body['currency'];
    $permission = $body['permission'];
    $id = $body['id'];

    $query->bind_param("ssiii",$username,$password,$currency,$permission,$id);
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
