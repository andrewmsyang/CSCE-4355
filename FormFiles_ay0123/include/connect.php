<?php
    $host   = "host = 127.0.0.1";
    // Our web server and database server are on the same machine; this wouldn't be
    // a good idea in a production setting.
    
    $port   = "port = 5432";
    $dbname = "dbname = rps";
    
    $credentials = "user = somebody password=BlueSky";
    // Important: the user has *only* enough privileges to execute the routines
    // written for public users!
    
    // building connection argument string
    $connectionString = $host ." ". $dbname  ." ". $credentials;
		
    $db_connection = pg_connect("$connectionString");	// connect to DB

    // Wipe all of the strings to ensure we will send no information back.
    unset($host);
    unset($port);
    unset($dbname);
    unset($credentials);
    unset($connectionString);
?>