--TRIGGER TO ENFORCE INTEGRITY CONSTRAINT 

CREATE TRIGGER BusinessVerificationCheck
ON BusinessVerification_T
FOR INSERT,UPDATE
AS 
DECLARE @BVerifyID int,@BVerifyDate datetime, @BVerifyDoc varchar(150) ,
@BVerifyExpiry datetime,@BVerifyStatus varchar(25)
SELECT @BVerifyID=inserted.BusinessVerificationID,
@BVerifyDate=inserted.BusinessVerifiedDate,@BVerifyDoc=inserted.BusinessVerificationDoc,
@BVerifyExpiry=inserted.BusinessVerificationExpiryDate,
@BVerifyStatus=inserted.BusinessVerificationStatus
FROM inserted
IF ((@BVerifyStatus IN('Not Verified','Pending Verification')))
BEGIN
UPDATE BusinessVerification_T
SET @BVerifyDate=Null,@BVerifyExpiry=Null
END

drop trigger BusinessVerificationCheck

INSERT INTO BusinessVerification_T
(BusinessVerificationID,BusinessVerificationStatus,OUserID,RestAreaID)
VALUES
(2521,'Pending Verification',123,1013)
