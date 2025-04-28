-- GetID Procedure Queries
use SMT_Data_Challenge_2023
go
-- GetID functions

-- getTeamID
create or alter procedure getTeamID
@team_name varchar(10), @team_id INT output
as
set @team_id = (
	select teamID from TEAM
	where teamName = @team_name
)
if @team_id is null
	begin
		print 'Warning: @team_id is empty.';
		throw 51136, '@team_id cannot be NULL; insertGame process is terminating', 1;
	end
go


-- getInningPartID
create or alter procedure getInningPartID
@inning_part_name varchar(10), @inning_part_id int output
as
set @inning_part_id = (
	select inningPartId from INNING_PART
	where inningPartName = @inning_part_name
)
go


-- getEventID
create or alter procedure getEventID
@event_code int, @event_id int output
as
set @event_id = (
	select eventID from EVENT
	where eventCode = @event_code
)
go


-- getPlayerID
create or alter procedure getPlayerID
@player_num int, @player_id int output
as
set @player_id = (
	select playerID from PLAYER
	where playerNum = @player_num
)
go


-- getPosID
create or alter procedure getPosID
@pos_code int, @position_id int output
as
set @position_id = (
	select positionID from POS
	where posCode = @pos_code
)
go


-- getGameID
create or alter procedure getGameID
@game_year int, @game_round int, @home_team varchar(10), @away_team varchar(10), @game_id int output
as
declare @home_team_id int, @away_team_id int
exec getTeamID 
@team_name = @home_team, @team_id = @home_team_id output
exec getTeamID 
@team_name = @away_team, @team_id = @away_team_id output
set @game_id = (
	select gameID from GAME
	where gameYear = @game_year
	and gameRound = @game_round
	and away = @away_team_id
	and home = @home_team_id
)
go


-- getInningID
create or alter procedure getInningID
@inning_number int, @inning_part_name varchar(10),
@game_year int, @game_round int, @home_team varchar(10), @away_team varchar(10),
@inning_id int output
as
declare @game_id int, @inning_part_id int
exec getGameID
@game_year = @game_year, @game_round = @game_round, @home_team = @home_team, 
@away_team = @away_team, @game_id = @game_id output
exec getInningPartID
@inning_part_name = @inning_part_name, @inning_part_id = @inning_part_id output
set @inning_id = (
	select inningID from INNING
	where inningNumber = @inning_number
	and inningPartID = @inning_part_id
	and gameID = @game_id
)
go


-- getPlayID
create or alter procedure getPlayID
@play_per_game int, 
@inning_number int, @inning_part_name varchar(10),
@game_year int, @game_round int, @home_team varchar(10), @away_team varchar(10),
@play_id int output
as
declare @inning_id int
exec getInningID
@inning_number = @inning_number, @inning_part_name = @inning_part_name,
@game_year = @game_year, @game_round = @game_round, @home_team = @home_team, 
@away_team = @away_team, @inning_id = @inning_id output
set @play_id = (
	select playID from PLAY
	where playPerGame = @play_per_game
	and inningID = @inning_id
)
go


-- getPlayerPlayID
create or alter procedure getPlayerPlayID
-- PLAY parameters
@play_per_game int, @inning_number int, @inning_part_name varchar(10),
@game_year int, @game_round int, @home_team varchar(10), @away_team varchar(10),
-- PLAYER parameters
@player_num int,
-- POS parameters
@pos_code int,
-- output
@player_play_id int output
as
declare @play_id int, @position_id int, @player_id int
exec getPlayID
@play_per_game = @play_per_game, 
@inning_number = @inning_number, @inning_part_name = @inning_part_name,
@game_year = @game_year, @game_round = @game_round, @home_team = @home_team, 
@away_team = @away_team, @play_id = @play_id output
exec getPosID
@pos_code = @pos_code, @position_id = @position_id output
exec getPlayerID
@player_num = @player_num, @player_id = @player_id output
exec getPlayID
@play_per_game = @play_per_game, 
@inning_number = @inning_number, @inning_part_name = @inning_part_name,
@game_year = @game_year, @game_round = @game_round, @home_team = @home_team, @away_team = @away_team,
@play_id = @play_id output
set @player_play_id = (
	select playerPlayID from PLAYER_PLAY
	where playerID = @player_id
	and playID = @play_id
	and positionID = @position_id
)
go


-- getPlayerMomentID
create or alter procedure getPlayerMomentID
-- local params
@player_timestamp int, 
-- playerPlay params
@play_per_game int, @inning_number int, @inning_part_name varchar(10),
@game_year int, @game_round int, @home_team varchar(10), @away_team varchar(10),
@player_num int, @pos_code int,
-- output
@player_moment_id int output
as
declare @player_play_id int
exec getPlayerPlayID
@play_per_game = @play_per_game, @inning_number = @inning_number, @inning_part_name = @inning_part_name,
@game_year = @game_year, @game_round = @game_round, @home_team = @home_team, @away_team = @away_team,
@player_num = @player_num, @pos_code = @pos_code, @player_play_id = @player_play_id output
set @player_moment_id = (
	select PlayerMomentID from PLAYER_MOMENT
	where playerTimeStamp = @player_timestamp
	and PlayerPlayID = @player_play_id
)
go


-- getBallPosID
create or alter procedure getBallPosID
@ball_timestamp int, 
-- play params
@play_per_game int, @inning_number int, @inning_part_name varchar(10),
@game_year int, @game_round int, @home_team varchar(10), @away_team varchar(10),
-- output
@ball_pos_id int output
as
declare @play_id int
exec getPlayID
@play_per_game = @play_per_game, @inning_number = @inning_number, @inning_part_name = @inning_part_name,
@game_year = @game_year, @game_round = @game_round, @home_team = @home_team, @away_team = @away_team,
@play_id = @play_id output
set @ball_pos_id = (
	select ballPosID from BALL_POS
	where ballTimeStamp = @ball_timestamp
	and playID = @play_id
)
go


-- getPlayEventID
create or alter procedure getPlayEventID
-- event params
@event_code int, 
-- play params
@play_per_game int, 
@inning_number int, @inning_part_name varchar(10),
@game_year int, @game_round int, @home_team varchar(10), @away_team varchar(10),
-- output
@play_event_id int output
as
declare @event_id int, @play_id int
exec getEventID
@event_code = @event_code, @event_id = @event_id output
exec getPlayID
@play_per_game = @play_per_game, 
@inning_number = @inning_number, @inning_part_name = @inning_part_name,
@game_year = @game_year, @game_round = @game_round, @home_team = @home_team, @away_team = @away_team,
@play_id = @play_id output
set @play_event_id = (
	select playEventID from PLAY_EVENT 
	where eventID = @event_id
	and playID = @play_id
)
go


-- getTeamPlayerID
create or alter procedure getTeamPlayerID
@team_name varchar(10), @player_num int, @team_player_id int output
as
declare @team_id int, @player_id int
exec getTeamID
@team_name = @team_name, @team_id = @team_id output
exec getPlayerID
@player_num = @player_num, @player_id = @player_id output
set @team_player_id = (
	select teamPlayerID from TEAM_PLAYER
	where TeamID = @team_id and playerID = @player_id
)
go


