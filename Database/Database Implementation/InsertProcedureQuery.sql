------ One-row Insertion Stored Procedure
use SMT_Data_Challenge_2023
go
-------------------------------------------------- INSERT PLAY_EVENT
CREATE OR ALTER PROCEDURE insertPlayEvent
@Evcode int, @event_time_stamp int,
-- play params
@play_per_game int, @inning_number int, @inning_part_name varchar(10),
@game_year int, @game_round int, @home_team varchar(10), @away_team varchar(10)
AS
DECLARE @event_id INT, @play_id INT

EXECUTE getEventID
@event_code = @Evcode, 
@event_id = @event_id OUTPUT

IF @event_id IS NULL
   BEGIN
      PRINT '@Eventid is empty...check spelling';
      THROW 51111, '@Eventid cannot be NULL; process is terminating', 1;
   END

EXECUTE getPlayID
@play_per_game = @play_per_game, 
@inning_number = @inning_number, @inning_part_name = @inning_part_name,
@game_year = @game_year, @game_round = @game_round, @home_team = @home_team, @away_team = @away_team,
@play_id = @play_id OUTPUT
--IF @play_id IS NULL
--   BEGIN
--      PRINT '@Playid is empty...check spelling';
--      THROW 51112, '@Playid cannot be NULL; process is terminating', 1;
--   END

begin tran T1
INSERT INTO PLAY_EVENT(eventID, playID, eventTimeStamp)
VALUES (@event_id, @play_id, @event_time_stamp)
if @@error <> 0
   begin
       rollback tran T1
   end
else
   commit tran T1
GO

-------------------------------------------------- INSERT TEAM_PLAYER
CREATE OR ALTER PROCEDURE insertTeamPlayer
@PNum int,
@TName varchar(10),
@team_year int
AS
DECLARE @Playerid INT, @Teamid INT

EXECUTE getPlayerID
@player_num = @PNum, 
@player_id = @Playerid OUTPUT

IF @Playerid IS NULL
   BEGIN
      PRINT '@Playerid is empty...check spelling';
      THROW 51113, '@Playerid cannot be NULL; process is terminating', 1;
   END

EXECUTE getTeamID
@team_name = @TName,
@team_id = @Teamid OUTPUT

IF @Teamid IS NULL
   BEGIN
      PRINT '@Teamid is empty...check spelling';
      THROW 51114, '@Teamid cannot be NULL; process is terminating', 1;
   END

begin tran T1
INSERT INTO TEAM_PLAYER(playerID, teamID, playerYear)
VALUES (@Playerid, @Teamid, @team_year)
if @@error <> 0
   begin
       rollback tran T1
   end
else
   commit tran T1
GO


-------------------------------------------------- INSERT PLAY
CREATE OR ALTER PROCEDURE insertPlay
@play_per_game int, @inning_number int,
@inning_part_name varchar(10),
-- game params
@game_year int, @game_round int, @home_team varchar(10), @away_team varchar(10)
AS
DECLARE @inning_id INT

EXECUTE getInningID
@inning_number = @inning_number, @inning_part_name = @inning_part_name,
@game_year = @game_year, @game_round = @game_round, @home_team = @home_team, 
@away_team = @away_team, @inning_id = @inning_id output

IF @inning_id IS NULL
   BEGIN
      PRINT '@inning_id is empty...check spelling';
      THROW 51115, '@inning_id cannot be NULL; process is terminating', 1;
   END

begin tran T1
INSERT INTO PLAY(playPerGame, inningID)
VALUES (@play_per_game, @inning_id)
if @@error <> 0
   begin
       rollback tran T1
   end
else
   commit tran T1
GO


-------------------------------------------------- INSERT GAME
create or alter procedure insertGame
@home_team varchar(30), @away_team varchar(30), @game_year int, @game_round int
as
declare @home_id int, @away_id int
exec getTeamID
@team_name = @home_team, @team_id = @home_id output
if @home_id is null
	begin
		print 'Warning: @home_id is empty.';
		throw 51116, '@home_id cannot be NULL; insertGame process is terminating', 1;
	end

exec getTeamID
@team_name = @away_team, @team_id = @away_id output
if @away_id is null
	begin
		print 'Warning: @away_id is empty.';
		throw 51117, '@away_id cannot be NULL; insertGame process is terminating', 1;
	end

begin tran T1
insert into GAME(gameYear, gameRound, home, away)
values (@game_year, @game_round, @home_id, @away_id)
if @@error <> 0
   begin
       rollback tran T1
   end
else
   commit tran T1
go


-------------------------------------------------- INSERT INNING
create or alter procedure insertInning
-- game params
@home_team varchar(10), @away_team varchar(10), @game_year int, @game_round int,
-- inningPart params
@inning_part_name varchar(10),
-- local params
@inning_number int
as
declare @game_id int, @inning_part_id int

exec getInningPartID
@inning_part_name = @inning_part_name, @inning_part_id = @inning_part_id output
if @inning_part_id is null
	begin
		print 'Warning: @inning_part_id is empty.';
		throw 51118, '@inning_part_id cannot be NULL; insertInning process is terminating', 1;
	end

exec getGameID
@game_year = @game_year, @game_round = @game_round, @home_team = @home_team, 
@away_team = @away_team, @game_id = @game_id output
if @game_id is null
	begin
		print 'Warning: @game_id is empty.';
		throw 51119, '@game_id cannot be NULL; insertInning process is terminating', 1;
	end
begin tran T1
insert into INNING(inningNumber, inningPartID, gameID)
values (@inning_number, @inning_part_id, @game_id)
if @@error <> 0
   begin
       rollback tran T1
   end
else
   commit tran T1
go


-------------------------------------------------- INSERT PLAYER_PLAY
create or alter procedure insertPlayerPlay
-- play params
@play_per_game int, @inning_number int, @inning_part_name varchar(10),
@game_year int, @game_round int, @home_team varchar(10), @away_team varchar(10),
-- pos params
@pos_code int,
-- player params
@player_num int
as
declare @play_id int, @position_id int, @player_id int

exec getPlayID
@play_per_game = @play_per_game, @inning_number = @inning_number, @inning_part_name = @inning_part_name,
@game_year = @game_year, @game_round = @game_round, @home_team = @home_team, @away_team = @away_team,
@play_id = @play_id output
if @play_id is null
	begin
		print 'Warning: @play_id is empty.';
		throw 51120, '@play_id cannot be NULL; insertInning process is terminating', 1;
	end

exec getPosID
@pos_code = @pos_code, @position_id = @position_id output
if @position_id is null
	begin
		print 'Warning: @position_id is empty.';
		throw 51120, '@position_id cannot be NULL; insertPlayerPlay process is terminating', 1;
	end

exec getPlayerID
@player_num = @player_num, @player_id = @player_id output
if @player_id is null
	begin
		print 'Warning: @player_id is empty.';
		throw 51120, '@player_id cannot be NULL; insertPlayerPlay process is terminating', 1;
	end

begin tran T1
insert into PLAYER_PLAY(playID, positionID, playerID)
values (@play_id, @position_id, @player_id)
if @@error <> 0
   begin
       rollback tran T1
   end
else
   commit tran T1
go


-------------------------------------------------- INSERT PLAYER_MOMENT
create or alter procedure insertPlayerMoment
-- local params
@player_timestamp numeric(10,0), @fieldX float, @fieldY float,
-- playerPlay params
@play_per_game int, @inning_number int, @inning_part_name varchar(10),
@game_year int, @game_round int, @home_team varchar(10), @away_team varchar(10),
@player_num int, @pos_code int
as
declare @player_play_id int
exec getPlayerPlayID
@play_per_game = @play_per_game, @inning_number = @inning_number, @inning_part_name = @inning_part_name,
@game_year = @game_year, @game_round = @game_round, @home_team = @home_team, @away_team = @away_team,
@player_num = @player_num, @pos_code = @pos_code, @player_play_id = @player_play_id output
-- if @player_play_id is null
-- 	begin
--		print 'Warning: @player_play_id is empty.';
--		throw 51120, '@player_play_id cannot be NULL; insertPlayerMoment process is terminating', 1;
--	end

begin tran T1
insert into PLAYER_MOMENT(playerTimeStamp, fieldX, fieldY, playerPlayID)
values (@player_timestamp, @fieldX, @fieldY, @player_play_id)
if @@error <> 0
   begin
       rollback tran T1
   end
else
   commit tran T1
go


-------------------------------------------------- INSERT BALL_POS
create or alter procedure insertBallPos
-- local params
@ball_timestamp int, @ball_position_X float,
@ball_position_Y float, @ball_position_Z float,
-- play params
@play_per_game int, @inning_number int, @inning_part_name varchar(10),
@game_year int, @game_round int, @home_team varchar(10), @away_team varchar(10)
as
declare @play_id int

exec getPlayID
@play_per_game = @play_per_game, @inning_number = @inning_number, 
@inning_part_name = @inning_part_name,
@game_year = @game_year, @game_round = @game_round, @home_team = @home_team, 
@away_team = @away_team, @play_id = @play_id output
--if @play_id is null
--	begin
--		print 'Warning: @play_id is empty.';
--		throw 51120, '@play_id cannot be NULL; insertBallPos process is terminating', 1;
--	end

begin tran T1
insert into BALL_POS(ballPositionX, ballPositionY, ballPositionZ, ballTimeStamp, playID)
values (@ball_position_X, @ball_position_Y, @ball_position_Z, @ball_timestamp, @play_id)
if @@error <> 0
   begin
       rollback tran T1
   end
else
   commit tran T1
go

------------------------- Insert LookUp Tables
-------------------------------------------------- INSERT TEAM
create or alter procedure insertTeam
@team_name varchar(10)
as
begin tran T1
insert into TEAM(teamName)
values (@team_name)
if @@error <> 0
   begin
       rollback tran T1
   end
else
   commit tran T1
go


-------------------------------------------------- INSERT POS
create or alter procedure insertPos
@pos_code int, @pos_name varchar(50)
as
begin tran T1
insert into POS(posCode, posName)
values (@pos_code, @pos_name)
if @@error <> 0
   begin
       rollback tran T1
   end
else
   commit tran T1
go


-------------------------------------------------- INSERT EVENT
create or alter procedure insertEvent
@event_name varchar(50), @event_code int
as
begin tran T1
insert into EVENT(eventName, eventCode)
values (@event_name, @event_code)
if @@error <> 0
   begin
       rollback tran T1
   end
else
   commit tran T1
go


-------------------------------------------------- INSERT PLAYER
create or alter procedure insertPlayer
@player_num int
as
begin tran T1
insert into PLAYER(playerNum)
values (@player_num)
if @@error <> 0
   begin
       rollback tran T1
   end
else
   commit tran T1
go


-------------------------------------------------- INSERT INNING_PART
create or alter procedure insertInningPart
@inning_part_name varchar(10)
as
begin tran T1
insert into INNING_PART(inningPartName)
values (@inning_part_name)
if @@error <> 0
   begin
       rollback tran T1
   end
else
   commit tran T1
go