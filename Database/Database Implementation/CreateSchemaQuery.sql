----------Create schema queries
create database SMT_Data_Challenge_2023

use SMT_Data_Challenge_2023

drop table TEAM
CREATE TABLE TEAM (
    teamID INT PRIMARY KEY IDENTITY(1,1) not null,
    teamName VARCHAR(30)
);

drop table INNING_PART
CREATE TABLE INNING_PART (
    inningPartID INT PRIMARY KEY IDENTITY(1,1) not null,
    inningPartName VARCHAR(10)
);

drop table EVENT
CREATE TABLE EVENT (
    eventID INT PRIMARY KEY IDENTITY(1,1) not null,
    eventName VARCHAR(50),
    eventCode INT
);

drop table PLAYER
CREATE TABLE PLAYER(
	playerID INT PRIMARY KEY IDENTITY(1,1) not null,
	playerNum INT 
);

drop table POS
CREATE TABLE POS(
	positionID INT PRIMARY KEY IDENTITY(1,1) not null,
	posCode INT,
	posName VARCHAR(30)
);

drop table GAME
CREATE TABLE GAME (
    gameID INT PRIMARY KEY IDENTITY(1,1) not null,
    gameYear INT,
	gameRound INT,
    home INT,
    away INT,
    FOREIGN KEY (home) REFERENCES TEAM(teamID),
    FOREIGN KEY (away) REFERENCES TEAM(teamID)
);

drop table INNING
Create table INNING (
	inningID INT PRIMARY KEY IDENTITY(1,1) not null,
	inningNumber INT,
    inningPartID INT,
    gameID INT,
    FOREIGN KEY (inningPartID) REFERENCES INNING_PART(inningPartID),
	FOREIGN KEY (gameID) REFERENCES GAME(gameID)
);

drop table PLAY
CREATE TABLE PLAY (
    playID INT PRIMARY KEY IDENTITY(1,1) not null,
    playPerGame INT,
    inningID INT,
    FOREIGN KEY (inningId) REFERENCES INNING(inningID)
);

drop table PLAY_EVENT
CREATE TABLE PLAY_EVENT (
    playEventID INT PRIMARY KEY IDENTITY(1,1) not null,
    eventID INT,
    playID INT,
	eventTimeStamp int,
    FOREIGN KEY (eventID) REFERENCES EVENT(eventID),
    FOREIGN KEY (playID) REFERENCES PLAY(playID)
);

drop table TEAM_PLAYER
CREATE TABLE TEAM_PLAYER(
	teamPlayerID INT PRIMARY KEY IDENTITY(1,1) not null,
    playerID INT,
    teamID INT,
	playerYear int,
	FOREIGN KEY (playerID) REFERENCES PLAYER(playerID),
	FOREIGN KEY (teamID) REFERENCES TEAM(teamID)
);

drop table PLAYER_PLAY
CREATE TABLE PLAYER_PLAY(
	playerPlayID INT PRIMARY KEY IDENTITY(1,1) not null,
    playID INT,
    positionID INT,
    playerID INT,
	FOREIGN KEY (playID) REFERENCES PLAY(playID),
	FOREIGN KEY(positionID) REFERENCES POS(positionID),
	FOREIGN KEY (playerID) REFERENCES PLAYER(playerID)
);

drop table PLAYER_MOMENT
CREATE TABLE PLAYER_MOMENT(
	playerMomentID INT PRIMARY KEY IDENTITY(1,1) not null,
	playerTimeStamp numeric(10,0),
	fieldX float,
	fieldY float,
    playerPlayID INT,
    FOREIGN KEY (playerPlayID) REFERENCES  PLAYER_PLAY(playerPlayID)
);

drop table BALL_POS
CREATE TABLE BALL_POS(
	ballPosID INT PRIMARY KEY IDENTITY(1,1) not null,
	ballTimeStamp INT,
	ballPositionX float,
	ballPositionY float,
	ballPositionZ float,
    playID INT,
    FOREIGN KEY (playID) REFERENCES PLAY(playID)
)


