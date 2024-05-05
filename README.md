# IPL-Playoff-Possibilities 2024
IPL Playoff Qualification Possibilities

Like any other IPL fan, and specifically being a desperate RCB fella, I definitely wanted to know what the odds are that my favourite team can still qualify for the 2024 playoff and thus have chances of winning the tournament. So here I have created a SQL script that will generate the possibility of each outcome that describes the final result of the tournament, and hence provide me number of way by which RCB still can qualify for the playoffs.

Here are the details this script :

There will be 4 tables :

1. IPL_Matches - This table will define numner of remaining matches
2. IPL_PointTable - This table will define current IPL states
3. IPL_Matches_WinningPossibilities - This is a matrix which will provide each possibility based on match winning outcomes
4. IPL_PointTable_Possibilities - This table provides possible end of season point table for each possibility

Execute the script 1, 2, 3 & 4 in order, based on the data we can get playoff possibility of our team with below query :

SELECT possibility FROM IPL_PointTable_Possibilities WHERE team = 'RCB' AND position BETWEEN 1 AND 4 AND sameposition_occurances = 1
=> Currently I am getting 128 possibilities for which RCB can get to Playoff without being worried about strike rates

To get data of such possibility:
;WITH CTE AS 
(
	  SELECT possibility FROM IPL_PointTable_Possibilities WHERE team = 'RCB' AND position BETWEEN 1 AND 4 AND sameposition_occurances = 1
)
      SELECT * 
        FROM IPL_Matches_WinningPossibilities imwp
  INNER JOIN CTE ON CTE.possibility = imwp.possibility
    ORDER BY imwp.possibility, imwp.matchid

