<?php
$data = [
	'status' => 'ok',
	'server_admin' => $_SERVER['SERVER_ADMIN'],
	'date' => time()
];

header('Content-Type: application/json; charset=utf-8');
echo json_encode($data, JSON_PRETTY_PRINT);

