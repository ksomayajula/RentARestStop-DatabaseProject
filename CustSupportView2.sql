
--MATERIALIZED VIEW FOR A CUSTOMER SUPPORT EXECUTIVE ABOUT USER RESERVATION

CREATE TABLE CustomerInformation_View
(CUserID int not null,
UserName nvarchar(100) not null,
CCPaymentID int not null,
PayableAmount money,
CCPaymentStatus varchar(15) not null)
GO

CREATE PROCEDURE RefreshCustomerInformation_View
AS
DELETE FROM CustomerInformation_View
INSERT INTO CustomerInformation_View
SELECT UserCustomer_T.CUserID,User_T.UserName,PaymentCreditCard_T.CCPaymentID,
Invoice_T.InvoiceTotalAmount,PaymentCreditCard_T.PaymentStatus
FROM 
User_T,UserCustomer_T,Invoice_T,PaymentCreditCard_T,Payment_T
WHERE
UserCustomer_T.CUserID=User_T.UserID
and Invoice_T.InvoiceID=Payment_T.InvoiceID
and PaymentCreditCard_T.CCPaymentID=Payment_T.PaymentID
and Payment_T.CUserID=UserCustomer_T.CUserID


execute RefreshCustomerInformation_View

select * from CustomerInformation_View




