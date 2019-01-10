-- Drop tables if already exist

-- Drop vacation_patrol table if already exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'vacation_patrol')
BEGIN
	 DROP TABLE vacation_patrol
END

-- Drop vacation_request table if already exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'vacation_request')
BEGIN
	 DROP TABLE vacation_request
END

-- Drop text_message table if already exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'text_message')
BEGIN
	 DROP TABLE text_message
END

-- Drop officer_report table if already exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'officer_report')
BEGIN
	 DROP TABLE officer_report
END

-- Drop member table if already exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'member')
BEGIN
	 DROP TABLE member
END


-- Drop neighborhood table if already exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'neighborhood')
BEGIN
	 DROP TABLE neighborhood
END

-- Drop officer table if already exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'officer')
BEGIN
	 DROP TABLE officer
END


-- Create officer table
CREATE TABLE officer (
	-- Columns for the officer table
	officerID int identity,
	officer_last_name varchar(30) not null,
	officer_first_name varchar(30) not null,
	officer_password varchar(20) not null,
	officer_status bit not null,	
	-- Constraints to the officer table
	CONSTRAINT PK_officerID PRIMARY KEY (officerID),
	)
-- End creating the officer table

-- Create neighborhood table
CREATE TABLE neighborhood (
	-- Columns for the neighborhood table
	nhoodID int identity,
	nhood_name varchar(30) not null,
	-- Constraints to the neighborhood table
	CONSTRAINT PK_nhoodID PRIMARY KEY (nhoodID),
	CONSTRAINT U1_nhood_name Unique (nhood_name)
	)
-- End creating the neighborhood table

-- Create officer_report table
CREATE TABLE officer_report (
	-- Columns for the officer_report table
	officer_reportID int identity,
	report_date datetime not null,
	report_notes varchar(500) not null,
	officerID int not null,
	-- Constraints to the officer_report table
	CONSTRAINT PK_officer_reportID PRIMARY KEY (officer_reportID),
	CONSTRAINT FK3_officerID FOREIGN KEY (officerID) REFERENCES officer(officerID),	
	)
-- End creating the officer_report table

-- Create member table
CREATE TABLE member (
	-- Columns for the member table
	memberID int identity,
	member_username varchar(30) not null,
	member_password varchar(30) not null,
	nhoodID int not null,
	primary_first_name varchar(30) not null,
	primary_last_name varchar(30) not null,
	second_first_name varchar(30),
	second_last_name varchar(30),
	street_number varchar(10) not null,
	street varchar(30) not null,
	city varchar(30) not null,
	us_state varchar(20) not null,
	zipcode varchar(10) not null,
	cell_one varchar(20) not null,
	cell_two varchar(20),
	home_phone varchar(20),
	email_one varchar(30) not null,
	email_two varchar(30),
	property_notes varchar(500),
	emergency_notes varchar(500),
	member_status bit not null,
	-- Constraints to the member table
	CONSTRAINT PK_memberID PRIMARY KEY (memberID),
	CONSTRAINT FK3_nhoodID FOREIGN KEY (nhoodID) REFERENCES neighborhood(nhoodID),	
	CONSTRAINT U1_member_Username UNIQUE (member_Username)
	)
-- End creating the member table

-- Create vacation_request table
CREATE TABLE vacation_request (
	-- Columns for the vacation_request table
	vacation_requestID int identity,
	vr_start_date datetime not null,
	vr_end_date datetime not null,
	instructions varchar(500),
	email_tag bit not null,
	text_tag bit not null,
	memberID int not null,
	-- Constraints to the vacation_requests table
	CONSTRAINT PK_vacation_requestID PRIMARY KEY (vacation_requestID),
	CONSTRAINT FK4_memberID FOREIGN KEY (memberID) REFERENCES member(memberID),	
	)
-- End creating the vacation_request table

-- create vacation_patrol table

-- Create vacation_patrol table
CREATE TABLE vacation_patrol (
	-- Columns for the vacation_patrol table
	vacation_patrolID int identity,
	vp_datetime datetime not null,
	vp_status varchar(50) not null,
	notes varchar(500),
	photo_url varchar(100),
	latitude decimal(10,2),
	longitude decimal(10,2),
	officerID int not null,
	vacation_requestID int not null,
	-- Constraints to the vacation_patrol table
	CONSTRAINT PK_vacation_patrolID PRIMARY KEY (vacation_patrolID),
	CONSTRAINT FK5_officerID FOREIGN KEY (officerID) REFERENCES officer(officerID),	
	CONSTRAINT FK6_vacation_requestID FOREIGN KEY (vacation_requestID) REFERENCES vacation_request(vacation_requestID),	
	)
-- End creating the vacation_patrol table

-- create text_mesaage table

-- Create text_message table
CREATE TABLE text_message (
	-- Columns for the text_message table
	text_messageID int identity,
	text_date_time datetime not null,
	text_message varchar(500) not null,
	text_message_tag bit not null,
	officerID int not null,
	memberID int not null,
	-- Constraints to the text_message table
	CONSTRAINT PK_text_messagelID PRIMARY KEY (text_messageID),
	CONSTRAINT FK7_officerID FOREIGN KEY (officerID) REFERENCES officer(officerID),	
	CONSTRAINT FK6_memberID FOREIGN KEY (memberID) REFERENCES member(memberID),	
	)
GO
-- End creating the text_message table
-- End of table creation

-- Data creation
-- Drop procedure if exists

IF OBJECT_ID('dbo.addNeighborhood', 'P') IS NOT NULL
DROP PROCEDURE dbo.addNeighborhood
GO

IF OBJECT_ID('dbo.addMember', 'P') IS NOT NULL
DROP PROCEDURE dbo.addMember
GO

IF OBJECT_ID('dbo.addOfficer', 'P') IS NOT NULL
DROP PROCEDURE dbo.addOfficer
GO

-- Procedure to Insert Neighborhood Data
CREATE PROCEDURE addNeighborhood(@nhoodname varchar(50)) 
AS
BEGIN
	INSERT INTO neighborhood(nhood_name)
	VALUES (@nhoodname)
	return @@identity
END
GO

-- Procedure to Insert Member Data
CREATE PROCEDURE dbo.addMember(@m_username varchar(30), 
						   @m_password varchar(20),
						   @m_pfn varchar(30),
						   @m_pln varchar(30),
						   @m_sfn varchar(30),
						   @m_sln varchar(30),
						   @m_street_num varchar(10),
						   @m_street varchar(30),
						   @m_city varchar(30),
						   @m_state varchar(20),
						   @m_zipcode varchar(10),
						   @m_cell_one varchar(20),
						   @m_cell_two varchar(20),
						   @m_home_phone varchar(20),
						   @m_email_one varchar(30),
						   @m_email_two varchar(30),
						   @m_property varchar(500),
						   @m_emergency varchar(500),
						   @m_status bit,
						   @nhoodID int) 
AS
BEGIN
	INSERT INTO member(
			member_username,
			member_password,
			nhoodID,
			primary_first_name,
			primary_last_name,
			second_first_name,
			second_last_name,
			street_number,
			street,
			city,
			us_state,
			zipcode,
			cell_one,
			cell_two,
			home_phone,
			email_one,
			email_two,
			property_notes,
			emergency_notes,
			member_status)
	VALUES (@m_username,   
			@m_password,
			@nhoodID,
			@m_pfn,
			@m_pln,
			@m_sfn,
			@m_sln,
			@m_street_num,
			@m_street,
		    @m_city,
			@m_state,
			@m_zipcode,
			@m_cell_one,
			@m_cell_two,
			@m_home_phone,
			@m_email_one,
			@m_email_two,
			@m_property,
			@m_emergency,
			@m_status
		   )
	return @@identity
END
GO
-- Procedure to Insert Officer data
CREATE PROCEDURE dbo.addOfficer(@first_name varchar(30), @last_name varchar(30), @of_password varchar(30), @of_status bit) 
AS
BEGIN
	INSERT INTO officer(officer_last_name, officer_first_name, officer_password, officer_status)
	VALUES (@first_name, @last_name, @of_password, @of_status)
	return @@identity
END
GO


-- Declare variables to hold Neighborhood ID value
DECLARE @m1 AS int
DECLARE @m2 AS int
DECLARE @m3 AS int

-- Execute procedure to add Druid Hills neighborhood and assign neighborhoodID  to @m1
EXEC @m1 = dbo.addNeighborhood 'Druid Hills'
-- Add five members to Druid Hills neighborhood
EXEC dbo.addMember 'funnybunny', 'frek123', 'Olga', 'Perera', NULL, NULL, '34', 'Oakdale RD', 'Atlanta',
				'GA', '30303', '404-111-2367', NULL, NULL, 'olga@mail.com', NULL, 'Two large dogs on property', 'mom: 650-222-6789', '1', @m1
EXEC dbo.addMember 'sillythings', 'dt3771', 'Jane', 'Smith', 'Paul', 'Smith', '322', 'Briardale RD', 'Atlanta',
				'GA', '30303', '404-121-2567', NULL, NULL, 'janesmith@mail.com', 'paulsmith@mail.com', 'Renters on property', 'no contact', '1', @m1
EXEC dbo.addMember 'happyholiday', 'fresdasd', 'Patti', 'Holly', NULL, NULL, '134', 'Oakdale RD', 'Atlanta',
				'GA', '30303', '770-541-2555', NULL, NULL, 'pattih@mail.com', NULL, 'Cats on property', 'dad: 543-222-2311', '0', @m1
EXEC dbo.addMember 'wenthome', 'fas999', 'Alex', 'Bikler', NULL, NULL, '811', 'Springdale RD', 'Atlanta',
				'GA', '30303', '404-491-5689', NULL, NULL, 'alexb@mail.com', NULL, 'no comment', 'no', '1', @m1
EXEC dbo.addMember 'wannaice', 'shgduuy3', 'John', 'Singh', NULL, NULL, '32', 'Oakdale RD', 'Atlanta',
				'GA', '30303', '404-299-2678', NULL, NULL, 'johns@mail.com', NULL, 'Dog on property', 'no comments', '0', @m1
												  
						   
-- Execute procedure to add Briar Woods neighborhood and assign neighborhoodID  to @m2
EXEC @m2 = dbo.addNeighborhood 'Briar Woods'
-- Add five members to Briar Woods neighborhood
EXEC dbo.addMember 'nickelpip', 'hdghaue3', 'Andrea', 'Carter', NULL, NULL, '105', 'Cornell RD', 'Atlanta',
				'GA', '30303', '404-111-2367', NULL, NULL, 'andrea@mail.com', NULL, NULL, 'other contact: 344-255-6709', '1', @m2
EXEC dbo.addMember 'friendsofus', '3438748b', 'Pavel', 'Smirnov', 'Lana', 'Smernov', '677', 'Harvard RD', 'Atlanta',
				'GA', '30303', '404-670-2660', NULL, NULL, 'pavels@mail.com', 'lanas@mail.com', 'Renters on property', NULL, '1', @m2
EXEC dbo.addMember 'fabu45', 'fdhgr44', 'Jennifer', 'Foodman', 'Ricky', 'Nofood', '33', 'Harvard RD', 'Atlanta',
				'GA', '30303', '678-455-5725', '404-971-6677', NULL, 'jen@mail.com', NULL, 'Gates', 'dad: 678-908-4312', '1', @m2
EXEC dbo.addMember 'grownman', 'fazzy77', 'Alex', 'Blair', NULL, NULL, '91', 'Cornell RD', 'Atlanta',
				'GA', '30303', '404-461-5601', NULL, NULL, 'alexb@mail.com', NULL, 'no comment', 'no', '1', @m2
EXEC dbo.addMember 'princeand', 'dude45', 'John', 'Singh', NULL, NULL, '32', 'Oakdale RD', 'Atlanta',
				'GA', '30303', '770-299-2678', NULL, NULL, 'johns@mail.com', NULL, 'Dog on property', 'no comments', '0', @m2

-- Execute procedure to add Briar Woods neighborhood and assign neighborhoodID  to @m3
EXEC @m3 = dbo.addNeighborhood 'Emory'
-- Add five members to Briar Woods neighborhood
EXEC dbo.addMember 'frownfm', 'league3', 'Karen', 'Fletcher', NULL, NULL, '222', 'Moreland AVE', 'Atlanta',
				'GA', '30307', '404-267-2367', NULL, NULL, 'karenf@mail.com', NULL, NULL, 'other contact: 255-266-6709', '1', @m3
EXEC dbo.addMember 'octopus', '3438748b', 'Harvey', 'Smirnov', 'Lana', 'Smernov', '677', 'Sesame ST', 'Atlanta',
				'GA', '30303', '404-670-2660', NULL, NULL, 'pavels@mail.com', 'lanas@mail.com', 'Renters on property', NULL, '1', @m3
EXEC dbo.addMember 'fabulili', 'fdhgr44', 'Lana', 'Poole', 'Ricky', 'Poole', '136', 'Moreland AVE', 'Atlanta',
				'GA', '30303', '678-455-5725', '404-971-6677', NULL, 'jen@mail.com', NULL, 'Gates', 'dad: 678-908-4312', '1', @m3
EXEC dbo.addMember 'santa', 'fazzy7777', 'Alexander', 'Miller', NULL, NULL, '91', 'Smith RD', 'Atlanta',
				'GA', '30303', '404-461-5601', NULL, NULL, 'alexb@mail.com', NULL, 'no comment', 'no', '1', @m3
EXEC dbo.addMember 'thor', 'dude45', 'John', 'Sloth', NULL, NULL, '332', 'Yale RD', 'Atlanta',
				'GA', '30303', '770-779-2098', NULL, NULL, 'johnsl@mail.com', NULL, 'Dog on property', 'no comments', '0', @m3

-- Excute procedure to add officers
EXEC dbo.addOfficer 'Ferguson', 'David', 'happy6788', '1'
EXEC dbo.addOfficer 'Singh', 'Tony', 'cars743', '1'
EXEC dbo.addOfficer 'Baxter', 'Jeff', 'hhjja44', '1'
EXEC dbo.addOfficer 'John', 'Smith', 'shja44', '1'
GO

--Insert Vacation Request records
INSERT INTO vacation_request(vr_start_date, vr_end_date, instructions, email_tag, text_tag, memberID)
	VALUES ('2018-12-01','2018-12-08','pet sitter will be on property occasionally',1,1,1)
 
INSERT INTO vacation_request(vr_start_date, vr_end_date, instructions, email_tag, text_tag, memberID)
	VALUES ('2018-12-10','2018-12-31','no one should be on property',1,0,3)

INSERT INTO vacation_request(vr_start_date, vr_end_date, instructions, email_tag, text_tag, memberID)
	VALUES ('2018-12-10','2018-12-15','out of contry',1,0,7)
-- Select vacation request records
SELECT * FROM vacation_request

-- Insert Vacation Patrol records
INSERT INTO vacation_patrol(vp_datetime, vp_status, notes, photo_url, latitude, longitude, vacation_requestID, officerID)
	VALUES ('2018-12-15','OK','Property was secured by Officer Baxter',NULL,87.345,31.432,1,3)
 
INSERT INTO vacation_patrol(vp_datetime, vp_status, notes, photo_url, latitude, longitude, vacation_requestID, officerID)
	VALUES ('2018-12-15','OK','Mail was moved to back porch. Officer Baxter',NULL,87.565,32.412,2,3)

INSERT INTO vacation_patrol(vp_datetime, vp_status, notes, photo_url, latitude, longitude, vacation_requestID, officerID)
	VALUES ('2018-12-15','OK','Property was secured by Officer Baxter',NULL,87.555,33.432,3,3)
 
INSERT INTO vacation_patrol(vp_datetime, vp_status, notes, photo_url, latitude, longitude, vacation_requestID, officerID)
	VALUES ('2018-12-16','Attention needed','Front gate opened. Contacted homeowner. Officer Singh',NULL,87.35,32.412,1,2)

INSERT INTO vacation_patrol(vp_datetime, vp_status, notes, photo_url, latitude, longitude, vacation_requestID, officerID)
	VALUES ('2018-12-16','OK','Property was secured by Officer Singh',NULL,87.565,33.412,2,2)
 
INSERT INTO vacation_patrol(vp_datetime, vp_status, notes, photo_url, latitude, longitude, vacation_requestID, officerID)
	VALUES ('2018-12-16','OK','Property checked by Officer Singh',NULL,87.555,33.412,3,2)
-- Select vacation request records
SELECT * FROM vacation_patrol

--Insert Officer Report records
INSERT INTO officer_report(report_date, report_notes, officerID)
	VALUES ('2018-12-15','December 15th report by Officer Baxter: I patrolled three vacation properties, responded to several membership concerns.',3)
INSERT INTO officer_report(report_date, report_notes, officerID)
	VALUES ('2018-12-16','December 16th report by Officer Singh: I spoke to a member regarding an incident. Nothing else to report.',2)
 
-- Select Officer report records
SELECT * FROM officer_report

--Insert Text Message records
INSERT INTO text_message(text_date_time, text_message, text_message_tag, officerID, memberID)
	VALUES ('2018-12-16','Theft on our property',0,2,5)
INSERT INTO text_message(text_date_time, text_message, text_message_tag, officerID, memberID)
	VALUES ('2018-12-16','Will investigate asap',1,2,5)

-- Select Text Message records
SELECT * FROM text_message
GO

-- Updating vacation request records: set start date to today for vacation request #1
DECLARE @newstartdate datetime
SET @newstartdate = getdate()
UPDATE vacation_request SET vr_start_date = @newstartdate WHERE vacation_requestID=1

-- Procedure to Update vacation request start date
IF OBJECT_ID('dbo.setVRStartDate', 'P') IS NOT NULL
DROP PROCEDURE dbo.setVRStartDate
GO

CREATE PROCEDURE dbo.setVRStartDate (@startDate datetime, @vacation_requestID int)
AS BEGIN
	UPDATE vacation_request
    SET vr_start_date = @startDate WHERE vacation_requestID = @vacation_requestID
	END
GO

EXEC dbo.setVRStartDate '12-02-2018', 1
SELECT * FROM vacation_request

-- Creating Views
-- VIEW to generate current (today's) vacation requests list for individual officer shift.
IF OBJECT_ID('dbo.patrol_VacationList', 'V') IS NOT NULL
DROP VIEW dbo.patrol_VacationList
GO

IF OBJECT_ID('dbo.getTodayDate') IS NOT NULL
DROP FUNCTION dbo.getTodayDate
GO

-- Step 1 -> create function to get current date
CREATE FUNCTION dbo.getTodayDate ()
RETURNS datetime AS
BEGIN
	DECLARE @today AS datetime
    SET @today = getdate()
	RETURN @today
END
GO	
-- create view to today's list of vacation requests
CREATE VIEW dbo.patrol_VacationList AS
	SELECT 
	member.primary_first_name +' '+ member.primary_last_name AS MemberName,
	member.street_number +' '+ member.street AS MemberAddress,
	member.street AS Street,
	vacation_request.instructions AS PatrolInstructions,
	member.cell_one AS PrimaryCell,
	member.email_one AS Email
	FROM vacation_request
	JOIN member ON vacation_request.memberID = member.memberID
	WHERE dbo.getTodayDate() BETWEEN  vr_start_date AND vr_end_date
	
GO
-- Select records from View ordered by Street
SELECT MemberName, MemberAddress, PatrolInstructions, PrimaryCell, Email FROM patrol_VacationList ORDER BY Street
GO
-- View to create a list of vacation patrol for a specific vacation request
IF OBJECT_ID('dbo.member_VacationPatrol', 'V') IS NOT NULL
DROP VIEW dbo.member_VacationPatrol
GO

CREATE VIEW member_VacationPatrol AS
	SELECT
	member.memberID AS MemberID, 
	member.primary_first_name +' '+ member.primary_last_name AS MemberName,
	member.street_number +' '+ member.street AS MemberAddress,
	member.street AS Street,
	vacation_request.vr_start_date AS StartDate,
	vacation_patrol.vp_datetime AS PatrolDate,
	vacation_patrol.vp_status AS PatrolStatus
	FROM member
	JOIN vacation_request ON member.memberID = vacation_request.memberID
	JOIN vacation_patrol ON vacation_patrol.vacation_requestID = vacation_request.vacation_requestID
	GO

SELECT MemberName, MemberAddress, StartDate, PatrolDate, PatrolStatus  FROM member_VacationPatrol
ORDER BY MemberID
GO


