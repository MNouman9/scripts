#!/usr/bin/php

<?php

$websiteArray = array("URL",
					"URL");

$serverArray = array("IP:PORT",
				"IP:PORT");

foreach ($websiteArray as $website){
	foreach ($serverArray as $server) {

		$cURLConnection = curl_init();

		curl_setopt($cURLConnection, CURLOPT_URL, $server);
		curl_setopt($cURLConnection, CURLOPT_HTTPHEADER, array(
		    "Host: $website",
		    "x-forwarded-proto: https"
		));
		curl_setopt($cURLConnection, CURLOPT_CUSTOMREQUEST, 'GET');
		curl_setopt($cURLConnection, CURLOPT_NOBODY, TRUE);
		curl_setopt($cURLConnection, CURLOPT_RETURNTRANSFER, TRUE);
		curl_setopt($cURLConnection, CURLOPT_FOLLOWLOCATION, FALSE);

		curl_exec($cURLConnection);
		$httpCode = curl_getinfo($cURLConnection, CURLINFO_HTTP_CODE);
		curl_close($cURLConnection);

		//echo $httpCode;
		if($httpCode == 200) {
			echo "$website is UP on Server $server\n";
		}
		else {
			echo "$website is DOWN on Server $server\n";
		}
	}
	echo "\n";
}
