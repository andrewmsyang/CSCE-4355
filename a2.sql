CREATE OR REPLACE PROCEDURE procInsertGame ( parm_p1_id VARCHAR(16),
											parm_p2_id VARCHAR(16),
											INOUT errLvl SMALLINT)
LANGUAGE plpgsql
AS  $$
DECLARE
	temp_id VARCHAR(16);
BEGIN
    errLvl:=0;
	IF parm_p1_id > parm_p2_id
	THEN 
		temp_id := parm_p1_id;
		parm_p1_id := parm_p2_id;
		parm_p2_id := temp_id;
	END IF;
	IF parm_p1_id IS NULL OR LENGTH(parm_p1_id)=0
	THEN
        errLvl:=1;
	ELSIF parm_p2_id IS NULL OR LENGTH(parm_p2_id)=0
	THEN
        errLvl:=2;	
	ELSIF parm_p1_id = parm_p2_id
	THEN
        errLvl:=3;
	ELSIF
		NOT EXISTS (SELECT * 
					FROM tblPlayers
					WHERE p_id=parm_p1_id)
		THEN errLvl:=4;
	ELSIF
		NOT EXISTS (SELECT * 
					FROM tblPlayers
					WHERE p_id=parm_p2_id)
		THEN errLvl:=4;
	ELSIF
		EXISTS (SELECT * 
				FROM tblGames
				WHERE p1_id=parm_p1_id
				AND p2_id=parm_p2_id)
		THEN errLvl:=5;
	ELSE
		INSERT INTO tblGames(g_id, g_timestamp, p1_id, p2_id)
		VALUES (NEXTVAL('rpsSequence'), CURRENT_TIMESTAMP, parm_p1_id, parm_p2_id);
	END IF;
    COMMIT; 
END $$;

CREATE OR REPLACE PROCEDURE procInsertRound (parm_g_id INTEGER,
											parm_g_token1 CHAR(1),
											parm_g_token2 CHAR(1),
											INOUT errLvl SMALLINT)
LANGUAGE plpgsql
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