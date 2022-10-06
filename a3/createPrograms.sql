CREATE OR REPLACE PROCEDURE procInsertPlayer( parm_p_id VARCHAR(16), 
                                               INOUT errLvl SMALLINT)
LANGUAGE plpgsql SECURITY DEFINER
AS  $$
DECLARE
    -- local variables (if any) are declared here
BEGIN
    errLvl:=0;  -- *I* set the error parameter to zero and let it fall through
    
    IF parm_p_id IS NULL OR LENGTH(parm_p_id)=0 -- NULL or zero length
    THEN
        errLvl:=1;
    ELSIF 
        EXISTS  (SELECT *
                 FROM tblPlayers
                 WHERE p_id=parm_p_id)
        THEN errLvl:=2;                 -- already there
        ELSE
            INSERT INTO tblPlayers(p_id)
            VALUES(parm_p_id);
    END IF;
    COMMIT;        
END $$;

GRANT EXECUTE ON PROCEDURE procInsertPlayer(VARCHAR(16), INOUT SMALLINT) TO PUBLIC;

CREATE OR REPLACE PROCEDURE procInsertGame( parm_p1_id VARCHAR(16),
											parm_p2_id VARCHAR(16),
											INOUT errLv1 SMALLINT )
LANGUAGE plpgsql SECURITY DEFINER
AS  $$
DECLARE
	local_p_id VARCHAR(16);
BEGIN
	errLv1:=0;
	
	IF parm_p1_id > parm_p2_id
	THEN 
		local_p_id:=parm_p1_id;
		parm_p1_id:=parm_p2_id;
		parm_p2_id:=local_p_id;
	END IF;
	
	IF parm_p1_id IS NULL OR LENGTH(parm_p1_id)=0
	THEN errLv1:=1;
	ELSIF parm_p2_id IS NULL OR LENGTH(parm_p2_id)=0
		THEN errLv1:=2;
		ELSIF parm_p1_id=parm_p2_id
			THEN errLv1:=3;
			ELSIF 	NOT EXISTS (SELECT * FROM tblPlayers
								WHERE p_id=parm_p1_id)
						OR
					NOT EXISTS (SELECT * FROM tblPlayers
								WHERE p_id=parm_p2_id)
				THEN	errLv1:=4;
				ELSIF EXISTS (SELECT * FROM tblGames
								WHERE p1_id=parm_p1_id AND p2_id=parm_p2_id)
					THEN errLv1:=5;
					ELSE
						INSERT INTO tblGames(g_id, g_timestamp, p1_id, p2_id)
						VALUES ( NEXTVAL('rpsSequence'), CURRENT_TIMESTAMP,
								parm_p1_id, parm_p2_id);
	END IF;
END $$;

GRANT EXECUTE ON PROCEDURE procInsertGame(VARCHAR(16), arm_p2_id VARCHAR(16),
											INOUT errLv1 SMALLINT) TO PUBLIC;
		

CREATE OR REPLACE FUNCTION funcGameID (parm_p1_id VARCHAR(16), parm_p2_id VARCHAR(16))
	RETURNS INTEGER
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
	lvReturn INTEGER;
	lv_p_id VARCHAR(16);
BEGIN
	IF parm_p1_id>parm_p2_id
	THEN
		lv_p_id:=parm_p1_id;
		parm_p1_id:=parm_p2_id;
		parm_p2_id:=lv_p_id;
	END IF;
	
	SELECT g_id INTO lvReturn
	FROM tblGames
	WHERE p1_id=parm_p1_id AND p2_id=parm_p2_id;
	
	IF lvReturn IS NULL
	THEN RETURN -1;
	ELSE RETURN lvReturn;
	END IF;
END $$;

GRANT EXECUTE ON FUNCTION funcGameID(VARCHAR(16), arm_p2_id VARCHAR(16)) TO PUBLIC;

CREATE OR REPLACE PROCEDURE procInsertRound (parm_g_id INTEGER,
											parm_g_token1 CHAR(1),
											parm_g_token2 CHAR(1),
											INOUT errLvl SMALLINT)
LANGUAGE plpgsql SECURITY DEFINER
AS  $$
DECLARE

BEGIN
	errLvl:=0;
	IF parm_g_token1 IS NULL OR parm_g_token2 IS NULL
	THEN
		errLvl:=1;
	ELSIF parm_g_token1 NOT IN ('R', 'P', 'S') OR parm_g_token2 NOT IN ('R', 'P', 'S')
	THEN
		errLvl:=2;
	ELSIF parm_g_id IS NULL OR parm_g_id < 0
	THEN
		errLvl:=3;
	ELSIF 
		NOT EXISTS (SELECT * 
				FROM tblGames
				WHERE parm_g_id=g_id)
	THEN
		errLvl:=4;
	ELSE
		INSERT INTO tblRounds(r_id, r_timestamp, g_id, r_token1, r_token2)
		VALUES ( NEXTVAL('rpsSequence'), CURRENT_TIMESTAMP, parm_g_id, parm_g_token1, parm_g_token2);
	END IF;
	COMMIT;
END $$;

GRANT EXECUTE ON PROCEDURE procInsertRound (parm_g_id INTEGER,
											parm_g_token1 CHAR(1),
											parm_g_token2 CHAR(1),
											INOUT errLvl SMALLINT) TO PUBLIC;