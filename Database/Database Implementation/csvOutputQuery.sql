---------------------- Customary CSV Output Data Queries

-- Ball position dataframe given "ball hit into play" occured in the plays
select distinct PLAY.playID, PLAY.playPerGame, GAME.gameID, ballPositionX, ballPositionY, ballPositionZ, ballTimeStamp from BALL_POS
	join PLAY on BALL_POS.playID = PLAY.playID
	join INNING on INNING.inningID = PLAY.inningID
	join GAME on GAME.gameID = INNING.gameID
	join PLAY_EVENT on PLAY_EVENT.playID = PLAY.playID
	join EVENT on EVENT.eventID = PLAY_EVENT.eventID
WHERE
    PLAY.playID IN (
        SELECT DISTINCT PLAY.playID
        FROM PLAY
        JOIN PLAY_EVENT ON PLAY.playID = PLAY_EVENT.playID
        JOIN EVENT ON EVENT.eventID = PLAY_EVENT.eventID
        WHERE EVENT.eventCode = 4
    )
order by GAME.gameID, PLAY.playPerGame, ballTimeStamp asc

-- Event dataframe given "ball hit into play" occured in the plays
select distinct GAME.gameID, PLAY.playID, PLAY.playPerGame, PLAY_EVENT.eventTimeStamp, EVENT.eventCode from PLAY_EVENT
	join PLAY on PLAY_EVENT.playID = PLAY.playID
	join INNING on INNING.inningID = PLAY.inningID
	join GAME on GAME.gameID = INNING.gameID
	join EVENT on EVENT.eventID = PLAY_EVENT.eventID
WHERE
    PLAY.playID IN (
        SELECT DISTINCT PLAY.playID
        FROM PLAY
        JOIN PLAY_EVENT ON PLAY.playID = PLAY_EVENT.playID
        JOIN EVENT ON EVENT.eventID = PLAY_EVENT.eventID
        WHERE EVENT.eventCode = 4
    )
order by GAME.gameID, PLAY.playPerGame, eventTimeStamp asc


-- Player position dataframe given "ball hit into play" occured in the plays
select distinct PLAY.playID, PLAY.playPerGame, GAME.gameID, playerNum, posCode, posName, playerTimeStamp, fieldX, fieldY from PLAYER_MOMENT
	join PLAYER_PLAY on PLAYER_PLAY.playerPlayID = PLAYER_MOMENT.playerMomentID
	join PLAYER on PLAYER.playerID = PLAYER_PLAY.playerID
	join POS on POS.positionID = PLAYER_PLAY.positionID
	join PLAY on PLAY.playID = PLAYER_PLAY.playID
	join INNING on INNING.inningID = PLAY.inningID
	join GAME on GAME.gameID = INNING.gameID
order by GAME.gameID, PLAY.playPerGame, playerTimeStamp asc


select distinct PLAY.playID from PLAY
	join PLAY_EVENT on PLAY_EVENT.playID = PLAY.playID
	join EVENT on EVENT.eventID = PLAY_EVENT.eventID
WHERE
    PLAY.playID IN (
        SELECT DISTINCT PLAY.playID
        FROM PLAY
        JOIN PLAY_EVENT ON PLAY.playID = PLAY_EVENT.playID
        JOIN EVENT ON EVENT.eventID = PLAY_EVENT.eventID
        WHERE EVENT.eventCode = 11
    )


