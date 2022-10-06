CREATE DATABASE rps;

DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS games;
DROP TABLE IF EXISTS rounds;
DROP TABLE IF EXISTS players;

CREATE TABLE players (
	p_id CHAR(16) NOT NULL,
	CONSTRAINT playersPK PRIMARY KEY(p_id)
);

CREATE TABLE games (
	g_id serial UNIQUE NOT NULL,
	g_timestamp TIMESTAMP UNIQUE,
	p1_id CHAR(16) REFERENCES players(p_id),
	p2_id CHAR(16) REFERENCES players(p_id),
	CONSTRAINT gamesPK PRIMARY KEY(g_id),
	CONSTRAINT unique_p1_p2 UNIQUE(p1_id, p2_id),
    CONSTRAINT playerOrder CHECK(p1_id<p2_id),
	CONSTRAINT null_p1 CHECK(p1_id IS NOT NULL),
	CONSTRAINT null_p2 CHECK(p2_id IS NOT NULL)
);

CREATE TYPE TOKEN AS ENUM ('R', 'P', 'S');

CREATE TABLE rounds (
	r_id serial UNIQUE NOT NULL,
	r_timestamp TIMESTAMP UNIQUE,
	g_id INTEGER UNIQUE REFERENCES games(g_id),
	r_token1 TOKEN UNIQUE NOT NULL,
	r_token2 TOKEN UNIQUE NOT NULL
);

CREATE TABLE errata (
	e_id serial UNIQUE NOT NULL,
	e_timestamp TIMESTAMP,
	p_id CHAR(16) REFERENCES players(p_id),
	g_id INTEGER REFERENCES games(g_id),
	g_timestamp TIMESTAMP REFERENCES games(g_timestamp),
	p1_id CHAR(16) REFERENCES players(p_id),
	p2_id CHAR(16) REFERENCES players(p_id),
	r_id INTEGER REFERENCES rounds(r_id),
	r_timestamp TIMESTAMP REFERENCES rounds(r_timestamp),
	r_g_id INTEGER REFERENCES rounds(g_id),
	r_token1 TOKEN REFERENCES rounds(r_token1),
	r_token2 TOKEN REFERENCES rounds(r_token2)
);
