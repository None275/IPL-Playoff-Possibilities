/*
Missing Index Details from SQLQuery1.sql - DESKTOP-OQ4BF33\ANDYPHOTOGRAPHY.andylocaldb (andyphotography.web (55))
The Query Processor estimates that implementing the following index could improve the query cost by 38.5661%.
*/


USE [andylocaldb]
GO
CREATE NONCLUSTERED INDEX [Index_IPL_Matches_WinningPossibilities]
ON [dbo].[IPL_Matches_WinningPossibilities] ([possibility])
INCLUDE ([matchid],[matchno],[match],[winner])
GO

