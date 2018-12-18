
----------------------------------------------------
--Start of SQL Code
----------------------------------------------------

---------------------------------------------------
--Create Table Statements
----------------------------------------------------

--Creation of User Table
CREATE TABLE User_T
(UserID int not null ,
UserName nvarchar(100) not null,
UserDateOfBirth date not null
CHECK (UserDateOfBirth between '01/01/1900' and '01/01/2000'),
UserEmailAddress nvarchar(50) not null UNIQUE,
UserPhoneNum char(10) not null,
UserAddress nvarchar(150),
UserType nvarchar(1) not null 
CHECK (UserType IN ('C','O')),
CONSTRAINT User_PK PRIMARY KEY(UserID)
)


--Creation of Customer Table

CREATE TABLE UserCustomer_T
(CUserID int not null 
CHECK (CUserID>0),
CustomerDriversLicenceNum nvarchar(10) not null,
CONSTRAINT UserCustomer_PK PRIMARY KEY (CUserID),
CONSTRAINT UserCustomer_FK FOREIGN KEY (CUserID) REFERENCES User_T(UserID)
ON DELETE CASCADE  
)

--Creation of Owner Table

CREATE TABLE UserOwner_T
(OUserID int not null
CHECK(OUserID>0),
OwnerBusinessPermitNum nvarchar(10)
CONSTRAINT UserOwner_PK PRIMARY KEY (OUserID)
CONSTRAINT UserOwner_FK FOREIGN KEY (OUserID) REFERENCES User_T(UserID)
ON DELETE CASCADE  
)

--Creation of Login Table

CREATE TABLE Login_T
(LoginUsername nvarchar(15) not null unique,
LoginPassword nvarchar(15) not null
CHECK(LEN(LoginPassword)>=8),
UserID int not null
CHECK(UserID>0),
CONSTRAINT Login_PK PRIMARY KEY (LoginUsername),
CONSTRAINT User_FK FOREIGN KEY (UserID) REFERENCES User_T(UserID)
 ON DELETE CASCADE  
)

 

 --Creation of RestArea Table

 CREATE TABLE RestArea_T
 (RestAreaID int not null
 CHECK (RestAreaID>0),
 RestAreaAddress nvarchar(150) not null,
 RestAreaPhoto varbinary(max),
 OUserID int not null,
 CONSTRAINT RestArea_PK PRIMARY KEY (RestAreaID),
 CONSTRAINT RestArea_FK FOREIGN KEY (OUserID) references UserOwner_T(OUserID)
 ON DELETE CASCADE  
)
ALTER TABLE RestArea_T
ADD RestStopUsageFee decimal(5,2)


 --Creation of Reservation Table

 CREATE TABLE Reservation_T
 (ReservationID int not null
 CHECK (ReservationID>0),
 ReservationCheckinDateTime datetime not null,
 ReservationCheckoutDateTime datetime not null,
 ReservationGuestNum int 
 CHECK (ReservationGuestNum>=1 and ReservationGuestNum<=4),
 CUserID int not null,
 RestAreaID int not null,
 CONSTRAINT Reservation_PK PRIMARY KEY (ReservationID),
 CONSTRAINT Reservation_FK1 FOREIGN KEY (CUserID) REFERENCES UserCustomer_T(CUserID)
 ON DELETE CASCADE,
 CONSTRAINT Reservation_FK2 FOREIGN KEY (RestAreaID) REFERENCES RestArea_T(RestAreaID)
 ON DELETE NO ACTION  
)


--Creation of Grievance Table

 CREATE TABLE Grievance_T
 (GrievanceID int not null
 CHECK (GrievanceID>0),
 GrievanceRegisteredDate datetime not null,
 GrievanceDescription varchar(max) not null,
 GrievanceResolutionDate datetime DEFAULT null,
 GrievanceStatus nvarchar(25)
 CHECK(GrievanceStatus IN('New','Resolved','In Progress')),
 UserID int not null
  CHECK(UserID>0),
  CONSTRAINT Grievance_PK PRIMARY KEY (GrievanceID),
 CONSTRAINT Grievance_FK FOREIGN KEY (UserID) REFERENCES User_T(UserID)
  ON DELETE CASCADE  
)
 --Creation of Business Verification Table

 CREATE TABLE BusinessVerification_T
 (BusinessVerificationID int not null
 CHECK (BusinessVerificationID>0),
 BusinessVerifiedDate datetime,
 BusinessVerificationDoc varchar(max),
 BusinessVerificationExpiryDate datetime,
 BusinessVerificationStatus nvarchar(25)
 CHECK (BusinessVerificationStatus in ('Verified','Not Verified','Pending Verification')),
  OUserID int not null
 CHECK(OUserID>0),
 RestAreaID int not null
 CHECK(RestAreaID>0),
 CONSTRAINT BusinessVerification_PK PRIMARY KEY (BusinessVerificationID),
 CONSTRAINT BusinessVerification_FK1 FOREIGN KEY (OUserID) REFERENCES UserOwner_T(OUserID)
 ON DELETE CASCADE,
 CONSTRAINT BusinessVerification_FK2 FOREIGN KEY (RestAreaID) REFERENCES RestArea_T(RestAreaID)
 ON DELETE NO ACTION 
)

 --Creation of Review Table

 CREATE TABLE Review_T
 (ReviewID int not null
 CHECK (ReviewID>0),
 ReviewRating decimal(2,1)
 CHECK(ReviewRating>=0.0 and ReviewRating<=5.0),
 ReviewDescription nvarchar(max),
 ReviewDate datetime,
 CUserID int  not null
 CHECK(CUserID>0),
 RestAreaID int not null
 CHECK(RestAreaID>0),
 CONSTRAINT Review_PK PRIMARY KEY (ReviewID),
 CONSTRAINT Review_FK1 FOREIGN KEY (CUserID) REFERENCES UserCustomer_T(CUserID)
 ON DELETE CASCADE,
 CONSTRAINT Review_FK2 FOREIGN KEY (RestAreaID) REFERENCES RestArea_T(RestAreaID)
 ON DELETE NO ACTION
)


 --Creation of Facilities Table

 CREATE TABLE Facilities_T
 (FacilityID int not null
 CHECK (FacilityID>0),
 FacilityName nvarchar(50) not null,
 FacilityDescription nvarchar(max),
 FacilityAvailabilityStatus nvarchar(25) not null
 CHECK( FacilityAvailabilityStatus IN ('Available','Not Available')),
 RestAreaID int not null
 CHECK(RestAreaID>0),
 CONSTRAINT Facility_PK PRIMARY KEY (FacilityID),
 CONSTRAINT Facility_FK FOREIGN KEY (RestAreaID) REFERENCES RestArea_T(RestAreaID)
 ON DELETE CASCADE, 
 )
 
 
 --Creation of Invoice Table

 CREATE TABLE Invoice_T
 (InvoiceID int not null
 CHECK (InvoiceID>0),
 InvoiceGeneratedDate datetime not null,
 InvoiceTotalAmount decimal(4,2) not null
 CHECK( InvoiceTotalAmount<=99.99),
 ReservationID int not null
 CHECK(ReservationID>0),
 CONSTRAINT Invoice_PK PRIMARY KEY (InvoiceID),
 CONSTRAINT Invoice_FK FOREIGN KEY (ReservationID) REFERENCES Reservation_T(ReservationID)
 ON DELETE CASCADE 
 )

 

 --Creation of Payment Table

 CREATE TABLE Payment_T
 (PaymentID int not null
 CHECK (PaymentID>0),
 PaymentBillingAddress nvarchar(150) not null,
 PaymentType nvarchar(2) not null
 CHECK(PaymentType IN ('CC','CH','P')),
 InvoiceID int not null
 CHECK(InvoiceID>0),
 CUserID int not null
 CHECK(CUserID>0),
 CONSTRAINT Payment_PK PRIMARY KEY (PaymentID),
 CONSTRAINT Payment_FK1 FOREIGN KEY (InvoiceID) REFERENCES Invoice_T(InvoiceID)ON DELETE CASCADE,
 CONSTRAINT Payment_FK2 FOREIGN KEY (CUserID) REFERENCES UserCustomer_T(CUserID)ON DELETE NO ACTION 
)

 --Creation of Payment_CreditCard Table

 CREATE TABLE PaymentCreditCard_T
 (CCPaymentID int not null
 CHECK (CCPaymentID>0),
 PaymentCardName nvarchar(50) not null,
 PaymentCardNumber char(16) not null
 CHECK(LEN(PaymentCardNumber)=16),
 PaymentCardExpirationMonth char(2) not null
 CHECK( PaymentCardExpirationMonth>=1 and  PaymentCardExpirationMonth<=12),
 PaymentCardExpirationYear char(4) not null
 CHECK( PaymentCardExpirationYear>=year(GETDATE())),
 PaymentCardType nvarchar(15) not null
 CHECK ( PaymentCardType in ('Visa','MasterCard','Discover','AMEX')),
 PaymentStatus nvarchar(15),
 CHECK(PaymentStatus IN ('Success','Failure')),
 CONSTRAINT PaymentCreditCard_PK PRIMARY KEY (CCPaymentID)
 
 )



 --Creation of Payment_Cash Table

 CREATE TABLE PaymentCash_T
 (CHPaymentID int not null
 CHECK (CHPaymentID>0),
 PaymentCashCurrency nvarchar(3) not null 
 CHECK ( PaymentCashCurrency='USD'),
 PaymentCashAmount decimal(4,2) not null
 CHECK (PaymentCashAmount>=00.00 and PaymentCashAmount<=99.99),
 PaymentBalanceReturned decimal(4,2) not null
 CHECK ( PaymentBalanceReturned>=00.00 and  PaymentBalanceReturned<=99.99),
 CONSTRAINT PaymentCash_PK PRIMARY KEY (CHPaymentID))

 --Creation of Payment_PayPal Table

 CREATE TABLE PaymentPaypal_T
 (PPaymentID int not null
 CHECK (PPaymentID>0),
 PaymentTransactionID nvarchar(12) not null
 CHECK(LEN(PaymentTransactionID)=12),
 CONSTRAINT PaymentPaypal_PK PRIMARY KEY (PPaymentID))

 
 --Creation of Receipt Table

 CREATE TABLE Receipt_T
 (ReceiptID int not null
 CHECK (ReceiptID >0),
 ReceiptRequested nvarchar(3) not null
 CHECK ( ReceiptRequested IN ('Yes','No')),
 ReceiptGeneratedDate datetime,
 ReceiptIssueType nvarchar(10) 
 CHECK ( ReceiptIssueType IN ('Email','Print','Text')),
 PaymentID int not null
 CHECK(PaymentID>0),
 ReservationID int not null
 CHECK(ReservationID>0),
 CONSTRAINT Receipt_PK PRIMARY KEY (ReceiptID),
 CONSTRAINT Receipt_FK1 FOREIGN KEY (PaymentID) REFERENCES Payment_T(PaymentID)
 ON DELETE CASCADE,
 CONSTRAINT Receipt_FK2 FOREIGN KEY (ReservationID) REFERENCES Reservation_T(ReservationID)
 ON DELETE NO ACTION
)










