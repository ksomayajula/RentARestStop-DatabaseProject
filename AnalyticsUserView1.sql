
CREATE TABLE CustomerUsagePattern_View
(CUserID int not null,
UserName nvarchar(100) not null,
ReservationID int not null,
RestAreaID int not null,
RestStopUsageFee decimal(5,2))
GO

CREATE PROCEDURE RefreshCustomerUsagePattern_View
AS
delete from CustomerUsagePattern_View
insert into CustomerUsagePattern_View
SELECT UserCustomer_T.CUserID,User_T.UserName,Reservation_T.ReservationID,
RestArea_T.RestAreaID,RestArea_T.RestStopUsageFee
FROM 
UserCustomer_T,User_T,Reservation_T,RestArea_T
WHERE
UserCustomer_T.CUserID=User_T.UserID
and Reservation_T.CUserID=UserCustomer_T.CUserID
and Reservation_T.RestAreaID=RestArea_T.RestAreaID
and (RestArea_T.RestStopUsageFee<=5.00)

execute RefreshCustomerUsagePattern_View

select * from CustomerUsagePattern_View
