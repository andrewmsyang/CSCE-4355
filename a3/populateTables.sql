DO
$$
DECLARE
	err SMALLINT;
BEGIN
	CALL procInsertPlayer('Al', err);
	CALL procInsertPlayer('Bill', err);
	CALL procInsertPlayer('Chas', err);
	CALL procInsertPlayer('Dale', err);
	CALL procInsertPlayer('Ed', err);
	CALL procInsertPlayer('Frank', err);
	CALL procInsertPlayer('George', err);
	CALL procInsertPlayer('Horace', err);
	CALL procInsertPlayer('Ignacio', err);
	CALL procInsertPlayer('Jill', err);
	CALL procInsertPlayer('Kate', err);
	
	RAISE NOTICE 'Procedure terminated; error level = %', err;
END $$;


DO
$$
DECLARE
	err SMALLINT;
BEGIN
	CALL procInsertGame('Al', 'Bill', err);
	CALL procInsertGame('Al', 'Chas', err);
	CALL procInsertGame('Bill', 'George', err);
	CALL procInsertGame('Jill', 'Kate', err);
	CALL procInsertGame('Ed', 'Frank', err);
	CALL procInsertGame('George', 'Horace', err);
	
	RAISE NOTICE 'Procedure terminated; error level = %', err;
END $$;

DO
$$
DECLARE
	err SMALLINT;
BEGIN
	CALL procInsertRound(funcGameID('Al', 'Bill'), 'R', 'P', err);
	CALL procInsertRound(funcGameID('Ed', 'Frank'), 'P', 'S', err);
	CALL procInsertRound(funcGameID('Al', 'Chas'), 'R', 'R', err);
	CALL procInsertRound(funcGameID('Bill', 'George'), 'P', 'R', err);
	CALL procInsertRound(funcGameID('Al', 'Bill'), 'R', 'P', err);
	CALL procInsertRound(funcGameID('Jill', 'Kate'), 'R', 'S', err);
	
	RAISE NOTICE 'Procedure terminated; error level = %', err;
END $$;


	
