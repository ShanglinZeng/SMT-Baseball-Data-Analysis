use SMT_Data_Challenge_2023
-------------------------POPULATE BRIDGE TABLES
-- Populate GAME
drop table #GAME_DATA
create table #GAME_DATA(
	PK INT PRIMARY KEY IDENTITY(1,1) not null,
    gameYear INT,
	gameRound INT,
    homeTeam varchar(10),
    awayTeam varchar(10),
)

insert into #GAME_DATA (gameYear, gameRound, homeTeam, awayTeam)
select distinct gameYear, gameRound, home_team, away_team from RAWDATAGAMEINFOMERGED
go


CREATE OR ALTER PROCEDURE wrapper_INSERT_GAME
AS

DECLARE @gameYear INT
DECLARE @gameRound INT
DECLARE @home_name varchar(10)
DECLARE @away_name varchar(10)
DECLARE @Run INT
SET @Run = (SELECT distinct COUNT(*) FROM #GAME_DATA)

WHILE @Run > 0
BEGIN

SET @gameYear = (SELECT gameYear FROM #GAME_DATA WHERE @Run = PK)
SET @gameRound = (SELECT gameRound FROM #GAME_DATA WHERE @Run = PK)
set @home_name = (select homeTeam from #GAME_DATA where @Run = PK)
set @away_name = (select awayTeam from #GAME_DATA where @Run = PK)

EXEC insertGame
@home_team = @home_name,
@away_team = @away_name,
@game_year = @gameYear,
@game_round = @gameRound

SET @Run = @Run - 1
END
GO

exec wrapper_INSERT_GAME

select * from GAME

-- Populate INNING_PART
exec insertInningPart
@inning_part_name = 'Top'

exec insertInningPart
@inning_part_name = 'Bottom'


-- Populate INNING
select * from RAWDATAGAMEINFOMERGED

CREATE TABLE #INNINGDATA (
    PK INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    home_team varchar(10),
    away_team varchar(10),
    gameYear int,
    gameRound int,
    inning_part_name varchar(10),
    inning_number int
)

INSERT INTO #INNINGDATA (home_team, away_team, gameYear, gameRound, inning_part_name, inning_number)
SELECT distinct home_team, away_team, gameYear, gameRound, top_bottom_inning, inning FROM RAWDATAGAMEINFOMERGED
GO

CREATE OR ALTER PROCEDURE wrapper_INSERT_INNING
AS

DECLARE @inningNumber INT
DECLARE @inningPartName VARCHAR(10)
DECLARE @gameYear INT
DECLARE @gameRound INT
DECLARE @home varchar(10)
DECLARE @away varchar(10)
DECLARE @RUN INT
SET @RUN = (SELECT COUNT(*) FROM #INNINGDATA)

WHILE @Run > 0
BEGIN

SET @gameYear = (SELECT gameYear FROM #INNINGDATA WHERE @Run = PK)
SET @gameRound = (SELECT gameRound FROM #INNINGDATA WHERE @Run = PK)
SET @home = (SELECT home_team FROM #INNINGDATA WHERE @Run = PK)
SET @away = (SELECT away_team FROM #INNINGDATA WHERE @Run = PK)
SET @inningPartName = (SELECT inning_part_name FROM #INNINGDATA WHERE @Run = PK)
SET @inningNumber = (SELECT inning_number FROM #INNINGDATA WHERE @Run = PK)

EXEC insertInning
@home_team = @home,
@away_team = @away,
@game_year = @gameYear,
@game_round = @gameRound,
@inning_part_name = @inningPartName,
@inning_number = @inningNumber

SET @Run = @Run -1
END
GO

exec wrapper_INSERT_INNING
select * from INNING

-- Populate PLAY


CREATE TABLE #PLAYDATA (
    PK INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    home_team varchar(10),
    away_team varchar(10),
    gameYear int,
    gameRound int,
    inning_part_name varchar(10),
    inning_number int,
	playPerGame int
)

INSERT INTO #PLAYDATA (home_team, away_team, gameYear, gameRound, inning_part_name, inning_number, playPerGame)
SELECT distinct home_team, away_team, gameYear, gameRound, top_bottom_inning, inning, play_per_game FROM RAWDATAGAMEINFOMERGED
GO

CREATE OR ALTER PROCEDURE wrapper_INSERT_PLAY
AS

DECLARE @inningNumber INT
DECLARE @inningPartName VARCHAR(10)
DECLARE @gameYear INT
DECLARE @gameRound INT
DECLARE @home varchar(10)
DECLARE @away varchar(10)
declare @play_per_game int
DECLARE @run INT
SET @run = (SELECT COUNT(*) FROM #PLAYDATA)

WHILE @run > 0
BEGIN

SET @gameYear = (SELECT gameYear FROM #PLAYDATA WHERE @run = PK)
SET @gameRound = (SELECT gameRound FROM #PLAYDATA WHERE @run = PK)
SET @home = (SELECT home_team FROM #PLAYDATA WHERE @run = PK)
SET @away = (SELECT away_team FROM #PLAYDATA WHERE @run = PK)
SET @inningPartName = (SELECT inning_part_name FROM #PLAYDATA WHERE @run = PK)
SET @inningNumber = (SELECT inning_number FROM #PLAYDATA WHERE @run = PK)
set @play_per_game = (select playPerGame from #PLAYDATA where @run = PK)

EXEC insertPlay
@home_team = @home,
@away_team = @away,
@game_year = @gameYear,
@game_round = @gameRound,
@inning_part_name = @inningPartName,
@inning_number = @inningNumber,
@play_per_game = @play_per_game

SET @run = @run - 1
END
GO

exec wrapper_INSERT_PLAY

select * from PLAY

-- populate player
create table #PLAYERDATA(
	PK INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	playerNum int
)

insert into #PLAYERDATA(playerNum)
select distinct player_id from RAWDATAGAMEINFOMERGED

insert into PLAYER(playerNum)
select playerNum from #PLAYERDATA


-- populate POS
insert into POS(PosCode, PosName)
values (1, 'Pitcher')

insert into POS (PosCode, PosName)
values (2, 'Catcher')

insert into POS (PosCode, PosName)
values (3, 'First Baseman')

insert into POS (PosCode, PosName)
values (4, 'Second Baseman')

insert into POS (PosCode, PosName)
values (5, 'Third Baseman')

insert into POS (PosCode, PosName)
values (6, 'ShortStop')

insert into POS (PosCode, PosName)
values (7, 'Left Field')

insert into POS (PosCode, PosName)
values (8, 'Center Field')

insert into POS (PosCode, PosName)
values (9, 'Right Field')

insert into POS (PosCode, PosName)
values (10, 'Batter')

insert into POS (PosCode, PosName)
values (11, 'Runner on First Base')

insert into POS (PosCode, PosName)
values (12, 'Runner on Second Base')

insert into POS (PosCode, PosName)
values (13, 'Runner on Third Base')

insert into POS (PosCode, PosName)
values (255, 'Ball Event with no Player')


-- populate PLAYER_PLAY
create table #PLAYER_PLAY_DATA (
	PK INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    play_per_game int,
    inning_number int,
    inning_part_name varchar(10),
    game_year int,
    game_round int,
    home_team varchar(10),
    away_team varchar(10),
    pos_code int,
    player_num int
)

insert into #PLAYER_PLAY_DATA(play_per_game, inning_number, inning_part_name, game_year, game_round, home_team, away_team, pos_code, player_num)
select distinct play_per_game, inning, top_bottom_inning, gameYear, gameRound, home_team, away_team, position_number, player_id from RAWDATAGAMEINFOMERGED
go

CREATE OR ALTER PROCEDURE wrapper_INSERT_PLAYER_PLAY
AS

DECLARE @playPerGame INT
DECLARE @inningNumber INT
DECLARE @inningPartName varchar(10)
DECLARE @gameYear int
DECLARE @gameRound int
DECLARE @home varchar(10)
DECLARE @away varchar(10)
DECLARE @posCode int
DECLARE @playerNum int
DECLARE @Run INT
SET @Run = (SELECT COUNT(*) FROM #PLAYER_PLAY_DATA)

WHILE @Run > 0
BEGIN

SET @playPerGame = (SELECT play_per_game FROM #PLAYER_PLAY_DATA WHERE @Run = PK)
SET @inningNumber = (SELECT inning_number FROM #PLAYER_PLAY_DATA WHERE @Run = PK)
SET @inningPartName = (SELECT inning_part_name FROM #PLAYER_PLAY_DATA WHERE @Run = PK)
SET @gameYear = (SELECT game_year FROM #PLAYER_PLAY_DATA WHERE @Run = PK)
SET @gameRound = (SELECT game_round FROM #PLAYER_PLAY_DATA WHERE @Run = PK)
SET @home = (SELECT home_team FROM #PLAYER_PLAY_DATA WHERE @Run = PK)
SET @away = (SELECT away_team FROM #PLAYER_PLAY_DATA WHERE @Run = PK)
SET @posCode = (SELECT pos_code FROM #PLAYER_PLAY_DATA WHERE @Run = PK)
SET @playerNum = (SELECT player_num FROM #PLAYER_PLAY_DATA WHERE @Run = PK)

EXEC insertPlayerPlay
@play_per_game = @playPerGame,
@inning_number = @inningNumber,
@inning_part_name = @inningPartName,
@game_year = @gameYear,
@game_round = @gameRound,
@home_team = @home,
@away_team = @away,
@pos_code = @posCode,
@player_num = @playerNum

SET @Run = @Run - 1
END
GO

exec wrapper_INSERT_PLAYER_PLAY


-- populate EVENT
insert into EVENT (eventName, eventCode)
values ('Pitch', 1)

insert into EVENT (eventName, eventCode)
values ('Ball Acquired', 2)

insert into EVENT (eventName, eventCode)
values ('Throw (Ball in Play)', 3)

insert into EVENT (eventName, eventCode)
values ('Ball Hit into Play', 4)

insert into EVENT (eventName, eventCode)
values ('End of Play', 5)

insert into EVENT (eventName, eventCode)
values ('Pickoff Throw', 6)

insert into EVENT (eventName, eventCode)
values ('Ball Acquired (Unknown Field Position)', 7)

insert into EVENT (eventName, eventCode)
values ('Throw (Ball in Play -- Unknown Field Position)', 8)

insert into EVENT (eventName, eventCode)
values ('Ball Deflection', 9)

insert into EVENT (eventName, eventCode)
values ('Ball Deflection off of Wall', 10)

insert into EVENT (eventName, eventCode)
values ('Home Run', 11)

insert into EVENT (eventName, eventCode)
values ('Ball Bounce', 16)
go


-- populate PLAY_EVENT
create table #PLAY_EVENT_DATA (
	PK INT primary key identity(1,1) not null,
	play_per_game int,
	eventTimeStamp int,
	player_position int,
	event_code int,
	gameYear int,
	gameRound int,
	away varchar(10),
	home varchar(10)
)

insert into #PLAY_EVENT_DATA (play_per_game, eventTimeStamp, player_position, event_code, gameYear, gameRound, away, home)
select play_per_game, eventTimeStamp, player_position, event_code, gameYear, gameRound, away, home from RAW_DATA_GAME_EVENT
go

--select distinct playPerGame from PLAYER_PLAY
--	join PLAYER on PLAYER.playerID = PLAYER_PLAY.playerID
--	join POS on POS.positionID = PLAYER_PLAY.positionID
--	join PLAY on PLAY.playID = PLAYER_PLAY.playID
--	join INNING on INNING.inningID = PLAY.inningID
--	join INNING_PART on INNING_PART.inningPartID = INNING.inningPartID
--	join GAME on GAME.gameID = INNING.gameID



CREATE OR ALTER PROCEDURE wrapper_INSERT_PlayEvent
AS

DECLARE @event_code int, @event_timestamp int
DECLARE @play_per_game int, @game_year int, @game_round int, @away varchar(10), @home varchar(10)
declare @play_id int, @event_id int, @inning_number int, @inning_part_name varchar(10)
declare @home_id int, @away_id int
DECLARE @Run INT
SET @Run = (SELECT COUNT(*) FROM #PLAY_EVENT_DATA)

WHILE @Run > 0
BEGIN

SET @event_code = (SELECT event_code FROM #PLAY_EVENT_DATA WHERE @Run = PK)
SET @play_per_game = (SELECT play_per_game FROM #PLAY_EVENT_DATA WHERE @Run = PK)
set @event_timestamp = (select eventTimeStamp from #PLAY_EVENT_DATA where @Run = PK)
set @home = (select home from #PLAY_EVENT_DATA where @Run = PK)
set @away = (select away from #PLAY_EVENT_DATA where @Run = PK)
set @home_id = (select teamID from TEAM where teamName = @home)
set @away_id = (select teamID from TEAM where teamName = @away)
set @game_year = (select gameYear from #PLAY_EVENT_DATA where @Run = PK)
set @game_round = (select gameRound from #PLAY_EVENT_DATA where @Run = PK)
set @inning_number = (
	select inningNumber from INNING
		join PLAY on PLAY.inningID = INNING.inningID
		join GAME on GAME.gameID = INNING.gameID
	where GAME.home = @home_id 
	and GAME.away = @away_id
	and GAME.gameYear = @game_year
	and GAME.gameRound = @game_round
	and PLAY.playPerGame = @play_per_game
)
set @inning_part_name = (
	select inningPartName from INNING_PART
		join INNING on INNING.inningPartID = INNING_PART.inningPartID
		join PLAY on PLAY.inningID = INNING.inningID
		join GAME on GAME.gameID = INNING.gameID
	where GAME.home = @home_id 
	and GAME.away = @away_id
	and GAME.gameYear = @game_year
	and GAME.gameRound = @game_round
	and PLAY.playPerGame = @play_per_game
) 

EXEC insertPlayEvent
@Evcode = @event_code, @event_time_stamp = @event_timestamp,
-- play params
@play_per_game = @play_per_game, @inning_number = @inning_number, @inning_part_name = @inning_part_name,
@game_year = @game_year, @game_round = @game_round, @home_team = @home, @away_team = @away

SET @Run = @Run - 1
END
GO

exec wrapper_INSERT_PlayEvent
go

select * from PLAY_EVENT


-- populate TEAM_PLAYER
CREATE OR ALTER PROCEDURE wrapper_INSERT_TEAM_PALYER
AS

DECLARE @playerNum INT 
DECLARE @teamName VARCHAR(10), @team_year int
DECLARE @Run INT
SET @Run = (SELECT COUNT(*) FROM RAW_DATA_TEAM_INFO)

WHILE @Run > 0
BEGIN

SET @playerNum = (SELECT playerNum FROM RAW_DATA_TEAM_INFO WHERE @Run = PK)
SET @teamName = (SELECT teamName FROM RAW_DATA_TEAM_INFO WHERE @Run = PK)
set @team_year = (select teamYear from RAW_DATA_TEAM_INFO where @Run = PK)

EXEC insertTeamPlayer
@PNum = @playerNum,
@TName = @teamName,
@team_year = @team_year

SET @Run = @Run - 1
END
GO

exec wrapper_INSERT_TEAM_PALYER
go


-- populate ball pos
CREATE OR ALTER PROCEDURE wrapper_INSERT_BALL_POS
AS

DECLARE @ballTimeStamp INT
DECLARE	@ballPositionX float
DECLARE	@ballPositionY float
DECLARE	@ballPositionZ float
DECLARE @playPerGame int
DECLARE @inningNumber int
DECLARE @inningPartName varchar(10)
DECLARE @gameYear int
DECLARE @gameRound int
DECLARE @home varchar(10), @home_id int
DECLARE @away varchar(10), @away_id int
DECLARE @Run int
SET @Run = (SELECT COUNT(*) FROM RAW_DATA_BALL_POS)

WHILE @Run > 0
BEGIN

SET @ballTimeStamp = (SELECT gameTimeStamp FROM RAW_DATA_BALL_POS WHERE PK = @Run)
SET @ballPositionX = (SELECT ballPositionX FROM RAW_DATA_BALL_POS WHERE PK = @Run)
SET @ballPositionY = (SELECT ballPositionY FROM RAW_DATA_BALL_POS WHERE PK = @Run)
SET @ballPositionZ = (SELECT ballPositionZ FROM RAW_DATA_BALL_POS WHERE PK = @Run)
SET @playPerGame = (SELECT play_id FROM RAW_DATA_BALL_POS WHERE PK = @Run)
begin
	print @playPerGame;
end
SET @gameYear = (SELECT gameYear FROM RAW_DATA_BALL_POS WHERE PK = @Run)
begin
	print @gameYear;
end
SET @gameRound = (SELECT gameRound FROM RAW_DATA_BALL_POS WHERE PK = @Run)
begin
	print @gameRound;
end
SET @home = (SELECT homeTeam FROM RAW_DATA_BALL_POS WHERE PK = @Run)
SET @away = (SELECT awayTeam FROM RAW_DATA_BALL_POS WHERE PK = @Run)
set @home_id = (select teamID from TEAM where teamName = @home)
begin
	print @home_id;
end
set @away_id = (select teamID from TEAM where teamName = @away)
begin
	print @away_id;
end

set @inningNumber = (
	select inningNumber from INNING
		join PLAY on PLAY.inningID = INNING.inningID
		join GAME on GAME.gameID = INNING.gameID
	where GAME.home = @home_id 
	and GAME.away = @away_id
	and GAME.gameYear = @gameYear
	and GAME.gameRound = @gameRound
	and PLAY.playPerGame = @playPerGame
)
if @inningNumber is null
	begin
		print 'Warning: @inningNumber is empty.';
	end
set @inningPartName = (
	select inningPartName from INNING_PART
		join INNING on INNING.inningPartID = INNING_PART.inningPartID
		join PLAY on PLAY.inningID = INNING.inningID
		join GAME on GAME.gameID = INNING.gameID
	where GAME.home = @home_id 
	and GAME.away = @away_id
	and GAME.gameYear = @gameYear
	and GAME.gameRound = @gameRound
	and PLAY.playPerGame = @playPerGame
)
if @inningPartName is null
	begin
		print 'Warning: @inningPartName is empty.';
	end

EXEC insertBallPos
@ball_timestamp = @ballTimeStamp,
@ball_position_X = @ballPositionX,
@ball_position_Y = @ballPositionY,
@ball_position_Z = @ballPositionZ,
@play_per_game = @playPerGame,
@inning_number = @inningNumber,
@inning_part_name = @inningPartName,
@game_year = @gameYear,
@game_round = @gameRound,
@home_team = @home,
@away_team = @away

SET @Run = @Run - 1
END
GO

exec wrapper_INSERT_BALL_POS
go


-- populate player pos
CREATE OR ALTER PROCEDURE wrapper_INSERT_PLAYER_MOMENT
AS

DECLARE @playerTimeStamp numeric(10,0)
DECLARE @fieldX float
DECLARE @fieldY float
DECLARE @playPerGame int
DECLARE @inningNumber int
DECLARE @inningPartName varchar(10)
DECLARE @gameYear int
DECLARE @gameRound int
DECLARE @home varchar(10)
DECLARE @away varchar(10)
DECLARE @playerNum int
DECLARE @posCode int
DECLARE @Run INT
declare @home_id int, @away_id int, @play_id int
SET @Run = (SELECT COUNT(*) FROM RAW_DATA_PLAYER_POS)

WHILE @Run > 0
BEGIN

SET @playerTimeStamp = (SELECT playerTimeStamp FROM RAW_DATA_PLAYER_POS WHERE @Run = PK)
SET @fieldX = (SELECT fieldX FROM RAW_DATA_PLAYER_POS WHERE @Run = PK)
SET @fieldY = (SELECT fieldY FROM RAW_DATA_PLAYER_POS WHERE @Run = PK)
SET @playPerGame = (SELECT play_id FROM RAW_DATA_PLAYER_POS WHERE @Run = PK)
if @playPerGame is null
	begin
		print 'Warning: @playPerGame is empty.';
	end

-- SET @inningNumber = (SELECT inning_number FROM RAW_DATA_PLAYER_POS WHERE @Run = PK)
-- SET @inningPartName = (SELECT inning_part_name FROM RAW_DATA_PLAYER_POS WHERE @Run = PK)
SET @gameYear = (SELECT gameYear FROM RAW_DATA_PLAYER_POS WHERE @Run = PK)
if @gameYear is null
	begin
		print 'Warning: @gameYear is empty.';
	end

SET @gameRound = (SELECT gameRound FROM RAW_DATA_PLAYER_POS WHERE @Run = PK)
if @gameRound is null
	begin
		print 'Warning: @gameRound is empty.';
	end

SET @home = (SELECT home_name FROM RAW_DATA_PLAYER_POS WHERE @Run = PK)
SET @away = (SELECT away_name FROM RAW_DATA_PLAYER_POS WHERE @Run = PK)

-- select top 10 * from RAW_DATA_PLAYER_POS
SET @posCode = (SELECT playerPos FROM RAW_DATA_PLAYER_POS WHERE @Run = PK)

set @home_id = (select teamID from TEAM where teamName = @home)
if @home_id is null
	begin
		print 'Warning: @home_id is empty.';
	end

set @away_id = (select teamID from TEAM where teamName = @away)
if @away_id is null
	begin
		print 'Warning: @away_id is empty.';
	end

set @inningNumber = (
	select inningNumber from INNING
		join PLAY on PLAY.inningID = INNING.inningID
		join GAME on GAME.gameID = INNING.gameID
	where GAME.home = @home_id 
	and GAME.away = @away_id
	and GAME.gameYear = @gameYear
	and GAME.gameRound = @gameRound
	and PLAY.playPerGame = @playPerGame
)

if @inningNumber is null
	begin
		print 'Warning: @inningNumber is empty.';
	end
set @inningPartName = (
	select inningPartName from INNING_PART
		join INNING on INNING.inningPartID = INNING_PART.inningPartID
		join PLAY on PLAY.inningID = INNING.inningID
		join GAME on GAME.gameID = INNING.gameID
	where GAME.home = @home_id 
	and GAME.away = @away_id
	and GAME.gameYear = @gameYear
	and GAME.gameRound = @gameRound
	and PLAY.playPerGame = @playPerGame
)

exec getPlayID
@play_per_game = @playPerGame, 
@inning_number = @inningNumber, @inning_part_name = @inningPartName,
@game_year = @gameYear, @game_round = @gameRound, @home_team = @home, @away_team = @away,
@play_id = @play_id output
if @play_id is null
	begin
		print 'Warning: @play_id is empty.';
	end

SET @playerNum = (
	select playerNum from PLAYER
		join PLAYER_PLAY on PLAYER.playerID = PLAYER_PLAY.playerID
		join PLAY on PLAY.playID = PLAYER_PLAY.playID
		join POS on POS.positionID = PLAYER_PLAY.positionID
	where PLAY.playID = @play_id
	and POS.posCode = @posCode
)

EXEC insertPlayerMoment
@player_timestamp = @playerTimeStamp,
@fieldX = @fieldX,
@fieldY = @fieldY,
@play_per_game = @playPerGame,
@inning_number = @inningNumber,
@inning_part_name = @inningPartName,
@game_year = @gameYear,
@game_round = @gameRound,
@home_team = @home,
@away_team = @away,
@player_num = @playerNum,
@pos_code = @posCode

SET @Run = @Run - 1
END
GO

exec wrapper_INSERT_PLAYER_MOMENT

select count(*) from PLAYER_MOMENT
select * from RAW_DATA_PLAYER_POS


-- populate TEAM
SELECT *
INTO #TempTableTEAM
FROM TEAM
WHERE 1 = 0;

insert into TEAM (teamName)
select distinct home_team from RAWDATAGAMEINFOMERGED
union
select distinct away_team from RAWDATAGAMEINFOMERGED

select * from PLAY
	join PLAYER_PLAY on PLAYER_PLAY.playID = PLAY.playID
	join POS on PLAYER_PLAY.positionID = POS.positionID
	join PLAYER on PLAYER.playerID = PLAYER_PLAY.playerID
	join INNING on INNING.inningID = PLAY.inningID
	join INNING_PART on INNING_PART.inningPartID = INNING.inningPartID
	join GAME on GAME.gameID = INNING.gameID

select count(*) from PLAYER_PLAY

select count(*) from PLAY_EVENT
where playID is null