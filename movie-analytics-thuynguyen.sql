-- ==========================================
-- Movie & TV Analytics SQL Project
-- Built using an original dataset I personally compiled for analyzing movie and television industry data
-- Author: Thuy Nguyen
-- Includes queries across actors, shows, genres, and viewership

-- ============================

-- ====================================================================================
-- Developer: Thuy Nguyen
-- Date: 02/25/2025
-- ====================================================================================
-- this statement will prevent messages of "(1 row(s) affected)"
SET NOCOUNT ON
-- ====================================================================================
-- START CreateTablesForHomeworks
-- ====================================================================================

-- ====================================================================================
-- drop foreign keys
-- ====================================================================================


-- drop (destroy) the relationship between Show and Genre
IF OBJECT_ID('FK_Show_Genre') IS NOT NULL
	ALTER TABLE Show DROP CONSTRAINT IF EXISTS FK_Show_Genre

-- drop (destroy) the relationship between Show and Director
IF OBJECT_ID('FK_Show_Director') IS NOT NULL
	ALTER TABLE Show DROP CONSTRAINT IF EXISTS FK_Show_Director

-- drop (destroy) the relationship between Role and Actor
IF OBJECT_ID('FK_Role_Actor') IS NOT NULL
	ALTER TABLE Role DROP CONSTRAINT IF EXISTS FK_Role_Actor

-- drop (destroy) the relationship between Role and Show
IF OBJECT_ID('FK_Role_Show') IS NOT NULL
	ALTER TABLE Role DROP CONSTRAINT IF EXISTS FK_Role_Show

-- drop (destroy) the relationship between ShowAward and Award
IF OBJECT_ID('FK_ShowAward_Award') IS NOT NULL
	ALTER TABLE ShowAward DROP CONSTRAINT IF EXISTS FK_ShowAward_Award

-- drop (destroy) the relationship between ShowAward and Show
IF OBJECT_ID('FK_ShowAward_Show') IS NOT NULL
	ALTER TABLE ShowAward DROP CONSTRAINT IF EXISTS FK_ShowAward_Show

-- drop (destroy) the relationship between Viewer and Viewer (Unary)
IF OBJECT_ID('FK_Viewer_Viewer') IS NOT NULL
	ALTER TABLE Viewer DROP CONSTRAINT IF EXISTS FK_Viewer_Viewer

-- drop (destroy) the relationship between Viewing and Platform
IF OBJECT_ID('FK_Viewing_Platform') IS NOT NULL
	ALTER TABLE Viewing DROP CONSTRAINT IF EXISTS FK_Viewing_Platform

-- drop (destroy) the relationship between Viewing and Viewer
IF OBJECT_ID('FK_Viewing_Viewer') IS NOT NULL
	ALTER TABLE Viewing DROP CONSTRAINT IF EXISTS FK_Viewing_Viewer

-- drop (destroy) the relationship between Viewing and Show
IF OBJECT_ID('FK_Viewing_Show') IS NOT NULL
	ALTER TABLE Viewing DROP CONSTRAINT IF EXISTS FK_Viewing_Show

-- ====================================================================================
-- drop tables
-- ====================================================================================
DROP TABLE IF EXISTS Role
DROP TABLE IF EXISTS Viewing
DROP TABLE IF EXISTS ShowAward
DROP TABLE IF EXISTS Show
DROP TABLE IF EXISTS Genre
DROP TABLE IF EXISTS Director
DROP TABLE IF EXISTS Platform
DROP TABLE IF EXISTS Award
DROP TABLE IF EXISTS Viewer
DROP TABLE IF EXISTS Actor

-- ====================================================================================
-- create tables
-- ====================================================================================
-- create the Genre table
CREATE TABLE Genre
(
	GenreID INT IDENTITY(1, 1) NOT NULL ,
	GenreDescription VARCHAR(50) NOT NULL ,
	CONSTRAINT PK_Genre PRIMARY KEY CLUSTERED ( GenreID ASC )
)

-- create the Director table
CREATE TABLE Director
(
	DirectorID INT IDENTITY(1, 1) NOT NULL ,
	FirstName VARCHAR(25) NOT NULL ,
	LastName VARCHAR(50) NOT NULL ,
    Gender CHAR(1) NULL,
	CONSTRAINT PK_Director PRIMARY KEY CLUSTERED ( DirectorID ASC )
)

-- create the Show table
CREATE TABLE Show
(
	ShowID INT IDENTITY(1, 1) NOT NULL ,
	Title VARCHAR(50) NOT NULL ,
	DateReleased DATE NOT NULL ,
	Description VARCHAR(100) NOT NULL ,
	BoxOfficeEarnings DECIMAL(15,2) NOT NULL ,
    IMDBRating INT NOT NULL ,
    IsMovie BIT NOT NULL ,
    GenreID INT NOT NULL ,
    DirectorID INT NOT NULL ,
	CONSTRAINT PK_Show PRIMARY KEY CLUSTERED ( ShowID ASC ) 
)

-- create the Award table
CREATE TABLE Award
(
	AwardID INT IDENTITY(1, 1) NOT NULL ,
	Name VARCHAR(50) NOT NULL ,
	CONSTRAINT PK_Award PRIMARY KEY CLUSTERED ( AwardID ASC )
)

-- create the ShowAward table
CREATE TABLE ShowAward
(
    ShowID INT NOT NULL ,
	AwardID INT NOT NULL ,
    YearWon INT NOT NULL,
	CONSTRAINT PK_ShowAward PRIMARY KEY CLUSTERED ( ShowID ASC, AwardID ASC )
)

-- create the Actor table
CREATE TABLE Actor
(
	ActorID INT IDENTITY(1, 1) NOT NULL ,
	FirstName VARCHAR(25) NOT NULL ,
	LastName VARCHAR(50) NOT NULL ,
	Gender CHAR(1)  NULL ,
	CONSTRAINT PK_Actor PRIMARY KEY CLUSTERED ( ActorID ASC )
)

-- create the Role table
CREATE TABLE Role
(
    ShowID INT NOT NULL ,
	ActorID INT NOT NULL ,
    CharacterName VARCHAR(50) NOT NULL,
    Salary INT NOT NULL,
	CONSTRAINT PK_Role PRIMARY KEY CLUSTERED ( ShowID ASC, ActorID ASC )
)

-- create the Platform table
CREATE TABLE Platform
(
	PlatformID INT IDENTITY(1, 1) NOT NULL ,
	PlatformName VARCHAR(50) NOT NULL ,
    IsInternetBased BIT NOT NULL,
	CONSTRAINT PK_Platform PRIMARY KEY CLUSTERED ( PlatformID ASC )
)

-- create the Viewer table
CREATE TABLE Viewer
(
	ViewerID INT IDENTITY(1, 1) NOT NULL ,
	FirstName VARCHAR(25) NOT NULL ,
    MI CHAR(1) NULL,
    LastName VARCHAR(50) NOT NULL ,
    Gender CHAR(1) NULL,
    BestFriendID INT NULL ,
	CONSTRAINT PK_Viewer PRIMARY KEY CLUSTERED ( ViewerID ASC )
)

-- create the Viewing table
CREATE TABLE Viewing
(
    ViewerID INT NOT NULL ,
	PlatformID INT NOT NULL ,
	ShowID INT NOT NULL ,
    WatchDateTime DATETIME NOT NULL,
    ViewerRatingStars DECIMAL(3,2) NOT NULL,
	CONSTRAINT PK_Viewing PRIMARY KEY CLUSTERED ( ViewerID ASC, PlatformID ASC, ShowID ASC )
)

-- ====================================================================================
-- create foreign keys
-- ====================================================================================

-- create the relationship between Show and Genre
ALTER TABLE Show
ADD CONSTRAINT FK_Show_Genre
FOREIGN KEY (GenreID)
REFERENCES Genre (GenreID)

-- create the relationship between Show and Director
ALTER TABLE Show
ADD CONSTRAINT FK_Show_Director
FOREIGN KEY(DirectorID)
REFERENCES Director (DirectorID)
 
-- create the relationship between ShowAward and Show
ALTER TABLE ShowAward
ADD CONSTRAINT FK_ShowAward_Show
FOREIGN KEY(ShowID)
REFERENCES Show (ShowID)

-- create the relationship between ShowAward and Award
ALTER TABLE ShowAward
ADD CONSTRAINT FK_ShowAward_Award
FOREIGN KEY(AwardID)
REFERENCES Award (AwardID)

-- create the relationship between Role and Actor
ALTER TABLE Role
ADD CONSTRAINT FK_Role_Actor
FOREIGN KEY(ActorID)
REFERENCES Actor (ActorID)

-- create the relationship between Role and Show
ALTER TABLE Role
ADD CONSTRAINT FK_Role_Show
FOREIGN KEY(ShowID)
REFERENCES Show (ShowID)

-- create the relationship between Viewer and BestFriend (Unary)
ALTER TABLE Viewer
ADD CONSTRAINT FK_Viewer_Viewer
FOREIGN KEY (BestFriendID)
REFERENCES Viewer (ViewerID)

-- create the relationship between Viewing and Platform
ALTER TABLE Viewing
ADD CONSTRAINT FK_Viewing_Platform
FOREIGN KEY(PlatformID)
REFERENCES Platform (PlatformID)

-- create the relationship between Viewing and Viewer
ALTER TABLE Viewing
ADD CONSTRAINT FK_Viewing_Viewer
FOREIGN KEY(ViewerID)
REFERENCES Viewer (ViewerID)

-- create the relationship between Viewing and Show
ALTER TABLE Viewing
ADD CONSTRAINT FK_Viewing_Show
FOREIGN KEY(ShowID)
REFERENCES Show (ShowID)

-- ====================================================================================
-- insert data
-- ====================================================================================

-- insert the Genre records
INSERT INTO Genre ( GenreDescription ) VALUES ('Action')
INSERT INTO Genre ( GenreDescription ) VALUES ('Romance')
INSERT INTO Genre ( GenreDescription ) VALUES ('Horror')
INSERT INTO Genre ( GenreDescription ) VALUES ('Science fiction')
INSERT INTO Genre ( GenreDescription ) VALUES ('Crime')
INSERT INTO Genre ( GenreDescription ) VALUES ('Thriller')
INSERT INTO Genre ( GenreDescription ) VALUES ('Comedy')
INSERT INTO Genre ( GenreDescription ) VALUES ('Animation')
INSERT INTO Genre ( GenreDescription ) VALUES ('Documentary')
INSERT INTO Genre ( GenreDescription ) VALUES ('Fiction')
INSERT INTO Genre ( GenreDescription ) VALUES ('Noir')

-- insert the Director records
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Taylor', 'Sheridan', 'M' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Gareth', 'Evans', 'M' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Shonda', 'Rhimes', 'F' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Amy', 'Sherman-Palladino', 'F' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Mike', 'Flanagan', 'M' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Jennifer', 'Kent', 'F' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Vince', 'Gilligan', 'M' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Michaela', 'Coel', 'F' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Cary Joji', 'Fukunaga', 'M' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Dong-hyuk', 'Hwang', 'M' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Donald', 'Glover', 'M' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Phoebe', 'Waller-Bridge', 'F' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Genndy', 'Tartakovsky', 'M' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Peter', 'Jackson', 'M' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'James', 'Cameron', 'M' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'David', 'Benioff', 'M' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Guillermo', 'del Toro', 'M' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Brett', 'Ratner', 'M' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Ava', 'DuVernay', 'F' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Lana', 'Wachowski', 'F' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Rebecca', 'Sugar', NULL )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Issa', 'Rae', 'F' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Gints', 'Zilbalodis', 'M' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Justin', 'Baldoni', 'M' )
INSERT INTO Director ( FirstName, LastName, Gender ) VALUES ( 'Woody', 'Allen', 'M' )

-- insert the Show records
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Avatar', '2009-12-18', 'A Marine on Pandora faces a tough choice.', 2923000000 , 7.9 , 1 , 4 , 15 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Avatar: The Way of Water', '2022-12-16', 'The Avatar is seen as a destroyer, not a savior.', 2360000000 ,  7.5, 1 , 4 , 15 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Flow', '2024-08-28', 'Animals struggle as water levels rise.', 4000000 , 7.9 , 1 , 8 , 23 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Away', '2019-06-01', 'A boy and a bird journey to find home', 7367 , 6.9 , 1 , 8 , 23 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Breaking Bad', '2008-01-20', 'A chemistry teacher turned meth kingpin.', 1000000000 , 9.5 , 0 , 5 , 7 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'El Camino: A Breaking Bad Movie', '2019-10-11', 'Jesse Pinkman flees his past.', 50000000 , 7.3 , 1 , 6 , 7 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Insecure', '2016-12-25', 'A woman navigates life and love.', 400000000, 8.1, 9, 7 , 22 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Steven Universe: The Movie', '2019-09-02', 'Steven faces his biggest challenge yet.', 24012 , 7.7 , 1 , 8 , 21 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Yellowstone', '2018-06-20', 'A ranching family in Montana defends their land.', 1000000000 , 8.6 , 0 , 6 , 1 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'The Raid: Redemption', '2011-03-23', 'A S.W.A.T. flights to escape.', 8933244 , 7.6 , 1 , 1 , 2 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Game of Thrones', '2011-04-17', 'Noble families battle for a throne.', 5000000000 ,9.2 , 0 , 10 , 16 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'The Haunting of Hill House', '2018-10-12', 'A family is haunted in Hill House.', 300000000 , 8.5 , 0 , 3 , 5 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Selma', '2014-12-25', 'A film about MLK''s fight for voting rights.', 67782762 , 7.5 , 1 , 9 , 19 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Bridgerton', '2020-12-25', 'A family seeks love in high society.', 300000000 , 7.4 , 0 , 2 , 3 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Squid Game', '2021-09-17', 'Players risk lives in deadly games.', 900000000 , 8 , 0 , 6 , 10 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'No Time to Die', '2021-09-30', 'A spy film in the James Bond series.', 774153007 , 7.3 , 1 , 6 , 9 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Pan''s Labyrinth', '2006-10-11', 'A girl is sent to live with a ruthless stepfather.', 83900000 , 8.2 , 1 , 10 , 17 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Prison Break', '2005-08-29', 'A man plans to break his brother out.', 1500000000 , 8.7 , 0 , 6 , 18 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Atlanta', '2016-09-06', 'Two cousins navigate the rap industry.', 300000000 , 8.6 , 0 , 7 , 11 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Fleabag', '2016-07-21', 'A woman navigates life with no filter.', 100000000 , 8.7 , 0 , 7 , 12 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Primal', '2019-10-08', 'A caveman and a dinosaur fight to survive.', 18000000 , 8.7 , 0 , 8 , 13 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'The Matrix', '1999-03-31', 'A hacker discovers a hidden reality.', 4600000000 , 8.7 , 1 , 4 , 20 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'Gilmore Girls: A Year in the Life', '2016-11-25', 'A revival of the classic family drama.', 200000000 , 7.5 , 0 , 7 , 4 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'The Babadook', '2014-05-22', 'A mother and son face a sinister presence.', 10700000 , 6.8 , 1 , 3 , 6 )
INSERT INTO Show ( Title, DateReleased, Description, BoxOfficeEarnings, IMDBRating, IsMovie, GenreID, DirectorID ) VALUES ( 'I May Destroy You', '2020-06-07', 'A woman explores trauma and healing.', 2600000 , 8.1 , 0 , 10 , 8 )

-- insert the Actor records
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Jung-jae', 'Lee', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Hae-soo', 'Park', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Ho-Yeon', 'Jung', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Jesse', 'Plemons', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Krysten', 'Ritter', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Issa', 'Rae', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Yvonne', 'Orji', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Jay', 'Ellis', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Zach', 'Callison', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Deedee Magno', 'Hall', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Kevin', 'Costner', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Luke', 'Grimes', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Kelly', 'Reilly', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Iko', 'Uwais', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Joe', 'Taslim', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Yayan', 'Ruhian', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Emilia', 'Clarke', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Kit', 'Harington', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Peter', 'Dinklage', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Victoria', 'Pedretti', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Oliver', 'Jackson-Cohen', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Carla', 'Gugino', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'David', 'Oyelowo', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Carmen', 'Ejogo', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Oprah', 'Winfrey', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Phoebe', 'Dynevor', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Regé-Jean', 'Page', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Jonathan', 'Bailey', NULL)
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Sam', 'Worthington', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Zoe', 'Saldana', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Sigourney', 'Weaver', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Daniel', 'Craig', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Léa', 'Seydoux', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Rami', 'Malek', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Ivana', 'Baquero', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Sergi', 'López', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Maribel', 'Verdú', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Wentworth', 'Miller', NULL)
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Dominic', 'Purcell', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Sarah Wayne', 'Callies', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Phoebe', 'Waller-Bridge', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Sian', 'Clifford', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Andrew', 'Scott', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Keanu', 'Reeves', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Laurence', 'Fishburne', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Carrie-Anne', 'Moss', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Lauren', 'Graham', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Alexis', 'Bledel', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Kelly', 'Bishop', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Essie', 'Davis', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Noah', 'Wiseman', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Daniel', 'Henshall', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Michaela', 'Coel', NULL)
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Weruche', 'Opia', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Paapa', 'Essiedu', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Tom', 'Hanks', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Natalie', 'Portman', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Denzel', 'Washington', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Emma', 'Stone', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Bryan', 'Cranston', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Aaron', 'Paul', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Anna', 'Gunn', 'F')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Donald', 'Glover', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Brian Tyree', 'Henry', 'M')
INSERT INTO Actor ( FirstName, LastName, Gender ) VALUES ( 'Zazie', 'Beetz', NULL)

-- insert the Role records
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 1, 29, 'Jake Sully', 2000000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 1, 30, 'Neytiri', 10000000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 1, 31, 'Dr. Grace Augustine', 11000000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 2, 29, 'Jake Sully', 2000000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 2, 30, 'Neytiri', 10000000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 2, 31, 'Dr. Grace Augustine', 11000000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 5, 60, 'Walter White', 225000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 5, 61, 'Jesse Pinkman', 150000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 5, 62, 'Skyler White', 100000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 5, 4, 'Todd Alquist', 50000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 5, 5, 'Jane Margolis', 40000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 6, 60, 'Walter White', 1000000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 6, 61, 'Jesse Pinkman', 2000000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 6, 4, 'Todd Alquist', 1000000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 6, 5, 'Jane Margolis', 500000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 7, 6, 'Issa Dee', 100000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 7, 7, 'Molly Carter', 60000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 7, 8, 'Lawrence Walker', 75000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 8, 9, 'Steven Universe' , 800000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 8, 10, 'Pearl', 800000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 9, 11, 'John Dutton', 1000000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 9, 12, 'Kayce Dutton', 200000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 9, 13, 'Beth Dutton', 200000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 10, 14, 'Rama', 300000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 10, 15, 'Jaka', 200000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 10, 16, 'Mad Dog', 150000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 11, 17, 'Daenerys Targaryen', 500000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 11, 18, 'Jon Snow', 500000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 11, 19, 'Tyrion Lannister', 500000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 12, 20, 'Eleanor Vance', 100000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 12, 21, 'Luke Vance', 75000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 12, 22, 'Olivia Vance', 200000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 13, 23, 'Martin Luther King Jr.', 2000000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 13, 24, 'Coretta Scott King', 1000000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 13, 25, 'Annie Lee Cooper', 10000000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 14, 26, 'Daphne Bridgerton', 100000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 14, 27, 'Simon Basset', 150000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 14, 28, 'Anthony Bridgerton', 125000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 15, 1, 'Gi-hun Seong', 200000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 15, 2, 'Sang-woo Cho', 100000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 15, 3, 'Sae-byeok Kang', 50000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 16, 32, 'James Bond', 25000000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 16, 33, 'Madeleine Swann', 10000000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 16, 34, 'Lyutsifer Safin', 10000000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 17, 35, 'Ofelia', 200000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 17, 36, 'Captain Vidal', 500000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 17, 37, 'Mercedes', 1000000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 18, 38, 'Michael Scofield', 175000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 18, 39, 'Lincoln Burrows', 150000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 18, 40, 'Sara Tencredi', 100000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 19, 63, 'Earnest Marks', 1000000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 19, 64, 'Alfred Miles', 200000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 19, 65, 'Vanessa Keefer', 100000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 20, 41, 'Fleabag', 1000000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 20, 42, 'Claire', 100000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 20, 43, 'The Priest', 100000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 22, 44, 'Neo', 10000000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 22, 45, 'Morpheus', 1000000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 22, 46, 'Trinity', 1000000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 23, 47, 'Lorelai Gilmore', 500000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 23, 48, 'Rory Gilmore', 300000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 23, 49, 'Emily Gilmore', 200000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 24, 50, 'Amelia Vanek', 500000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 24, 51, 'Samuel Vanek', 150000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 24, 52, 'Robbie', 200000 )

INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 25, 53, 'Arabella Essiedu', 250000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 25, 54, 'Terry Pratchard', 100000 )
INSERT INTO Role ( ShowID, ActorID, CharacterName, Salary ) VALUES ( 25, 55, 'Kwame', 100000 )

-- insert the Award records
INSERT INTO Award ( Name ) VALUES ( 'Oscars' )
INSERT INTO Award ( Name ) VALUES ( 'Golden Globe' )
INSERT INTO Award ( Name ) VALUES ( 'Primetime Emmy' )
INSERT INTO Award ( Name ) VALUES ( 'Critics'' Choice' )
INSERT INTO Award ( Name ) VALUES ( 'Screen Actors Guild' )
INSERT INTO Award ( Name ) VALUES ( 'BAFTA' )
INSERT INTO Award ( Name ) VALUES ( 'Palme d''Or' )

-- insert the ShowAward records
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 1, 1, 2009 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 2, 1, 2022 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 22, 1, 1999 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 17, 1, 2006 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 1, 2, 2009 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 5, 2, 2014 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 16, 2, 2022 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 2, 2, 2023 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 14, 2, 2021 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 5, 3, 2013 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 22, 3, 1999 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 11, 3, 2015 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 1, 4, 2009 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 6, 4, 2021 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 2, 4, 2023 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 22, 4, 1999 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 14, 4, 2021 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 11, 5, 2015 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 5, 5, 2014 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 16, 5, 2022 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 1, 6, 2009 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 17, 6, 2006 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 22, 6, 1999 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 11, 6, 2015 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 10, 6, 2012 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 12, 3, 2015 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 15, 2, 2022 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 20, 2, 2019 )
INSERT INTO ShowAward ( ShowID, AwardID, YearWon) VALUES ( 25, 4, 2021 )

-- insert the Viewer records (keep best friend ids NULL for now)
INSERT INTO Viewer ( FirstName, MI, LastName, Gender ) VALUES ( 'Wentworth', NULL, 'Miller', NULL )
INSERT INTO Viewer ( FirstName, MI, LastName, Gender ) VALUES ( 'Robert', NULL, 'Knepper', 'M' )
INSERT INTO Viewer ( FirstName, MI, LastName, Gender ) VALUES ( 'Marie', NULL, 'Curie', 'F' )
INSERT INTO Viewer ( FirstName, MI, LastName, Gender ) VALUES ( 'William', NULL, 'Fitchner', 'M' )
INSERT INTO Viewer ( FirstName, MI, LastName, Gender ) VALUES ( 'Bella', 'Q', 'Shelby', 'F')
INSERT INTO Viewer ( FirstName, MI, LastName, Gender ) VALUES ( 'Thuy', 'C', 'Nguyen', 'F' )
INSERT INTO Viewer ( FirstName, MI, LastName, Gender ) VALUES ( 'Nobita', NULL, 'Nobi', 'M' )
INSERT INTO Viewer ( FirstName, MI, LastName, Gender ) VALUES ( 'Doraemon', 'M', 'Nobi', NULL )
INSERT INTO Viewer ( FirstName, MI, LastName, Gender ) VALUES ( 'Shizuka', NULL, 'Minamoto', 'F' )
INSERT INTO Viewer ( FirstName, MI, LastName, Gender ) VALUES ( 'Dekisugi', NULL, 'Hidetoshi', 'M' )
INSERT INTO Viewer ( FirstName, MI, LastName, Gender ) VALUES ( 'Soon-young', NULL, 'Kwon', 'M' )
INSERT INTO Viewer ( FirstName, MI, LastName, Gender ) VALUES ( 'Won-woo', NULL, 'Jeon', 'M' )
INSERT INTO Viewer ( FirstName, MI, LastName, Gender ) VALUES ( 'Chau', 'B', 'Le', 'F' )
INSERT INTO Viewer ( FirstName, MI, LastName, Gender ) VALUES ( 'Do-kyeom', NULL, 'Lee', 'M' )
INSERT INTO Viewer ( FirstName, MI, LastName, Gender ) VALUES ( 'Vernon', NULL, 'Chwe', 'M' )

select a.ActorID, r.ShowID
from Actor a
left outer join Role r
on a.ActorID = r.ActorID
 
-- Now UPDATE the Viewer table's best friend ID (BestFriendID) for SOME viewers (not all) - make sure that no one is their own best friend
UPDATE Viewer SET BestFriendID = 1 WHERE ViewerID = 2
UPDATE Viewer SET BestFriendID = 1 WHERE ViewerID = 3
UPDATE Viewer SET BestFriendID = 2 WHERE ViewerID = 6
UPDATE Viewer SET BestFriendID = 6 WHERE ViewerID = 5
UPDATE Viewer SET BestFriendID = 6 WHERE ViewerID = 14
UPDATE Viewer SET BestFriendID = 6 WHERE ViewerID = 15
UPDATE Viewer SET BestFriendID = 5 WHERE ViewerID = 8
UPDATE Viewer SET BestFriendID = 9 WHERE ViewerID = 10
UPDATE Viewer SET BestFriendID = 4 WHERE ViewerID = 6
UPDATE Viewer SET BestFriendID = 13 WHERE ViewerID = 11
UPDATE Viewer SET BestFriendID = 13 WHERE ViewerID = 12
UPDATE Viewer SET BestFriendID = 15 WHERE ViewerID = 5
UPDATE Viewer SET BestFriendID = 9 WHERE ViewerID = 7
UPDATE Viewer SET BestFriendID = 7 WHERE ViewerID = 9


-- insert the Platform records
INSERT INTO Platform ( PlatformName, IsInternetBased) VALUES ( 'Netlix', 1)
INSERT INTO Platform ( PlatformName, IsInternetBased) VALUES ( 'Hulu', 1)
INSERT INTO Platform ( PlatformName, IsInternetBased) VALUES ( 'Disney+', 1)
INSERT INTO Platform ( PlatformName, IsInternetBased) VALUES ( 'Apple TV+', 1)
INSERT INTO Platform ( PlatformName, IsInternetBased) VALUES ( 'Peacock', 1)
INSERT INTO Platform ( PlatformName, IsInternetBased) VALUES ( 'Max', 1)
INSERT INTO Platform ( PlatformName, IsInternetBased) VALUES ( 'DVD', 0)
INSERT INTO Platform ( PlatformName, IsInternetBased) VALUES ( 'Airplane Entertainment Systems', 0)

-- insert the Viewing records
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 13, 4, 1, '2017-11-03 16:45:30', 8.56 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 3, 2, 3, '2025-02-26 05:05:05', 8.12 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 4, 1, 5, '2009-02-14 06:30:00', 9.98 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 10, 8, 7, '2019-03-25 10:30:45', 7.34 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 9, 2, 18, '2007-10-08 21:18:40', 9.67 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 15, 3, 12, '2020-01-01 00:00:01', 9.33 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 5, 5, 9, '2024-09-18 07:55:20', 9.17 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 7, 6, 6, '2020-07-04 11:11:11', 9.55 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 11, 8, 14, '2023-08-16 03:47:44', 8.99 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 12, 6, 22, '2000-03-28 16:01:56', 9.73 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 6, 1, 19, '2019-08-12 19:47:44', 8.82 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 8, 2, 16, '2023-11-10 03:07:16', 9.54 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 10, 2, 11, '2021-11-06 10:36:52', 9.24 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 14, 3, 2, '2022-12-19 03:45:17', 6.26 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 2, 4, 25, '2020-09-16 19:30:56', 7.92 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 9, 3, 4, '2019-08-25 10:30:45', 7.65 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 7, 6, 13, '2016-03-08 08:28:28', 8.42 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 5, 8, 10, '2024-02-24 23:49:00', 7.91 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 15, 4, 20, '2018-01-21 14:37:20', 8.88 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 13, 5, 15, '2021-11-28 16:33:11', 7.84 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 5, 3, 23, '2018-11-24 23:59:15', 8.37 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 6, 3, 17, '2008-07-12 21:50:00', 8.14 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 7, 2, 13, '2018-12-01 17:45:32', 7.77 )
INSERT INTO Viewing (ViewerID, PlatformID, ShowID, WatchDateTime, ViewerRatingStars) VALUES ( 12, 1, 5, '2009-01-18 19:21:25', 9.43 )

-- ====================================================================================
-- Select all the data from all the tables, being sure to -- Removed server-specific USE statement alias that 
-- makes sense for each statement
-- ====================================================================================
SELECT *
FROM Director d

SELECT *
FROM Genre g

SELECT *
FROM Show s

SELECT *
FROM Actor a

SELECT *
FROM Role r

SELECT *
FROM Award aw

SELECT *
FROM ShowAward sa

SELECT * 
FROM Platform p

SELECT *
FROM Viewer v

SELECT *
FROM Viewing w

-- ====================================================================================
-- END CreateTablesForHomeworks
-- ====================================================================================

-- ====================================================================================
-- this statement will prevent messages of "(1 row(s) affected)"
SET NOCOUNT ON
-- ====================================================================================

SELECT * FROM Show s
SELECT * FROM Director d
SELECT * FROM Genre g
SELECT * FROM ShowAward sa
SELECT * FROM Award aw
SELECT * FROM Role r
SELECT * FROM Actor a
SELECT * FROM Platform p
SELECT * FROM Viewer v
SELECT * FROM Viewing vw

-- ========================================================
-- Q1:
-- List all shows' name (with their descriptions) and director's name
-- Only shows that are directed by male directors
-- Order by show Title

SELECT s.Title, s.Description, d.FirstName + ' '+ d.LastName AS DirectorName
FROM Show s 
INNER JOIN Director d ON s.DirectorID = d.DirectorID
WHERE d.Gender = 'M'
ORDER BY s.Title

-- Q2.
-- List all actors that did not play any movie in the database
-- order by LastName, FirstName

SELECT a.FirstName + ' '+ a.LastName AS ActorName
FROM Actor a
LEFT OUTER JOIN Role r ON a.ActorID = r.ActorID
WHERE r.ActorID is NULL
ORDER BY a.LastName, a.FirstName

-- Q3.
-- List all actors that plays more than 1 show, also list show's Title, CharacterName, Salary and Genre.
-- order by Salary descendingly, Title and Actor's LastName.

SELECT a.FirstName + ' '+ a.LastName AS ActorName, s.Title, r.CharacterName, r.Salary, g.GenreDescription
FROM Actor a 
INNER JOIN Role r ON a.ActorID = r.ActorID
INNER JOIN Show s ON r.ShowID = s.ShowID
INNER JOIN Genre g ON s.GenreID = g.GenreID
WHERE a.ActorID IN (
    SELECT r.ActorID
    FROM Role r 
    GROUP BY r.ActorID
    HAVING COUNT(r.ShowID)>1
)
ORDER BY r.Salary DESC, s.Title, a.LastName

-- Q4.
-- List all awards that haven't been won by any show. 

SELECT a.Name
FROM Award a 
LEFT OUTER JOIN ShowAward sa ON a.AwardID = sa.AwardID
WHERE sa.YearWon is NULL

-- Q5.
-- List all viewers, the shows' Title, and PlatformName they streamed on.
-- Make sure only return viewers who don't have a BestFriend
-- Order by LastName, FirstName

SELECT v.FirstName, v.LastName, s.Title, p.PlatformName
FROM Viewer v 
LEFT OUTER JOIN Viewing vw ON v.ViewerID = vw.ViewerID
LEFT OUTER JOIN Show s ON vw.ShowID = s.ShowID
INNER JOIN Platform p ON vw.PlatformID = p.PlatformID
WHERE v.BestFriendID IS NULL
ORDER BY v.LastName, v.FirstName

-- Q6.
-- List top 3 viewers that watched most movies. That includes their names, counts of the movies they watched
-- Movies must be streamed on Internet-based platform.
-- Order by top streamers (because we're doing top 3)

SELECT TOP 3 v.FirstName, v.MI, v.LastName, COUNT(vw.ShowID) AS numShowsViewed
FROM Viewer v 
INNER JOIN Viewing vw ON v.ViewerID = vw.ViewerID
INNER JOIN Platform p ON vw.PlatformID = p.PlatformID
WHERE p.IsInternetBased = 1
GROUP BY v.FirstName, v.MI, v.LastName
ORDER BY COUNT(vw.ShowID) DESC

-- Q7.
-- List shows where:
-- The difference between average viewer's first-watch rating & the IMDB rating 
-- (will be called viewerRatingDev) is no more than 10%. 
-- Only list the shows that's been watched by at least 1 viewer (By inner joining Viewing table)
-- Display the show's title, IMDB rating, and the percentage difference.
-- Assume every movie has a unique title
-- Order by viewerRatingDev 

SELECT s.Title, s.IMDBRating, ((AVG(vw.ViewerRatingStars)- s.IMDBRating)/s.IMDBRating)*100 AS viewerRatingDev
FROM Show s 
INNER JOIN Viewing vw ON s.ShowID = vw.ShowID
GROUP BY s.Title, s.IMDBRating
HAVING ABS((AVG(vw.ViewerRatingStars)- s.IMDBRating)/s.IMDBRating) <= .10
ORDER BY viewerRatingDev

-- Q8.
-- List the genre (GenreDescription) from most rewarded awards to least (even if it has zero award)
-- List the total number of awards won (instead of shows) count.

SELECT g.GenreDescription, COUNT(sa.YearWon) AS numAwardsWon
FROM Genre g
LEFT OUTER JOIN Show s ON g.GenreID = s.GenreID
LEFT OUTER JOIN ShowAward sa ON s.ShowID = sa.ShowID
GROUP BY g.GenreID, g.GenreDescription
ORDER BY numAwardsWon DESC

-- Q9.
-- List Show's title that number of Roles in that show is not 3 
-- List total number of Roles for each show.
-- Order by count of number of Roles, title 

SELECT s.Title, COUNT(r.CharacterName) AS numCharacters
FROM Show s 
LEFT OUTER JOIN Role r ON s.ShowID = r.ShowID
GROUP BY s.Title
HAVING COUNT(r.CharacterName) != 3
ORDER BY numCharacters, s.Title

-- Q10.
-- Top 10 shows that pays all their actors/actresses the most (List show's title and total pay)
-- And name of the Director who directed that show.
-- Order by total pay, then director's last name, director's first name.

SELECT TOP 10 s.Title, SUM(r.Salary) AS totalPay, d.FirstName, d.LastName
FROM Show s 
LEFT OUTER JOIN Role r ON s.ShowID = r.ShowID
INNER JOIN Director d ON s.DirectorID = d.DirectorID
GROUP BY s.Title, d.LastName, d.FirstName
ORDER BY totalPay DESC

