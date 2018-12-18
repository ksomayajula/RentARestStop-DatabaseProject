
--Materiallized View for Reporting

CREATE TABLE VerifiedOwnerRating_View
(OUserID int not null,
UserName nvarchar(100)not null,
BusinessVerificationID int not null,
BusinessVerificationStatus nvarchar(25),
ReviewID int not null,
ReviewRating decimal(2,1),
RestAreaID int not null)

CREATE PROCEDURE RefreshVerifiedOwnerRating_View as
delete from VerifiedOwnerRating_View
insert into VerifiedOwnerRating_View
SELECT UserOwner_T.OUserID,User_T.UserName,BusinessVerification_T.BusinessVerificationID,
BusinessVerification_T.BusinessVerificationStatus,Review_T.ReviewID,Review_T.ReviewRating,
RestArea_T.RestAreaID
FROM
User_T,UserOwner_T,BusinessVerification_T,Review_T,RestArea_T
WHERE
UserOwner_T.OUserID=User_T.UserID
AND BusinessVerification_T.OUserID=UserOwner_T.OUserID
and RestArea_T.OUserID=UserOwner_T.OUserID
AND Review_T.RestAreaID=RestArea_T.RestAreaID

execute RefreshVerifiedOwnerRating_View

