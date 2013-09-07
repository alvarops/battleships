<?php
header('Content-Type: text/json, charset=utf-8');
$game['boardX']=6;
$game['boardY']=6;
$game['status']='finished';


$a = array();
$a[]=array('x' => 1,'y' => 0, 'status' => 'miss', 'shipType' => '', 'shipId' => '', 'game' => 'on' ); 
$a[]=array('x' => 1,'y' => 1, 'status' => 'miss', 'shipType' => '', 'shipId' => '', 'game' => 'on' ); 
$a[]=array('x' => 1,'y' => 1, 'status' => 'miss', 'shipType' => '', 'shipId' => '', 'game' => 'on' ); 


$a[]=array('x' => 5,'y' => 0, 'status' => 'hit', 'shipType' => 'Submarine', 'shipId' => 'submarine1', 'game' => 'on' );
$a[]=array('x' => 4,'y' => 0, 'status' => 'hit', 'shipType' => 'Submarine', 'shipId' => 'submarine1', 'game' => 'on' );
$a[]=array('x' => 3,'y' => 0, 'status' => 'hitsunk', 'shipType' => 'Submarine', 'shipId' => 'submarine1', 'game' => 'on' );

$a[]=array('x' => 0,'y' => 0, 'status' => 'hit', 'shipType' => 'Battleship', 'shipId' => 'battleship1', 'game' => 'on' );
$a[]=array('x' => 0,'y' => 1, 'status' => 'hit', 'shipType' => 'Battleship', 'shipId' => 'battleship1', 'game' => 'on' );
$a[]=array('x' => 0,'y' => 2, 'status' => 'hit', 'shipType' => 'Battleship', 'shipId' => 'battleship1', 'game' => 'on' );
$a[]=array('x' => 0,'y' => 3, 'status' => 'hitsunk', 'shipType' => 'Battleship', 'shipId' => 'battleship1', 'game' => 'on' );

$a[]=array('x' => 4,'y' => 5, 'status' => 'hit', 'shipType' => 'Cruser', 'shipId' => 'cruser1', 'game' => 'on' );
$a[]=array('x' => 5,'y' => 5, 'status' => 'hitsunk', 'shipType' => 'Cruser', 'shipId' => 'cruser1', 'game' => 'on' );

$a[]=array('x' => 5,'y' => 2, 'status' => 'hitsunk', 'shipType' => 'Boat', 'shipId' => 'boat1', 'game' => 'on' );

$a[]=array('x' => 0,'y' => 5, 'status' => 'hitsunk', 'shipType' => 'Boat', 'shipId' => 'boat2', 'game' => 'finished' );

$a[]=array('x' => 2,'y' => 2, 'status' => 'hit', 'shipType' => 'Carrier', 'shipId' => 'carrier1', 'game' => 'on' );
$a[]=array('x' => 3,'y' => 2, 'status' => 'miss', 'shipType' => '', 'shipId' => '', 'game' => 'on' );  
$a[]=array('x' => 2,'y' => 1, 'status' => 'hit', 'shipType' => 'Carrier', 'shipId' => 'carrier1', 'game' => 'on' );
$a[]=array('x' => 2,'y' => 3, 'status' => 'hit', 'shipType' => 'Carrier', 'shipId' => 'carrier1', 'game' => 'on' );
$a[]=array('x' => 2,'y' => 4, 'status' => 'hit', 'shipType' => 'Carrier', 'shipId' => 'carrier1', 'game' => 'on' );  
$a[]=array('x' => 2,'y' => 5, 'status' => 'hitsunk', 'shipType' => 'Carrier', 'shipId' => 'carrier1', 'game' => 'on' ); 


$b = array();
$b[]=array('x' => 0,'y' => 0, 'status' => 'miss', 'shipType' => '', 'shipId' => '', 'game' => 'on' ); 
$b[]=array('x' => 0,'y' => 1, 'status' => 'miss', 'shipType' => '', 'shipId' => '', 'game' => 'on' ); 


$game['players'][0]['name']='Test player 1';
$game['players'][0]['id']=1;
$game['players'][0]['shots']=$a;

$game['players'][1]['name']='Test player 2';
$game['players'][1]['id']=2;
$game['players'][1]['shots']=$b;

echo json_encode($game,true);

?>