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
            
            $player = $_POST['player'];
            
            $com_string = 'CALL procInsertPlayer($1, NULL)';
            
            // calling the procedure to insert player. 
            // See documentation at: https://www.php.net/manual/en/function.pg-query-params
			$result = pg_query_params($db_connection, $com_string, array($player))
				or die('Unable to CALL stored procedure: ' . pg_last_error());

            // get the output parameter
            $row = pg_fetch_row($result);
			$errLvl = $row[0];	// this is the first INOUT parm. A 2nd would be $row[1] (if
                                // we had a second one.)

            // Parse the output:
            if ($errLvl == '0')
            {
                $outPut = 'The player ' . $player . ' was successfully inserted.';
            }
            elseif ($errLvl == '1')
                {
                    $outPut = 'The parameter was NULL.';
                }
                else
                {
                    $outPut = $player . ' is already in use.';
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
        