SELECT * FROM IPL_Matches
SELECT * FROM IPL_PointTable

SELECT COUNT(1) FROM generate_series
SELECT * FROM generate_series

-- TRUNCATE TABLE IPL_Matches_WinningPossibilities
SELECT COUNT(1) FROM IPL_Matches_WinningPossibilities 
-- 1,048,576
SELECT * FROM IPL_Matches_WinningPossibilities 
WHERE possibility = 1
ORDER BY possibility, matchno


SELECT * 
FROM IPL_PointTable ipt 
INNER JOIN IPL_Matches_WinningPossibilities imwp ON imwp.winner = ipt.team
WHERE imwp.possibility = 1

SELECT possibility, Points, count(Points)--, team
FROM IPL_PointTable_Possibilities  imwp 
WHERE imwp.possibility = 4115
GROUP BY possibility, Points--, team

SELECT * FROM IPL_PointTable_Possibilities WHERE team = 'RCB' AND position BETWEEN 1 AND 4 AND sameposition_occurances = 1

SELECT * FROM IPL_PointTable_Possibilities imwp 
WHERE imwp.possibility IN (SELECT possibility FROM IPL_PointTable_Possibilities WHERE team = 'RCB' AND position = 3 AND sameposition_occurances = 1)
ORDER BY imwp.possibility

SELECT * FROM IPL_Matches_WinningPossibilities imwp 
WHERE imwp.possibility IN (SELECT possibility FROM IPL_PointTable_Possibilities WHERE team = 'RCB' AND position BETWEEN 1 AND 4 AND sameposition_occurances = 1)
ORDER BY imwp.possibility, imwp.matchid

;WITH CTE AS 
(
	SELECT possibility FROM IPL_PointTable_Possibilities WHERE team = 'RCB' AND position BETWEEN 1 AND 4 AND sameposition_occurances = 1
)
SELECT * FROM IPL_Matches_WinningPossibilities imwp
INNER JOIN CTE ON CTE.possibility = imwp.possibility
ORDER BY imwp.possibility, imwp.matchid

	SELECT * 
      FROM IPL_Matches_WinningPossibilities imwp
INNER JOIN IPL_PointTable_Possibilities ipp ON ipp.possibility = imwp.possibility 
	 WHERE ipp.team = 'RCB' AND ipp.position BETWEEN 1 AND 4 AND ipp.sameposition_occurances = 1
  ORDER BY imwp.possibility, imwp.matchid


SELECT matchid, match, winner, 13011, 13012, 13019
FROM 
(
	    SELECT imwp.matchid, imwp.possibility, imwp.match, imwp.winner
		  FROM IPL_Matches_WinningPossibilities imwp
	INNER JOIN IPL_PointTable_Possibilities ipp ON ipp.possibility = imwp.possibility 
		 WHERE ipp.team = 'RCB' AND ipp.position BETWEEN 1 AND 4 AND ipp.sameposition_occurances = 1 AND imwp.possibility IN (13011, 13012, 13019)
		 --ORDER BY imwp.possibility, imwp.matchid
) SRC
PIVOT
(
  SUM(possibility)
  FOR possibility IN ([13011], [13012], [13019])
) PIV;




--SELECT * FROM IPL_Matches
--DECLARE @Counter INT, @possibilitiescount BIGINT = 1, @team1_occurancescount INT, @team2_occurancescount INT, @oldrecordcount INT, @oldmatchid BIGINT, 
--        @occurancescount INT = 0, @matchid BIGINT, @matchno INT, @team1 VARCHAR(20), @team2 VARCHAR(20)
--SELECT @Counter= MAX(matchid) FROM IPL_Matches
--WHILE (@Counter >= 1)
--BEGIN
--		SELECT @matchid = matchid, @matchno = matchno, @team1 = team1, @team2 = team2, 
--		       @occurancescount = occurancescount --, @team1_occurancescount = @occurancescount, @team2_occurancescount = @occurancescount
--		  FROM IPL_Matches
--		 WHERE matchid = @Counter

--		SELECT @team1_occurancescount = 1, @team2_occurancescount = 1, @possibilitiescount = 1, @oldrecordcount = 1

--		 WHILE (@team1_occurancescount <= @occurancescount)
--		 BEGIN

--				IF NOT EXISTS(SELECT 1 FROM IPL_Matches_WinningPossibilities WHERE matchid = @matchid AND possibility_number = @possibilitiescount)
--				BEGIN
--						INSERT INTO IPL_Matches_WinningPossibilities (matchid, matchno, [match], winner, possibility, possibility_number)
--						SELECT @matchid, @matchno, @team1 + ' vs ' + @team2, @team1, 'P' + CONVERT(VARCHAR(10),@possibilitiescount), @possibilitiescount
--				END

--				SET @team1_occurancescount = @team1_occurancescount + 1
--				SET @possibilitiescount = @possibilitiescount + 1
--		 END

		
--		WHILE (@team2_occurancescount <= @occurancescount)
--		BEGIN
--				IF NOT EXISTS(SELECT 1 FROM IPL_Matches_WinningPossibilities WHERE matchid = @matchid AND possibility_number = @possibilitiescount)
--				BEGIN
--						INSERT INTO IPL_Matches_WinningPossibilities (matchid, matchno, match, winner, possibility, possibility_number)
--						SELECT @matchid, @matchno, @team1 + ' vs ' + @team2, @team2, 'P' + CONVERT(VARCHAR(10),@possibilitiescount), @possibilitiescount
--				END

--				SELECT @oldmatchid = matchid FROM IPL_Matches_WinningPossibilities WHERE possibility_number = @oldrecordcount AND matchid <> @matchid

--				--SELECT matchid FROM IPL_Matches_WinningPossibilities WHERE possibility_number = @oldrecordcount

--				IF NOT EXISTS(SELECT 1 FROM IPL_Matches_WinningPossibilities WHERE matchid = @oldmatchid AND possibility_number = @possibilitiescount)
--				BEGIN
--						INSERT INTO IPL_Matches_WinningPossibilities (matchid, matchno, [match], winner, possibility, possibility_number)
--						SELECT matchid, matchno, [match], winner, 'P' + CONVERT(VARCHAR(10),@possibilitiescount), @possibilitiescount FROM IPL_Matches_WinningPossibilities WHERE possibility_number = @oldrecordcount AND matchid <> @matchid
--				END

--				SET @team2_occurancescount = @team2_occurancescount + 1
--				SET @possibilitiescount = @possibilitiescount + 1
--				SET @oldrecordcount = @oldrecordcount + 1
--		 END

--		SET @Counter  = @Counter  - 1
--END

--TRUNCATE TABLE IPL_Matches_WinningPossibilities
--INSERT INTO IPL_Matches_WinningPossibilities (matchno, match, winner, possibility)
--SELECT matchno, team1 + ' vs ' + team2, team1, 1 as possibility FROM IPL_Matches
--UNION ALL
--SELECT matchno, team1 + ' vs ' + team2, team2, 2 as possibility FROM IPL_Matches
--ORDER BY matchno, possibility

-- SELECT * FROM IPL_Matches im
-- CROSS APPLY (SELECT team2 FROM IPL_Matches im2 WHERE im2.matchno = im.matchno) As p
-- WHERE im.matchno = im2.matchno

-- SELECT *  FROM IPL_Matches_WinningPossibilities imwp
-- CROSS APPLY IPL_Matches_WinningPossibilities imwp2
-- WHERE (imwp.matchno <> imwp2.matchno OR (imwp.matchno = imwp2.matchno AND imwp.winner = imwp2.winner))
-- AND imwp2.winner IN ('CSK')
