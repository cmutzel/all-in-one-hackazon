<?php
$arg1 = $argv[1];

echo hash_password($arg1);

function hash_password($password){
	$salt = uniqid(rand());
	return hash('md5', $password.$salt).':'.$salt;
}

function random_string() {
	return str_replace(array('+', '='), array('.', ''),
		        base64_encode(pack('N9', mt_rand(), mt_rand(), mt_rand(), mt_rand(), mt_rand(), mt_rand(), mt_rand(), mt_rand(), mt_rand())));
}