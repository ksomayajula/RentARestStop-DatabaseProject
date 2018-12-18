

-- Trigger to Log Update of RestStopUsageFee in the RestArea_T Table

CREATE TABLE UsageFeeUpdate_Log
(RestAreaID int not null,
RestAreaAddress nvarchar(max),
OUserID int,
RestStopUsageFeeOld float,
RestStopUsageFeeNew float,
UpdatedDate datetime)
GO

CREATE TRIGGER UsageFeeUpdate 
ON RestArea_T
AFTER INSERT,UPDATE,DELETE
AS
BEGIN 
if update(RestStopUsageFee)
insert into UsageFeeUpdate_Log (RestAreaID,RestAreaAddress,OUserID,
RestStopUsageFeeOld,RestStopUsageFeeNew,UpdatedDate)
select inserted.RestAreaID,inserted.RestAreaAddress,inserted.OUserID,
deleted.RestStopUsageFee,inserted.RestStopUsageFee,GETDATE()
from inserted,deleted where inserted.RestAreaID=deleted.RestAreaID
END

UPDATE RestArea_T set RestStopUsageFee = 5.50 where RestAreaID=1001
select * from UsageFeeUpdate_Log
select * from RestArea_T


