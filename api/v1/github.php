<?php

function PullRequest () {
	
	 include_once '../config.php'; 
	
	//github repo
    //https://github.com/php-curl-class/php-curl-class

	require '../lib/phpcurl/vendor/autoload.php';

	$curl = new Curl\Curl();

	//without SSL certificate
	$curl->setopt(CURLOPT_SSL_VERIFYPEER, FALSE);
	//follow the redirect
	$curl->setopt(CURLOPT_RETURNTRANSFER, FALSE);
	$curl->setopt(CURLOPT_FOLLOWLOCATION, TRUE);

	$curl->setHeader('Content-Type', 'application/json');
	$curl->get('https://github.com/klemens-morgenstern/boost-process/pulls?state=all', array(
		'user'     => 'GIT_USER',
		'password' => 'GIT_PASSWORD',
		)
	);

	if ($curl->error) {
		echo 'Error: ' . $curl->errorCode . ': ' . $curl->errorMessage . "\n";
	} else {
		echo 'Response:' . "\n";
		var_dump($curl->response);
	}

	//var_dump($curl->requestHeaders);
	//echo "\n\n\n\n\n\n";
	//var_dump($curl->responseHeaders);

	$curl->close();
}


function createBadge () {
	
	$baseUrl = 'https://img.shields.io/badge/';
	
	$subject = '<SUBJECT>';
    $status  = '<STATUS>';
	$color   = '<COLOR>';

	if ($subject == '<SUBJECT>' or $status == '<STATUS>' or $color == '<COLOR>')
      $url = $baseUrl.$subject.'-'.$status.'-'.$color.'.svg';

	return '<img src="'.$url.'" />';
}


echo "What is going on";
//PullRequest();
error_log("Du hast Mist gebaut!", 3, "error.log");

?>