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
            
            $player1 = $_POST['player1'];
            $player2 = $_POST['player2'];
            
            $com_string = 'CALL procInsertGame($1, $2, NULL)';
            
            // calling the procedure to insert game. 
			$result = pg_query_params($db_connection, $com_string, array($player1, $player2))
				or die('Unable to CALL stored procedure: ' . pg_last_error());

            // get the output parameter
            $row = pg_fetch_row($result);
			$errLvl = $row[0];	// this is the first INOUT parm. A 2nd would be $row[1] (if
                                // we had a second one.)

            // Parse the output:
            if ($errLvl == '0')
            {
                $outPut = 'The game between ' . $player1 . ' and ' . $player2 . ' was successfully inserted.';
            }
            elseif ($errLvl == '1' || $errLvl == '2')
            {
                $outPut = 'The player1 or player2 parameter was NULL or EMPTY.';
            }
            elseif ($errLvl == '3')
            {
                $outPut = 'CANNOT create a game with same players.';
            }
            elseif ($errLvl == '4')
            {
                $outPut = 'The player1 or player2\'s ID not found.';
            }
            elseif ($errLvl == '5')
            {
                $outPut = 'The game between ' . $player1 . ' and ' . $player2 . ' is already in use.';
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
        