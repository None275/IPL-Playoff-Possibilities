/* 6. Set IPL Point Table Possibilities */
;WITH CTE AS
(
	SELECT ipt.teamid, ipt.team, points + SUM(CASE imwp.winner WHEN ipt.team THEN 2 ELSE 0 END) As points, 
				win + SUM(CASE imwp.winner WHEN ipt.team THEN 1 ELSE 0 END) As win,
				loose + SUM(CASE imwp.winner WHEN ipt.team THEN 0 ELSE 1 END) As loose,
				totalmatches + COUNT(imwp.matchid) As totalmatches, imwp.possibility
	FROM IPL_PointTable ipt 
	INNER JOIN IPL_Matches im ON im.team1 = ipt.team OR im.team2 = ipt.team
	INNER JOIN IPL_Matches_WinningPossibilities imwp ON imwp.matchid = im.matchid
	GROUP BY imwp.possibility, ipt.teamid, ipt.team, ipt.points, ipt.win, ipt.loose, ipt.totalmatches
)
INSERT INTO IPL_PointTable_Possibilities 
		(teamid, team, points, win, loose, totalmatches, possibility, [rank], position)
  SELECT teamid, team, points, win, loose, totalmatches, possibility, ROW_NUMBER() OVER(PARTITION BY possibility ORDER BY points DESC), 
	     RANK() OVER(PARTITION BY possibility ORDER BY points DESC)
    FROM CTE
ORDER BY possibility
GO

;WITH CTE AS
(
	  SELECT possibility, Points, count(Points) as rank_occurances
	    FROM IPL_PointTable_Possibilities  imwp 
	GROUP BY possibility, Points
)
UPDATE IPL_PointTable_Possibilities SET sameposition_occurances = rank_occurances
FROM CTE 
WHERE CTE.possibility = IPL_PointTable_Possibilities.possibility AND CTE.points = IPL_PointTable_Possibilities.points
GO