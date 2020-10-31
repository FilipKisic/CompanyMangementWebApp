CREATE DATABASE RWA_App
GO
USE RWA_App
GO

CREATE TABLE TeamLeader
(
	WorkerID INT UNIQUE NOT NULL,
	IsActive BIT NOT NULL
)
GO

CREATE TABLE Team
(
	IDTeam INT PRIMARY KEY IDENTITY,
	Title NVARCHAR(50) NOT NULL,
	DateOfCreation NVARCHAR(50) NOT NULL,
	TeamLeaderID INT,
	IsActive BIT NOT NULL,
	FOREIGN KEY (TeamLeaderID) REFERENCES TeamLeader(WorkerID)
)
GO

CREATE TABLE Client
(
	IDClient INT PRIMARY KEY IDENTITY,
	Title NVARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL
)
GO

CREATE TABLE Worker
(
		IDWorker INT PRIMARY KEY IDENTITY,
		FirstName NVARCHAR(50) NOT NULL,
		LastName NVARCHAR(50) NOT NULL,
		Email NVARCHAR(50) NOT NULL,
		DateOfEmployment NVARCHAR(50) NOT NULL,
		PSWRD NVARCHAR(50) NOT NULL,
		TypeOfEmployee NVARCHAR(50) NOT NULL,
		TeamID INT DEFAULT NULL,
		IsActive BIT NOT NULL,
		IsTeamLeader BIT NOT NULL,
		IsCEO BIT NOT NULL,
		FOREIGN KEY (TeamID) REFERENCES Team(IDTeam)
)
GO

CREATE TABLE Project 
(
	IDProject INT PRIMARY KEY IDENTITY,
	Title NVARCHAR(50) NOT NULL,
	ClientID INT NOT NULL,
	DateOfStart NVARCHAR(50) NOT NULL,
	ProjectLeaderID INT NOT NULL,
	IsActive BIT NOT NULL,
	FOREIGN KEY (ProjectLeaderID) REFERENCES Worker(IDWorker),
	FOREIGN KEY (ClientID) REFERENCES Client(IDClient)
)
GO

CREATE TABLE Project_Team
(
	ProjectID INT NOT NULL,
	TeamID INT NOT NULL,
	FOREIGN KEY (ProjectID) REFERENCES Project(IDProject),
	FOREIGN KEY (TeamID) REFERENCES Team(IDTeam)
)
GO

CREATE TABLE Activity
(
	IDActivity INT PRIMARY KEY IDENTITY,
	ActivityName NVARCHAR(255),
	ProjectID INT NULL,
	FOREIGN KEY (ProjectID) REFERENCES Project(IDProject),
)
GO

INSERT INTO Activity (ActivityName) VALUES ('Pauza')
INSERT INTO Activity (ActivityName) VALUES ('Godišnji odmor')
INSERT INTO Activity (ActivityName) VALUES ('Bolovanje')

CREATE TABLE Activity_Worker
(
	ActivityID INT,
	WorkerID INT,
	PersonalDurationInMinutes INT,
	FOREIGN KEY (ActivityID) REFERENCES Activity(IDActivity),
	FOREIGN KEY (WorkerID) REFERENCES Worker(IDWorker)
)
GO

/* TEAM LEADER OPERATOINS*/
CREATE PROC spCreateTeamLeader
	@WorkerID INT,
	@IsActive BIT
AS
BEGIN 
	INSERT INTO TeamLeader VALUES (@WorkerID, @IsActive)
END
GO

CREATE PROC spSelectTeamLeader
	@WorkerID INT
AS
BEGIN
	SELECT tl.WorkerID, w.FirstName + ' ' + w.LastName AS FullName, tl.IsActive FROM TeamLeader AS tl
	INNER JOIN Worker AS w ON tl.WorkerID = w.IDWorker
	WHERE tl.WorkerID = @WorkerID
END
GO

CREATE PROC spSelectTeamLeaders
AS
BEGIN
	SELECT tl.WorkerID, w.FirstName + ' ' + w.LastName AS FullName, tl.IsActive FROM TeamLeader AS tl
	INNER JOIN Worker AS w ON tl.WorkerID = w.IDWorker
END
GO

CREATE PROC spUpdateTeamLeader
	@WorkerID INT,
	@IsActive BIT
AS
BEGIN
	UPDATE TeamLeader SET IsActive = @IsActive WHERE WorkerID = @WorkerID
END
GO

CREATE PROC spDeleteTeamLeader
	@WorkerID INT
AS
BEGIN
	UPDATE TeamLeader SET IsActive = 0 WHERE WorkerID = @WorkerID
END
GO

CREATE PROC spAddExistingTeamLeader
	@IDWorker INT,
	@IDTeam INT
AS
BEGIN
	UPDATE Team SET TeamLeaderID = @IDWorker WHERE IDTeam = @IDTeam
	UPDATE Worker SET IsTeamLeader = 0 WHERE IDWorker NOT IN (SELECT TeamLeaderID FROM Team)
	DELETE FROM TeamLeader WHERE WorkerID NOT IN (SELECT TeamLeaderID FROM Team)
END
GO

CREATE PROC spAddNewTeamLeader
	@IDWorker INT,
	@IDTeam INT
AS
BEGIN
	INSERT INTO TeamLeader VALUES (@IDWorker, 1)
	UPDATE Worker SET IsTeamLeader = 1 WHERE IDWorker = @IDWorker
	UPDATE Team SET TeamLeaderID = @IDWorker WHERE IDTeam = @IDTeam
	UPDATE Worker SET IsTeamLeader = 0 WHERE IDWorker NOT IN (SELECT TeamLeaderID FROM Team)
	DELETE FROM TeamLeader WHERE WorkerID NOT IN (SELECT TeamLeaderID FROM Team)
END
GO

/* PROJECT OPERATIONS */
CREATE PROC spCreateProject
	@IDProject INT OUTPUT,
	@Title NVARCHAR(50),
	@ClientID INT,
	@DateOfStart NVARCHAR(50),
	@ProjectLeaderID INT,
	@IsActive BIT
AS
BEGIN
	INSERT INTO Project VALUES (@Title, @ClientID, @DateOfStart, @ProjectLeaderID, @IsActive)
	SET @IDProject = SCOPE_IDENTITY()
END
GO

CREATE PROC spSelectProject
	@IDProject INT
AS 
BEGIN 
	SELECT p.IDProject, p.Title, p.ClientID, c.Title AS Client, p.DateOfStart, p.ProjectLeaderID, w.FirstName + ' ' + w.LastName AS FullName, p.IsActive FROM Project AS p
	INNER JOIN Worker AS w ON p.ProjectLeaderID = w.IDWorker
	INNER JOIN Client AS c ON c.IDClient = p.ClientID
	WHERE IDProject = @IDProject
END
GO

CREATE PROC spSelectProjects
AS
BEGIN
	SELECT p.IDProject, p.Title, c.Title AS Client, w.FirstName + ' ' + w.LastName AS FullName, p.DateOfStart, p.IsActive FROM Project AS p
	INNER JOIN Worker AS w ON p.ProjectLeaderID = w.IDWorker
	INNER JOIN Client AS c ON c.IDClient = p.ClientID
END
GO

CREATE PROC spSelectActiveProjects
AS
BEGIN
	SELECT IDProject, Title FROM Project WHERE IsActive = 1
END
GO

CREATE PROC spUpdateProject
	@IDProject INT,
	@Title NVARCHAR(50),
	@ClientID INT,
	@DateOfStart NVARCHAR(50),
	@ProjectLeaderID INT,
	@IsActive BIT
AS
BEGIN 
	UPDATE Project SET Title = @Title, ClientID = @ClientID, DateOfStart = @DateOfStart, ProjectLeaderID = @ProjectLeaderID, IsActive = @IsActive
	WHERE IDProject = @IDProject
END
GO

CREATE PROC spUpdateProjectStatus
	@IDProject INT,
	@IsActive BIT
AS
BEGIN
	UPDATE Project SET IsActive = @IsActive WHERE IDProject = @IDProject
END
GO

CREATE PROC spDeleteProject
	@IDProject INT
AS
BEGIN
	UPDATE Project SET IsActive = 0 WHERE IDProject = @IDProject
END
GO

/* ACTIVITY_WORKER OPERATIONS*/
CREATE PROC spLinkActivityAndTeam
	@ActivityID INT,
	@TeamID INT
AS
BEGIN
	INSERT INTO Activity_Worker (ActivityID, WorkerID, PersonalDurationInMinutes)
	SELECT @ActivityID, IDWorker, 0 FROM Worker WHERE TeamID = @TeamID
END
GO

CREATE PROC spLinkActivityAndWorker
	@ActivityID INT,
	@WorkerID INT
AS
BEGIN
	INSERT INTO Activity_Worker VALUES (@ActivityID, @WorkerID, 0)
END
GO

CREATE PROC spUnlinkActivityAndWorker 
	@ActivityID INT
AS
BEGIN
	DELETE FROM Activity_Worker WHERE ActivityID = @ActivityID
END
GO

CREATE PROC spUpdatePersonalMinutes
	@ActivityID INT,
	@WorkerID INT,
	@Duration INT
AS
BEGIN
	UPDATE Activity_Worker SET PersonalDurationInMinutes = @Duration WHERE ActivityID = @ActivityID AND WorkerID = @WorkerID
END
GO

CREATE PROC spSelectClientsActivities
	@ClientID INT
AS
BEGIN
	SELECT a.ActivityName, SUM(aw.PersonalDurationInMinutes) AS DurationInMinutes FROM Activity_Worker AS aw
	INNER JOIN Activity AS a ON aw.ActivityID = a.IDActivity
	INNER JOIN Project AS p ON a.ProjectID = p.IDProject
	WHERE p.ClientID = @ClientID
	GROUP BY a.ActivityName
END
GO

/* ACTIVITY OPERATIONS */
CREATE PROC spAddActivity
	@ProjectID INT,
	@TeamID INT
AS
BEGIN 
	DECLARE @Name NVARCHAR(255)
	DECLARE @IDActivity INT
	SELECT @Name = Title FROM Project WHERE IDProject = @ProjectID
	INSERT INTO Activity (ProjectID, ActivityName) VALUES (@ProjectID, @Name)
	SET @IDActivity = SCOPE_IDENTITY()
	EXEC spLinkActivityAndTeam @IDActivity, @TeamID
END
GO

CREATE PROC spDeleteActivity
	@ProjectID INT
AS
BEGIN
	DECLARE @ActivityID INT
	SELECT @ActivityID = IDActivity FROM Activity WHERE ProjectID = @ProjectID
	EXEC spUnlinkActivityAndWorker @ActivityID
	DELETE FROM Activity WHERE ProjectID = @ProjectID
END
GO

CREATE PROC spSelectActivitesForWorker
	@WorkerID INT
AS
BEGIN
	SELECT DISTINCT a.IDActivity, a.ProjectID, a.ActivityName AS Title FROM Activity_Worker AS aw
	RIGHT JOIN Activity AS a ON a.IDActivity = aw.ActivityID
	WHERE aw.WorkerID = @WorkerID OR a.ProjectID IS NULL
END
GO

CREATE PROC spSelectActivity
	@IDActivity INT,
	@IDWorker INT
AS
BEGIN
	SELECT a.IDActivity, a.ActivityName, (SELECT SUM(PersonalDurationInMinutes) FROM Activity_Worker WHERE ActivityID = @IDActivity) AS DurationInMinutes, a.ProjectID, aw.PersonalDurationInMinutes FROM Activity AS a
	INNER JOIN Activity_Worker AS aw ON a.IDActivity = aw.ActivityID
	WHERE a.IDActivity = @IDActivity AND aw.WorkerID = @IDWorker
END
GO

/* WORKER OPERATIONS */
CREATE PROC spCreateWorker
	@FirstName NVARCHAR(50),
	@LastName NVARCHAR(50),
	@Email NVARCHAR(50),
	@DateOfEmployment NVARCHAR(50),
	@PSWRD NVARCHAR(50),
	@TypeOfEmployee NVARCHAR(50),
	@TeamID INT,
	@IsActive BIT,
	@IsTeamLeader BIT,
	@IsCEO BIT
AS
BEGIN
	DECLARE @IDWorker INT
	INSERT INTO Worker VALUES (@FirstName, @LastName, @Email, @DateOfEmployment, @PSWRD, @TypeOfEmployee, @TeamID, @IsActive, @IsTeamLeader, @IsCEO)
	SET @IDWorker = SCOPE_IDENTITY()
	IF (@IsTeamLeader = 1)
	BEGIN
		EXEC spCreateTeamLeader @IDWorker, @IsActive
	END
	EXEC spLinkActivityAndWorker 1, @IDWorker /*Add all default acitivites*/
	EXEC spLinkActivityAndWorker 2, @IDWorker
	EXEC spLinkActivityAndWorker 3, @IDWorker
END
GO

CREATE PROC spSelectWorker
	@IDWorker INT
AS
BEGIN
	IF (SELECT TeamID FROM Worker WHERE IDWorker = @IDWorker) IS NOT NULL
	BEGIN
		SELECT w.*, t.Title FROM Worker AS w
		INNER JOIN Team AS t ON w.TeamID = t.IDTeam
		WHERE IDWorker = @IDWorker
	END
	ELSE
	BEGIN
		SELECT IDWorker, FirstName, LastName, Email, DateOfEmployment, PSWRD, TypeOfEmployee, 0 AS TeamID, IsActive, IsTeamLeader, IsCEO, 'Nema' AS Title FROM Worker WHERE IDWorker = @IDWorker
	END
END
GO

CREATE PROC spGetWorker
	@FirstName NVARCHAR(50),
	@LastName NVARCHAR(50)
AS
BEGIN
	IF (SELECT TeamID FROM Worker WHERE FirstName = @FirstName AND LastName = @LastName) IS NOT NULL
	BEGIN
		SELECT IDWorker, FirstName, LastName, Email, DateOfEmployment, PSWRD, TypeOfEmployee, TeamID, IsActive, IsTeamLeader, IsCEO 
		FROM Worker WHERE FirstName = @FirstName AND LastName = @LastName
	END
	ELSE
	BEGIN
		SELECT IDWorker, FirstName, LastName, Email, DateOfEmployment, PSWRD, TypeOfEmployee, 0 AS TeamID, IsActive, IsTeamLeader, IsCEO FROM Worker WHERE FirstName = @FirstName AND LastName = @LastName
	END
END
GO

CREATE PROC spSelectWorkers
AS
BEGIN
	SELECT * FROM Worker
END
GO

CREATE PROC spSelectWorkersWithFullName
AS
BEGIN
	SELECT IDWorker, FirstName + ' ' + LastName AS FullName FROM Worker WHERE IsActive = 1
END
GO

CREATE PROC spSelectTeamLeaderFlags
AS
BEGIN
	SELECT IDWorker, IsTeamLeader FROM Worker
END
GO

CREATE PROC spUpdateWorker
	@IDWorker INT,
	@FirstName NVARCHAR(50),
	@LastName NVARCHAR(50),
	@Email NVARCHAR(50),
	@DateOfEmployment NVARCHAR(50),
	@PSWRD NVARCHAR(50),
	@TypeOfEmployee NVARCHAR(50),
	@TeamID INT,
	@IsActive BIT,
	@IsTeamLeader BIT,
	@IsCEO BIT
AS
BEGIN
	IF (@TeamID = 0)
		SET @TeamID = NULL
	UPDATE Worker SET FirstName = @FirstName, LastName = @LastName, Email = @Email, DateOfEmployment = @DateOfEmployment, PSWRD = @PSWRD, TypeOfEmployee = @TypeOfEmployee, TeamID = @TeamID, IsActive = @IsActive, IsTeamLeader = @IsTeamLeader, IsCEO = @IsCEO
	WHERE IDWorker = @IDWorker
END
GO

CREATE PROC spUpdateWorkerStatus
	@IsActive BIT,
	@Email NVARCHAR(50)
AS
BEGIN
	DECLARE @IDWorker INT
	UPDATE Worker SET IsActive = @IsActive WHERE Email = @Email
	SELECT IDWorker FROM Worker WHERE Email = @Email
	EXEC spUpdateTeamLeader @IDWorker, @IsActive
END
GO

CREATE PROC spUpdateWorkerTeamID
	@IDTeam INT,
	@FirstName NVARCHAR(50),
	@LastName NVARCHAR(50)
AS
BEGIN
	UPDATE Worker SET TeamID = @IDTeam WHERE FirstName = @FirstName AND LastName = @LastName
END
GO

CREATE PROC spUpdateWorkerTeamLeaderFlag
	@IDWorker INT,
	@IsTeamLeader BIT
AS
BEGIN 
	UPDATE Worker SET IsTeamLeader = @IsTeamLeader WHERE IDWorker = @IDWorker
END
GO

CREATE PROC spDeleteWorker
	@IDWorker INT
AS
BEGIN
	UPDATE Worker SET IsActive = 0 WHERE IDWorker = @IDWorker
	IF((SELECT IsTeamLeader FROM Worker WHERE IDWorker = @IDWorker) = 1)
	BEGIN
		EXEC spDeleteTeamLeader @IDWorker
	END
END
GO

CREATE PROC spValidateWorker
	@Email NVARCHAR(50),
	@PSWRD NVARCHAR(50)
AS
BEGIN
	SELECT IDWorker, FirstName, LastName, Email, PSWRD, TypeOfEmployee, IsActive, IsTeamLeader, IsCEO FROM Worker WHERE Email = @Email AND PSWRD = @PSWRD
END	
GO

CREATE PROC spCheckIfProjectLeaderExists
	@FirstName NVARCHAR(50),
	@LastName NVARCHAR(50),
	@IDWorker INT OUTPUT
AS
BEGIN
	IF (SELECT IDWorker FROM Worker WHERE FirstName = @FirstName AND LastName = @LastName) IS NOT NULL
	BEGIN
		SELECT @IDWorker = IDWorker FROM Worker WHERE FirstName = @FirstName AND LastName = @LastName
	END
	ELSE
		SET @IDWorker = -1
END
GO

/* PROJECT_TEAM OPERATIONS */
CREATE PROC spLinkProjectAndTeam
	@IDProject INT,
	@IDTeam INT
AS
BEGIN
	INSERT INTO Project_Team VALUES (@IDProject, @IDTeam)
	EXEC spAddActivity @IDProject, @IDTeam
END
GO

CREATE PROC spSelectTeamsInProject
	@IDProject INT
AS
BEGIN
	SELECT t.IDTeam, t.Title FROM Project_Team AS pt
	INNER JOIN Team AS t ON pt.TeamID = t.IDTeam
	WHERE ProjectID = @IDProject
END
GO

CREATE PROC spSelectProjectsOfTeam
	@IDTeam INT
AS
BEGIN
	SELECT p.Title FROM Project_Team AS pt
	INNER JOIN Project AS p ON pt.ProjectID = p.IDProject
	WHERE TeamID = @IDTeam
END
GO

CREATE PROC spUnlinkProjectAndTeam
	@IDProject INT,
	@IDTeam INT
AS
BEGIN
	DELETE FROM Project_Team WHERE ProjectID = @IDProject AND TeamID = @IDTeam
	EXEC spDeleteActivity @IDProject
END
GO

/* TEAM OPERATIONS */
CREATE PROC spCreateTeam
	@IDTeam INT OUTPUT,
	@Title NVARCHAR(50),
	@DateOfCreation NVARCHAR(50),
	@IsActive BIT
AS
BEGIN 
	INSERT INTO Team (Title, DateOfCreation, IsActive) VALUES (@Title, @DateOfCreation, @IsActive)
	SET @IDTeam = SCOPE_IDENTITY()
END
GO

CREATE PROC spSelectTeam
	@IDTeam INT
AS
BEGIN
	SELECT t.IDTeam, t.Title, t.DateOfCreation, t.TeamLeaderID, t.IsActive, w.FirstName + ' ' + w.LastName AS TeamLeader FROM Team AS t
	INNER JOIN TeamLeader AS tl ON t.TeamLeaderID = tl.WorkerID
	INNER JOIN Worker AS w ON w.IDWorker = tl.WorkerID
	WHERE IDTeam = @IDTeam
END
GO

CREATE PROC spSelectTeams
AS
BEGIN
	SELECT t.*, w.FirstName + ' ' + w.LastName AS TeamLeader FROM Team AS t
	INNER JOIN TeamLeader AS tl ON t.TeamLeaderID = tl.WorkerID
	INNER JOIN Worker AS w ON w.IDWorker = tl.WorkerID
END
GO

CREATE PROC spSelectActiveTeams
AS
BEGIN
	SELECT IDTeam, Title FROM Team WHERE IsActive = 1
END
GO

CREATE PROC spSelectTeamWorkers
	@TeamID INT
AS
BEGIN
	SELECT w.IDWorker, w.FirstName +  ' ' + w.LastName AS FullName, SUM(aw.PersonalDurationInMinutes) AS PersonalDurationInMinutes FROM Worker AS w 
	INNER JOIN Team AS t ON w.TeamID = t.IDTeam
	INNER JOIN Activity_Worker AS aw ON aw.WorkerID = w.IDWorker
	WHERE t.IDTeam = @TeamID
	GROUP BY w.IDWorker, w.FirstName, w.LastName
END
GO

CREATE PROC spSelectTeamTitlesForCEO
AS
BEGIN
	SELECT IDTeam, Title FROM Team
	WHERE IsActive = 1
END
GO

CREATE PROC spSelectTeamTitles
	@TeamLeaderID INT
AS
BEGIN
	SELECT IDTeam, Title FROM Team
	WHERE TeamLeaderID = @TeamLeaderID AND IsActive = 1
END
GO

CREATE PROC spGetActiveTeamLeaders
AS
BEGIN
	SELECT TeamLeaderID FROM Team
END
GO 

CREATE PROC spUpdateTeam
	@IDTeam INT,
	@Title NVARCHAR(50),
	@DateOfCreation NVARCHAR(50),
	@TeamLeaderID INT,
	@IsActive BIT
AS
BEGIN 
	UPDATE Team SET Title = @Title, DateOfCreation = @DateOfCreation, TeamLeaderID = @TeamLeaderID, IsActive = @IsActive WHERE IDTeam = @IDTeam
END
GO

CREATE PROC spUpdateTeamStatus
	@IDTeam INT,
	@IsActive BIT
AS
BEGIN
	UPDATE Team SET IsActive = @IsActive WHERE IDTeam = @IDTeam
END
GO

CREATE PROC spDeleteTeam
	@IDTeam INT
AS
BEGIN
	UPDATE Team SET IsActive = 0 WHERE IDTeam = @IDTeam
END
GO

CREATE PROC spCheckIfTeamExists
	@Title NVARCHAR(50),
	@IDTeam INT OUTPUT	
AS
BEGIN
	IF (SELECT IDTeam FROM Team WHERE Title = @Title) IS NOT NULL
	BEGIN
		SELECT @IDTeam = IDTeam FROM Team WHERE Title = @Title
	END
	ELSE
		SET @IDTeam = -1
END
GO

CREATE PROC spSelectTeamMembers
	@IDTeam INT
AS
BEGIN
	SELECT w.FirstName, w.LastName FROM Worker AS w 
	INNER JOIN Team AS t ON w.TeamID = t.IDTeam
	WHERE t.IDTeam = @IDTeam
END	
GO

CREATE PROC spSetTeamLeaderID
	@IDTeam INT,
	@TeamLeaderID INT
AS
BEGIN
	UPDATE Team SET TeamLeaderID = @TeamLeaderID WHERE IDTeam = @IDTeam
END
GO

/* CLIENT OPERATIONS */
CREATE PROC spCreateClient
	@Title NVARCHAR(50),
	@IsActive BIT
AS
BEGIN
	INSERT INTO Client VALUES (@Title, @IsActive)
END
GO

CREATE PROC spSelectClient
	@IDClient INT
AS
BEGIN
	SELECT IDClient, Title FROM Client WHERE IDClient = @IDClient
END
GO

CREATE PROC spSelectClients
AS
BEGIN
	SELECT * FROM Client 
END
GO

CREATE PROC spSelectActiveClients
AS
BEGIN
	SELECT * FROM Client WHERE IsActive = 1
END
GO

CREATE PROC spUpdateClient
	@IDClient INT,
	@Title NVARCHAR(50),
	@IsActive BIT
AS
BEGIN
	UPDATE Client SET Title = @Title, IsActive = @IsActive WHERE IDClient = @IDClient
END
GO

CREATE PROC spDeleteClient
	@IDClient INT
AS
BEGIN
	UPDATE Client SET IsActive = 0 WHERE IDClient = @IDClient
END
GO

CREATE PROC spCheckIfClientExists
	@Title NVARCHAR(50),
	@IDClient INT OUTPUT
AS
BEGIN
	IF (SELECT IDClient FROM Client WHERE Title = @Title) IS NOT NULL
	BEGIN
		SELECT @IDClient = IDClient FROM Client WHERE Title = @Title
	END
	ELSE
		SET @IDClient = -1
END
GO

EXEC spCreateWorker 'Mislav','Balkovic', 'mislav.balkovic@algebra.hr', '02.08.1998', 'algebra', 'stalni', NULL, 1,0,1
GO