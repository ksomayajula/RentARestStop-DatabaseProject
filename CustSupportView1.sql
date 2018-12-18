
--Materialized View for a User in the CustomerSupportDepartment

CREATE TABLE Complaints_View
(UserID int not null,
UserName nvarchar(100) not null,
UserType nvarchar(1) not null,
GrievanceID int not null,
GrievanceRegisteredDate datetime not null,
GrievanceDescription nvarchar(max),
GrievanceStatus nvarchar(25))
GO

CREATE PROCEDURE RefreshComplaints_View
AS
DELETE FROM Complaints_View
INSERT INTO Complaints_View
SELECT User_T.UserID,User_T.UserName,User_T.UserType,
Grievance_T.GrievanceID,Grievance_T.GrievanceRegisteredDate,
Grievance_T.GrievanceDescription,Grievance_T.GrievanceStatus
FROM 
User_T,Grievance_T
WHERE
Grievance_T.UserID=User_T.UserID
and (Grievance_T.GrievanceStatus='In Progress' or Grievance_T.GrievanceStatus='New')
and (DATEDIFF(day,Grievance_T.GrievanceRegisteredDate,getdate())>=15)


execute RefreshComplaints_View

select * from Complaints_View

drop procedure RefreshComplaints_View


