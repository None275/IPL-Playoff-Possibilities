/* 5. Generate IPL Winning Possibilities Matrix */
DECLARE @Counter INT, @possibilitiescount BIGINT = 1, @team2_occurancescount INT, 
        @occurancescount INT = 0, @matchid BIGINT, @matchno INT, @team1 VARCHAR(20), @team2 VARCHAR(20)
SELECT @Counter= MAX(matchid) FROM IPL_Matches
WHILE (@Counter >= 1)
BEGIN
		SELECT @matchid = matchid, @matchno = matchno, @team1 = team1, @team2 = team2, 
		       @occurancescount = occurancescount 
		  FROM IPL_Matches
		 WHERE matchid = @Counter

		IF ISNULL(@matchid,0) > 0
		BEGIN

				SET @team2_occurancescount = 1

				-- Team 1
				INSERT INTO IPL_Matches_WinningPossibilities (matchid, matchno, [match], winner, possibility)
				     SELECT @matchid, @matchno, @team1 + ' vs ' + @team2, @team1, [value]
					  FROM generate_series WHERE [value] <= @occurancescount
				  ORDER BY [value]
				  --SELECT @matchid, @matchno, @team1 + ' vs ' + @team2, @team1, 'P' + CONVERT(VARCHAR(10),[value]), [value]
					 -- FROM generate_series WHERE [value] <= @occurancescount
				  --ORDER BY [value]

				-- Team 2
				SELECT @team2_occurancescount = @occurancescount + @occurancescount
				INSERT INTO IPL_Matches_WinningPossibilities (matchid, matchno, [match], winner, possibility)
				     SELECT @matchid, @matchno, @team1 + ' vs ' + @team2, @team2, [value]
					  FROM generate_series WHERE [value] > @occurancescount AND [value] <= @team2_occurancescount
				  ORDER BY [value]
				  --SELECT @matchid, @matchno, @team1 + ' vs ' + @team2, @team2, 'P' + CONVERT(VARCHAR(10),[value]), [value]
					 -- FROM generate_series WHERE [value] > @occurancescount AND [value] <= @team2_occurancescount
				  --ORDER BY [value]


				  -- Remaining T2 Entries
				  IF @occurancescount > 1
				  BEGIN
					  ;WITH CTE As
					  (
							SELECT ROW_NUMBER() OVER(ORDER BY gs1.[value]) as row_num, gs1.[value]--, gs2.[value]
							  FROM generate_series gs1 
							 WHERE gs1.[value] > @occurancescount AND gs1.[value] <= @team2_occurancescount
					  )
					   INSERT INTO IPL_Matches_WinningPossibilities (matchid, matchno, [match], winner, possibility)
							SELECT matchid, matchno, [match], winner, CTE.[value]
							  FROM CTE
						INNER JOIN generate_series gs2 ON gs2.[value] = CTE.row_num 
						INNER JOIN IPL_Matches_WinningPossibilities imw WITH(NOLOCK) ON possibility = gs2.[value] AND matchid <> @matchid
				END

		END

		PRINT @Counter

		SET @Counter  = @Counter  - 1
END