DROP DATABASE rps;
DROP DATABASE rpsprog;
DROP DATABASE somebody;

DROP USER somebody;
DROP USER rpsprog;

DROP ROLE rpsProgrammer;
DROP ROLE rpsUser;

CREATE DATABASE rps;

DROP SEQUENCE IF EXISTS rpsSequence;
--
DROP TABLE IF EXISTS tblRounds;
DROP TABLE IF EXISTS tblGames;
DROP TABLE IF EXISTS tblPlayers;
DROP TABLE IF EXISTS tblErrata;

-- --------------------------------------

CREATE TABLE tblPlayers
(
    p_id        CHAR(16),
    p_active    BOOLEAN DEFAULT TRUE, -- t, yes, on & 1 also work (optional)
    --
    CONSTRAINT p_PK PRIMARY KEY(p_id),
    CONSTRAINT zeroLenPid CHECK(LENGTH(p_id)>0)
    -- many platforms will allow a p_id of "" and most don't
    -- treat it as NULL.
);

-- --------------------------------------

CREATE TABLE tblGames
(
    g_id        INTEGER,
    g_timestamp TIMESTAMP,
    -- each game has two players
    p1_id       CHAR(16),
    p2_id       CHAR(16),
    --
    CONSTRAINT gPK PRIMARY KEY(g_id),
    CONSTRAINT p1_id_FK FOREIGN KEY(p1_id) REFERENCES tblPlayers(p_id),
    CONSTRAINT p2_id_FK FOREIGN KEY(p2_id) REFERENCES tblPlayers(p_id),
    CONSTRAINT noNullPlayer1 CHECK(p1_id IS NOT NULL),
    CONSTRAINT noNullPlayer2 CHECK(p1_id IS NOT NULL),
    CONSTRAINT uniquePlayerPair UNIQUE(p1_id, p2_id),
    CONSTRAINT playerOrder CHECK (p1_id<p2_id)
);

-- --------------------------------------

CREATE TABLE tblRounds
(
    r_id        INTEGER,
    r_timestamp TIMESTAMP,
    g_id        INTEGER,  
    r_token1    CHAR(1),
    r_token2    CHAR(1),
    --
    CONSTRAINT rPK PRIMARY KEY(r_id),
    CONSTRAINT g_id_FK FOREIGN KEY(g_id) REFERENCES tblGames(g_id),
    CONSTRAINT valid_r_token1 CHECK (r_token1 IN ('R', 'P', 'S')),
    CONSTRAINT valid_r_token2 CHECK (r_token2 IN ('R', 'P', 'S'))
);

-- --------------------------------------

CREATE TABLE tblErrata
(
    e_id        INTEGER     PRIMARY KEY,
    e_timestamp TIMESTAMP   NOT NULL,
    --
    p_id        CHAR(16),
    --
    g_id        INTEGER,
    g_timestamp TIMESTAMP,
    p1_id       CHAR(16),
    p2_id       CHAR(16),
    --
    r_id        INTEGER,
    r_timestamp TIMESTAMP,
    r_g_id      INTEGER,
    r_token1    CHAR(1),
    r_token2    CHAR(1)
);


CREATE SEQUENCE rpsSequence;

CREATE USER rpsprog WITH LOGIN PASSWORD 'rpspsw';
CREATE DATABASE rpsprog WITH OWNER rpsprog;

CREATE USER somebody WITH LOGIN PASSWORD 'somebody';
CREATE DATABASE somebdoy WITH OWNER somebody;

CREATE ROLE rpsProgrammer;
CREATE ROLE rpsUser;

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER
		ON TABLE tblPlayers, tblGames, tblRounds, tblPlayers
		TO GROUP rpsProgrammer;
		
GRANT ALL PRIVILEGES
		ON SEQUENCE rpsSequence
		TO GROUP rpsProgrammer;
		
GRANT CONNECT
		ON DATABASE rps
		TO GROUP rpsProgrammer, rpsUser;
		
ALTER GROUP rpsProgrammer ADD USER rpsprog;

ALTER GROUP rpsUser ADD USER somebody;



		