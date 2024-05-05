
/* 1. Table Schemas */
IF EXISTS(SELECT 1 FROM sys.tables WHERE name='IPL_Matches')
BEGIN
	DROP TABLE IPL_Matches
END
CREATE TABLE IPL_Matches
(
	matchid BIGINT IDENTITY(1,1) PRIMARY KEY,
	matchno INT,
	team1 VARCHAR(20) NULL,
	team2 VARCHAR(20) NULL,
	occurancescount INT NULL,
	totalnumber_of_possibilities_count INT NULL
)
GO

IF EXISTS(SELECT 1 FROM sys.tables WHERE name='IPL_PointTable')
BEGIN
	DROP TABLE IPL_PointTable
END
CREATE TABLE IPL_PointTable
(
	teamid BIGINT IDENTITY(1,1) PRIMARY KEY,
	team VARCHAR(20) NULL,
	points INT NULL,
	win INT NULL,
	loose INT NULL,
	totalmatches VARCHAR(20) NULL,
)
GO

IF EXISTS(SELECT 1 FROM sys.tables WHERE name='IPL_Matches_WinningPossibilities')
BEGIN
	DROP TABLE IPL_Matches_WinningPossibilities
END
CREATE TABLE IPL_Matches_WinningPossibilities
(
	winningposibilityid BIGINT IDENTITY(1,1) PRIMARY KEY,
	matchid BIGINT,
	matchno INT,
	match VARCHAR(50) NULL,
	winner VARCHAR(20) NULL,
	possibility BIGINT
)
GO

IF EXISTS(SELECT 1 FROM sys.tables WHERE name='IPL_PointTable_Possibilities')
BEGIN
	DROP TABLE IPL_PointTable_Possibilities
END
CREATE TABLE IPL_PointTable_Possibilities
(
	pointposibilityid BIGINT IDENTITY(1,1) PRIMARY KEY,
	teamid BIGINT,
	team VARCHAR(20) NULL,
	points INT NULL,
	win INT NULL,
	loose INT NULL,
	totalmatches VARCHAR(20) NULL,
	possibility BIGINT,
	[rank] INT,
	position INT,
	sameposition_occurances INT NULL
)
GO

/* 2. Table Data Entries */
INSERT INTO IPL_Matches (matchno, team1, team2) VALUES 
(55, 'MI','SRH'),
(56, 'DC','RR'),
(57, 'SRH','LSG'),
(58, 'PBKS','RCB'),
(59, 'GT','CSK'),
(60, 'KKR','MI'),
(61, 'CSK','RR'),
(62, 'RCB','DC'),
(63, 'GT','KKR'),
(64, 'DC','LSG'),
(65, 'RR','PBKS'),
(66, 'SRH','GT'),
(67, 'MI','LSG'),
(68, 'RCB','CSK'),
(69, 'SRH','PBKS'),
(70, 'RR','KKR')
GO

INSERT INTO IPL_PointTable (team, points, win, loose, totalmatches) VALUES
('RR', 16, 8, 2, 10),
('KKR', 16, 8, 3, 11),
('CSK', 12, 6, 5, 11),
('LSG', 12, 6, 5, 11),
('SRH', 12, 6, 4, 10),
('DC', 10, 5, 6, 11),
('RCB', 8, 4, 7, 11),
('PBKS', 8, 4, 7, 11),
('GT', 8, 4, 7, 11),
('MI', 6, 3, 8, 11)
GO

/* 3. IPL_Matches Table occurancescount  */
DECLARE @Counter INT, @occurancescount INT = 0
SELECT @Counter= MAX(matchid) FROM IPL_Matches
WHILE (@Counter > 0)
BEGIN
		SELECT @occurancescount = @occurancescount * 2
		IF @occurancescount = 0
		BEGIN
				SET @occurancescount = 1
		END

		UPDATE IPL_Matches SET occurancescount = @occurancescount, totalnumber_of_possibilities_count = @occurancescount * 2
		WHERE matchid = @Counter

		SET @Counter  = @Counter  - 1
END
GO

/* 4. Generate Series Table */
CREATE TABLE generate_series(
	value BIGINT
)
DECLARE @Counter INT, @SubCounter INT, @possibility INT 
SET @Counter=1
WHILE (@Counter <= 100000)
BEGIN

	INSERT INTO generate_series VALUES (@Counter)
    SET @Counter  = @Counter  + 1
END
GO
-- SELECT COUNT(1) FROM generate_series





