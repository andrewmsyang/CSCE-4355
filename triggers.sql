CREATE OR REPLACE FUNCTION AlterDeleteOnPlayers()
	RETURNS TRIGGER 
LANGUAGE PLPGSQL AS $$
BEGIN
    UPDATE tblPlayers
    SET p_active = FALSE
    WHERE OLD.p_id = p_id;
    
    RETURN NEW;
END $$;


DROP TRIGGER IF EXISTS PreventDeleteOnPlayers ON tblPlayers;

CREATE TRIGGER PreventDeleteOnPlayers
BEFORE DELETE ON tblPlayers
	FOR EACH ROW
  	EXECUTE PROCEDURE AlterDeleteOnPlayers();

-- -----------------------------

CREATE OR REPLACE FUNCTION prohibitDeleteOnGames()
    RETURNS TRIGGER 
LANGUAGE PLPGSQL AS $$
BEGIN
    RETURN NULL;
END $$;


DROP TRIGGER IF EXISTS preventDeleteOnGames ON tblGames;

CREATE TRIGGER preventDeleteOnGames
BEFORE DELETE ON tblGames
    FOR EACH ROW
    EXECUTE PROCEDURE prohibitDeleteOnGames();

-- -------------------------------

CREATE OR REPLACE FUNCTION prohibitDeleteOnRounds()
    RETURNS TRIGGER 
LANGUAGE PLPGSQL AS $$
BEGIN
    RETURN NULL;
END $$;


DROP TRIGGER IF EXISTS preventDeleteOnRounds ON tblRounds;

CREATE TRIGGER preventDeleteOnRounds
BEFORE DELETE ON tblRounds
    FOR EACH ROW
    EXECUTE PROCEDURE prohibitDeleteOnRounds();


-- -------------------------------

CREATE TABLE tblPlayersLog(pl_id INTEGER PRIMARY KEY, pl_time TIMESTAMP, pl_user text, TG_OP text, 
                                p_id_OLD INTEGER, p_id_NEW INTEGER);

CREATE OR REPLACE FUNCTION logChangesOnGames()
    RETURNS TRIGGER 
LANGUAGE PLPGSQL AS $$
BEGIN
    RAISE NOTICE 'Change Logged on tblGames.';
    
    INSERT INTO tblPlayersLog(pl_id, pl_time, pl_user, TG_OP, 
                                p_id_OLD, p_id_NEW)
    VALUES( NEXTVAL('rpsSequence'), CURRENT_TIMESTAMP, 
            CURRENT_USER, TG_OP, NULL, NULL);

    RETURN NEW;
END $$;

DROP TRIGGER IF EXISTS ChangesOnGames ON tblGames;

CREATE TRIGGER ChangesOnGames
BEFORE UPDATE ON tblGames
    FOR EACH ROW
    EXECUTE PROCEDURE logChangesOnGames();

-- -------------------------------
