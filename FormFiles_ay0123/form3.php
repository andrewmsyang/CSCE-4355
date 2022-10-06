<!DOCTYPE html>
<html>
    <body>
        <?php
            require 'include/connect.php';
            // I chose to put my "include" directory as a subdirectory
            // of my web folder.  Since it contains password information,
            // it would likely be better placed in a completely different
            // path using an absolute address.
            
            if (! $db_connection )
            {
                die('Connection failed');
            }
            
            $gameId = $_POST['gameId'];
            $token1 = $_POST['token1'];
            $token2 = $_POST['token2'];
            
            $com_string = 'CALL procInsertRound($1, $2, $3, NULL)';
            
            // calling the procedure to insert round. 
			$result = pg_query_params($db_connection, $com_string, array($gameId, $token1, $token2))
				or die('Unable to CALL stored procedure: ' . pg_last_error());

            // get the output parameter
            $row = pg_fetch_row($result);
			$errLvl = $row[0];	// this is the first INOUT parm. A 2nd would be $row[1] (if
                                // we had a second one.)

            // Parse the output:
            if ($errLvl == '0')
            {
                $outPut = 'The round of game ' . $gameId . ' (' . $token1 . ', ' . $token2 . ') was successfully inserted.';
            }
            elseif ($errLvl == '1')
            {
                $outPut = 'The parameter token1 or token2 is NULL.';
            }
            elseif ($errLvl == '2')
            {
                $outPut = 'Token must be a value of \'R\', \'P\' or \'S\'.';
            }
            elseif ($errLvl == '3')
            {
                $outPut = 'The game id is invalid.';
            }
            elseif ($errLvl == '4')
            {
                $outPut = 'The game not exists.';
            }
            else
            {
                $outPut = 'Unknow error occured.';
            }

			pg_close($db_connection);
        ?>
        
        <!-- Display the output & go back to start -->
        <form action="/index.html">
            <div>
                <textarea class="message" name="feedback" text-align: center;
                        id="feedback" rows=1 cols=80 readonly="enabled">
                    <?php echo $outPut; ?>
                </textarea>
            </div>
                <button type="submit">Return</button>
        </form> 
	</body>
</html>
        