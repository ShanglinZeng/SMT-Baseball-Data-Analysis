---------------- Raw Data Import Queries
use SMT_Data_Challenge_2023

-- Import TEAM
-- bulk insert game_info
-- Create temptable for bulk insert
drop table #TempTableGameInfo
CREATE TABLE #TempTableGameInfo
(
	game_str varchar(60) not null,
    home_team varchar(10) not null,
    away_team varchar(10) not null, 
	play_per_game INT,
	inning INT,
	top_bottom_inning varchar(10),
	gameYear int,
	gameRound int,
	positionName varchar(50),
	playerNum int,
	posCode int
);

-- bulk insert process
BULK INSERT #TempTableGameInfo
FROM 'C:\Users\¿Ó¿§—Û\Desktop\Academics\SMT2023\cleaned_DS_accessible\gameInfo_merge.csv'
WITH
(
    FIRSTROW = 2, -- If your CSV file has a header row, set this to 2 to skip the header
    FIELDTERMINATOR = ',', -- Specify the field delimiter used in your CSV file (e.g., comma, tab, etc.)
    ROWTERMINATOR = '\n', -- Specify the row terminator used in your CSV file (e.g., new line, carriage return, etc.)
    TABLOCK -- Optional: Use this option to improve performance during bulk insert
);

select top 10 * from #TempTableGameInfo

-- Copy the raw data table to another table with PK
create table RAWDATAGAMEINFO (
	gameInfoID INT primary key identity(1,1) not null,
	game_str varchar(60) not null, -- Replace DataType1 with the appropriate data type for your data
    home_team varchar(10) not null, -- Replace DataType2 with the appropriate data type for your data
    away_team varchar(10) not null,  -- Replace DataType3 with the appropriate data type for your data
	at_bat INT,
	play_per_game INT,
	inning INT,
	top_bottom_inning varchar(10),
	pitcher INT,
	catcher int,
	first_base int,
	second_base int,
	third_base int,
	shortstop int,
	left_field int,
	center_field int,
	right_field int,
	batter int,
	first_baserunner int,
	second_baserunner int,
	third_baserunner int,
	gameYear int,
	gameRound int
)

-- Copy data
insert into RAWDATAGAMEINFO (game_str, 
	home_team, 
	away_team, 
	at_bat, 
	play_per_game,
	inning, 
	top_bottom_inning,
	pitcher,
	catcher,
	first_base,
	second_base,
	third_base,
	shortstop,
	left_field,
	center_field,
	right_field,
	batter,
	first_baserunner,
	second_baserunner,
	third_baserunner,
	gameYear,
	gameRound)
select * from #TempTableGameInfo

select * from RAWDATAGAMEINFO

-- bulk insert team_info
drop table #TempTeamInfo
create table #TempTeamInfo (
	teamID varchar(30) not null,
	playerID INT not null,
	teamYear INT not null
)

BULK INSERT #TempTeamInfo
FROM 'C:\Users\¿Ó¿§—Û\Desktop\Academics\SMT2023\cleaned_DS\cleaned_DS\team_info.csv'
WITH
(
    FIRSTROW = 2, -- If your CSV file has a header row, set this to 2 to skip the header
    FIELDTERMINATOR = ',', -- Specify the field delimiter used in your CSV file (e.g., comma, tab, etc.)
    ROWTERMINATOR = '\n', -- Specify the row terminator used in your CSV file (e.g., new line, carriage return, etc.)
    TABLOCK -- Optional: Use this option to improve performance during bulk insert
);

create table RAWDATATEAMINFO (
	teamInfoID int primary key identity(1,1) not null,
	teamID varchar(30) not null,
	playerID INT not null,
	teamYear INT not null
)

insert into RAWDATATEAMINFO (teamID, playerID, teamYear)
select * from #TempTeamInfo



-- Create a temptable that mocks the actual entity for TEAM
create table #TempTEAM (
	TeamID INT PRIMARY KEY IDENTITY(1,1),
    TeamName VARCHAR(30)
)

insert into #TempTEAM (TeamName)
select distinct * from (
	select distinct home_team from RAWDATAGAMEINFO
	union all
	select distinct away_team from RAWDATAGAMEINFO
)

select distinct away_team from RAWDATAGAMEINFO

-- Insert into the actual schema
insert into TEAM (TeamName)
select distinct home_team from RAWDATAGAMEINFO
union all
select distinct away_team from RAWDATAGAMEINFO

select * from TEAM


-- create a temptable that mocks the actual entity for player
CREATE TABLE #TEMPPLAYER(
	PlayerID INT PRIMARY KEY IDENTITY(1,1),
	PlayerNum INT 
);

insert into #TEMPPLAYER (PlayerNum)
select distinct playerID from RAWDATATEAMINFO

-- Insert into the actual schema
insert into PLAYER (PlayerNum)
select distinct playerID from RAWDATATEAMINFO


-- create a temptable that mocks the actual entity for Position
create table #TEMPPOS (
	PositionID INT PRIMARY KEY IDENTITY(1,1),
	PosCode INT,
	PosName VARCHAR(30)
)

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


-- Insert into INNING_PART
insert into INNING_PART (inningPartName)
values ('Top')

insert into INNING_PART (inningPartName)
values ('Bottom')

select * from INNING_PART


-- insert into EVENT
CREATE TABLE #TEMPEVENT (
    eventID INT PRIMARY KEY IDENTITY(1,1),
    eventName VARCHAR(50),
    eventCode INT
);

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

select * from EVENT
go



--- RAW data melted game info
drop table #TempTableGameInfoMelted
CREATE TABLE #TempTableGameInfoMelted
(
	unnamed int,
	game_str varchar(100), -- Replace DataType1 with the appropriate data type for your data
    home_team varchar(30), -- Replace DataType2 with the appropriate data type for your data
    away_team varchar(30),  -- Replace DataType3 with the appropriate data type for your data
	play_per_game INT,
	inning INT,
	top_bottom_inning varchar(30),
	gameYear int,
	gameRound int,
	position varchar(50),
	player_id int,
	position_number int
);


-- bulk insert process
BULK INSERT #TempTableGameInfoMelted
FROM 'C:\Users\¿Ó¿§—Û\Desktop\Academics\SMT2023\cleaned_DS_accessible\game_info_merge.csv'
WITH
(
    FIRSTROW = 2, -- If your CSV file has a header row, set this to 2 to skip the header
    FIELDTERMINATOR = ',', -- Specify the field delimiter used in your CSV file (e.g., comma, tab, etc.)
    ROWTERMINATOR = '\n', -- Specify the row terminator used in your CSV file (e.g., new line, carriage return, etc.)
    TABLOCK -- Optional: Use this option to improve performance during bulk insert
);

select * from #TempTableGameInfoMelted

-- Copy the raw data table to another table with PK
drop table RAWDATAGAMEINFOMERGED
create table RAWDATAGAMEINFOMERGED (
	gameInfoID INT primary key identity(1,1) not null,
	game_str varchar(100), -- Replace DataType1 with the appropriate data type for your data
    home_team varchar(30), -- Replace DataType2 with the appropriate data type for your data
    away_team varchar(30),  -- Replace DataType3 with the appropriate data type for your data
	play_per_game INT,
	inning INT,
	top_bottom_inning varchar(30),
	gameYear int,
	gameRound int,
	position varchar(50),
	player_id int,
	position_number int
)

-- Copy data
insert into RAWDATAGAMEINFOMERGED (
	game_str, -- Replace DataType1 with the appropriate data type for your data
    home_team, -- Replace DataType2 with the appropriate data type for your data
    away_team,  -- Replace DataType3 with the appropriate data type for your data
	play_per_game,
	inning,
	top_bottom_inning,
	gameYear,
	gameRound,
	position,
	player_id,
	position_number)
select game_str, -- Replace DataType1 with the appropriate data type for your data
    home_team, -- Replace DataType2 with the appropriate data type for your data
    away_team,  -- Replace DataType3 with the appropriate data type for your data
	play_per_game,
	inning,
	top_bottom_inning,
	gameYear,
	gameRound,
	position,
	player_id,
	position_number from #TempTableGameInfoMelted


-- bulk insert game_event
drop table #TempGAMEEVENT
create table #TempGAMEEVENT (
	a int,
	b int,
	c int,
	d int,
	e int,
	game_str varchar(50),
	play_id int,
	play_per_game int,
	eventTimeStamp int,
	player_position int,
	event_code int,
	gameYear int,
	gameRound int,
	away varchar(10),
	home varchar(10)
)

BULK INSERT #TempGAMEEVENT
FROM 'C:\Users\¿Ó¿§—Û\Desktop\Academics\SMT2023\cleaned_DS_accessible\game_events_accessible.csv'
WITH
(
    FIRSTROW = 2, -- If your CSV file has a header row, set this to 2 to skip the header
    FIELDTERMINATOR = ',', -- Specify the field delimiter used in your CSV file (e.g., comma, tab, etc.)
    ROWTERMINATOR = '\n', -- Specify the row terminator used in your CSV file (e.g., new line, carriage return, etc.)
    TABLOCK -- Optional: Use this option to improve performance during bulk insert
);

drop table RAW_DATA_GAME_EVENT
create table RAW_DATA_GAME_EVENT (
	PK INT primary key identity(1,1) not null,
	game_str varchar(50),
	play_per_game int,
	eventTimeStamp int,
	player_position int,
	event_code int,
	gameYear int,
	gameRound int,
	away varchar(10),
	home varchar(10)
)

insert into RAW_DATA_GAME_EVENT (game_str, play_per_game, eventTimeStamp, player_position, event_code, gameYear, gameRound, away, home)
select game_str, play_id, eventTimeStamp, player_position, event_code, gameYear, gameRound, away, home from #TempGAMEEVENT

select * from #TempGAMEEVENT

-- Raw insert team info
create table #TempTEAMINFO (
	teamName varchar(10),
	playerNum int,
	teamYear int,
)

BULK INSERT #TempTEAMINFO
FROM 'C:\Users\¿Ó¿§—Û\Desktop\Academics\SMT2023\cleaned_DS\cleaned_DS\team_info.csv'
WITH
(
    FIRSTROW = 2, -- If your CSV file has a header row, set this to 2 to skip the header
    FIELDTERMINATOR = ',', -- Specify the field delimiter used in your CSV file (e.g., comma, tab, etc.)
    ROWTERMINATOR = '\n', -- Specify the row terminator used in your CSV file (e.g., new line, carriage return, etc.)
    TABLOCK -- Optional: Use this option to improve performance during bulk insert
);

drop table RAW_DATA_TEAM_INFO
create table RAW_DATA_TEAM_INFO (
	PK int primary key identity(1,1) not null,
	teamName varchar(10),
	playerNum int,
	teamYear int,
)

insert into RAW_DATA_TEAM_INFO (teamName, playerNum, teamYear)
select teamName, playerNum, teamYear from #TempTEAMINFO

update RAW_DATA_TEAM_INFO
set teamName = replace(teamName, '"', '')


-- Raw insert ball pos
drop table #TempBallPos
create table #TempBallPos (
	unnamed int,
	unnamed_1 int,
	unnamed_2 int,
	game_str varchar(50),
	play_id int,
	gameTimeStamp numeric(10,0),
	ballPositionX float,
	ballPositionY float,
	ballPositionZ float,
	gameYear int,
	gameRound int,
	awayTeam varchar(10),
	homeTeam varchar(10)
)

select * from #TempBallPos -- 785041

BULK INSERT #TempBallPos
FROM 'C:\Users\¿Ó¿§—Û\Desktop\Academics\SMT2023\cleaned_DS_accessible\ball_pos_accessible.csv'
WITH
(
    FIRSTROW = 2, -- If your CSV file has a header row, set this to 2 to skip the header
    FIELDTERMINATOR = ',', -- Specify the field delimiter used in your CSV file (e.g., comma, tab, etc.)
    ROWTERMINATOR = '\n', -- Specify the row terminator used in your CSV file (e.g., new line, carriage return, etc.)
    TABLOCK -- Optional: Use this option to improve performance during bulk insert
);

drop table RAW_DATA_BALL_POS
create table RAW_DATA_BALL_POS (
	PK int primary key identity(1,1) not null,
	game_str varchar(50),
	play_id int,
	gameTimeStamp numeric(10,0),
	ballPositionX float,
	ballPositionY float,
	ballPositionZ float,
	gameYear int,
	gameRound int,
	awayTeam varchar(10),
	homeTeam varchar(10)
)

insert into RAW_DATA_BALL_POS (
	game_str,
	play_id,
	gameTimeStamp,
	ballPositionX,
	ballPositionY,
	ballPositionZ,
	gameYear,
	gameRound,
	homeTeam,
	awayTeam
)
select game_str,
	play_id,
	gameTimeStamp,
	ballPositionX,
	ballPositionY,
	ballPositionZ,
	gameYear,
	gameRound,
	homeTeam,
	awayTeam from #TempBallPos

select count(*) from BALL_POS
select * from PLAYER_MOMENT



-- Raw insert player pos
drop table #TempPLAYERPOS
create table #TempPLAYERPOS (
	unname int,
	unnamed int,
	game_str varchar(50),
	play_id int,
	playerTimeStamp numeric(10,0),
	playerPos int,
	fieldX float,
	fieldY float,
	gameYear int,
	gameRound int,
	home_name varchar(10),
	away_name varchar(10)
)

BULK INSERT #TempPLAYERPOS
FROM 'C:\Users\¿Ó¿§—Û\Desktop\Academics\SMT2023\player_pos_split_10\split_df_1.csv'
WITH
(
    FIRSTROW = 2, -- If your CSV file has a header row, set this to 2 to skip the header
    FIELDTERMINATOR = ',', -- Specify the field delimiter used in your CSV file (e.g., comma, tab, etc.)
    ROWTERMINATOR = '\n', -- Specify the row terminator used in your CSV file (e.g., new line, carriage return, etc.)
    TABLOCK -- Optional: Use this option to improve performance during bulk insert
);

BULK INSERT #TempPLAYERPOS
FROM 'C:\Users\¿Ó¿§—Û\Desktop\Academics\SMT2023\player_pos_split_10\split_df_2.csv'
WITH
(
    FIRSTROW = 2, -- If your CSV file has a header row, set this to 2 to skip the header
    FIELDTERMINATOR = ',', -- Specify the field delimiter used in your CSV file (e.g., comma, tab, etc.)
    ROWTERMINATOR = '\n', -- Specify the row terminator used in your CSV file (e.g., new line, carriage return, etc.)
    TABLOCK -- Optional: Use this option to improve performance during bulk insert
);

BULK INSERT #TempPLAYERPOS
FROM 'C:\Users\¿Ó¿§—Û\Desktop\Academics\SMT2023\player_pos_split_10\split_df_3.csv'
WITH
(
    FIRSTROW = 2, -- If your CSV file has a header row, set this to 2 to skip the header
    FIELDTERMINATOR = ',', -- Specify the field delimiter used in your CSV file (e.g., comma, tab, etc.)
    ROWTERMINATOR = '\n', -- Specify the row terminator used in your CSV file (e.g., new line, carriage return, etc.)
    TABLOCK -- Optional: Use this option to improve performance during bulk insert
);

BULK INSERT #TempPLAYERPOS
FROM 'C:\Users\¿Ó¿§—Û\Desktop\Academics\SMT2023\player_pos_split_10\split_df_4.csv'
WITH
(
    FIRSTROW = 2, -- If your CSV file has a header row, set this to 2 to skip the header
    FIELDTERMINATOR = ',', -- Specify the field delimiter used in your CSV file (e.g., comma, tab, etc.)
    ROWTERMINATOR = '\n', -- Specify the row terminator used in your CSV file (e.g., new line, carriage return, etc.)
    TABLOCK -- Optional: Use this option to improve performance during bulk insert
);

BULK INSERT #TempPLAYERPOS
FROM 'C:\Users\¿Ó¿§—Û\Desktop\Academics\SMT2023\player_pos_split_10\split_df_5.csv'
WITH
(
    FIRSTROW = 2, -- If your CSV file has a header row, set this to 2 to skip the header
    FIELDTERMINATOR = ',', -- Specify the field delimiter used in your CSV file (e.g., comma, tab, etc.)
    ROWTERMINATOR = '\n', -- Specify the row terminator used in your CSV file (e.g., new line, carriage return, etc.)
    TABLOCK -- Optional: Use this option to improve performance during bulk insert
);

BULK INSERT #TempPLAYERPOS
FROM 'C:\Users\¿Ó¿§—Û\Desktop\Academics\SMT2023\player_pos_split_10\split_df_6.csv'
WITH
(
    FIRSTROW = 2, -- If your CSV file has a header row, set this to 2 to skip the header
    FIELDTERMINATOR = ',', -- Specify the field delimiter used in your CSV file (e.g., comma, tab, etc.)
    ROWTERMINATOR = '\n', -- Specify the row terminator used in your CSV file (e.g., new line, carriage return, etc.)
    TABLOCK -- Optional: Use this option to improve performance during bulk insert
);

BULK INSERT #TempPLAYERPOS
FROM 'C:\Users\¿Ó¿§—Û\Desktop\Academics\SMT2023\player_pos_split_10\split_df_7.csv'
WITH
(
    FIRSTROW = 2, -- If your CSV file has a header row, set this to 2 to skip the header
    FIELDTERMINATOR = ',', -- Specify the field delimiter used in your CSV file (e.g., comma, tab, etc.)
    ROWTERMINATOR = '\n', -- Specify the row terminator used in your CSV file (e.g., new line, carriage return, etc.)
    TABLOCK -- Optional: Use this option to improve performance during bulk insert
);

BULK INSERT #TempPLAYERPOS
FROM 'C:\Users\¿Ó¿§—Û\Desktop\Academics\SMT2023\player_pos_split_10\split_df_8.csv'
WITH
(
    FIRSTROW = 2, -- If your CSV file has a header row, set this to 2 to skip the header
    FIELDTERMINATOR = ',', -- Specify the field delimiter used in your CSV file (e.g., comma, tab, etc.)
    ROWTERMINATOR = '\n', -- Specify the row terminator used in your CSV file (e.g., new line, carriage return, etc.)
    TABLOCK -- Optional: Use this option to improve performance during bulk insert
);

BULK INSERT #TempPLAYERPOS
FROM 'C:\Users\¿Ó¿§—Û\Desktop\Academics\SMT2023\player_pos_split_10\split_df_9.csv'
WITH
(
    FIRSTROW = 2, -- If your CSV file has a header row, set this to 2 to skip the header
    FIELDTERMINATOR = ',', -- Specify the field delimiter used in your CSV file (e.g., comma, tab, etc.)
    ROWTERMINATOR = '\n', -- Specify the row terminator used in your CSV file (e.g., new line, carriage return, etc.)
    TABLOCK -- Optional: Use this option to improve performance during bulk insert
);

BULK INSERT #TempPLAYERPOS
FROM 'C:\Users\¿Ó¿§—Û\Desktop\Academics\SMT2023\player_pos_split_10\split_df_10.csv'
WITH
(
    FIRSTROW = 2, -- If your CSV file has a header row, set this to 2 to skip the header
    FIELDTERMINATOR = ',', -- Specify the field delimiter used in your CSV file (e.g., comma, tab, etc.)
    ROWTERMINATOR = '\n', -- Specify the row terminator used in your CSV file (e.g., new line, carriage return, etc.)
    TABLOCK -- Optional: Use this option to improve performance during bulk insert
);

select count(*) from #TempPLAYERPOS

drop table RAW_DATA_PLAYER_POS
create table RAW_DATA_PLAYER_POS(
	PK int primary key identity(1,1) not null,
	game_str varchar(50),
	play_id int,
	playerTimeStamp numeric(10,0),
	playerPos int,
	fieldX float,
	fieldY float,
	gameYear int,
	gameRound int,
	away_name varchar(10),
	home_name varchar(10)
)

insert into RAW_DATA_PLAYER_POS (game_str, play_id, playerTimeStamp, playerPos, fieldX, fieldY, gameYear, gameRound, away_name, home_name)
select game_str, play_id, playerTimeStamp, playerPos, fieldX, fieldY, gameYear, gameRound, home_name, away_name from #TempPLAYERPOS

select * from PLAYER_PLAY
	join PLAY on PLAYER_PLAY.playID = PLAY.playID
	join POS on POS.positionID = PLAYER_PLAY.positionID
	join PLAYER on PLAYER.playerID = PLAYER_PLAY.playerID
	join INNING on INNING.inningID = PLAY.inningID
	join INNING_PART on INNING_PART.inningPartID = INNING.inningPartID
	join GAME on GAME.gameID = INNING.inningID

select * from RAW_DATA_PLAYER_POS


-- raw insert PLAYER_MOMENT_RAW
drop table #TempPLAYERMOMENT
create table #TempPLAYERMOMENT (
	unnamed int,
	gameStr varchar(50),
	playPerGame int,
	momentTimeStamp numeric(10,0),
	posCode int,
	fieldX numeric(10,0),
	fieldY numeric(10,0),
	gameYear int,
	gameRound int,
	awayName varchar(10),
	homeName varchar(10),
	awayID int,
	homeID int,
	playerPlayID numeric(10,0)
)

BULK INSERT #TempPLAYERMOMENT
FROM 'C:\Users\¿Ó¿§—Û\Desktop\Academics\SMT2023\cleaned_DS_accessible\playerPos_playerPlayID\player_moment.csv'
WITH
(
    FIRSTROW = 2, -- If your CSV file has a header row, set this to 2 to skip the header
    FIELDTERMINATOR = ',', -- Specify the field delimiter used in your CSV file (e.g., comma, tab, etc.)
    ROWTERMINATOR = '\n', -- Specify the row terminator used in your CSV file (e.g., new line, carriage return, etc.)
    TABLOCK -- Optional: Use this option to improve performance during bulk insert
);

insert into PLAYER_MOMENT (
	playerTimeStamp,
	fieldX,
	fieldY,
	playerPlayID
)
select momentTimeStamp, fieldX, fieldY, playerPlayID from #TempPLAYERMOMENT

select * from PLAYER_MOMENT