INSERT INTO `employee` (`EmpID`, `FName`, `LName`, `RestOfName`, `Bdate`, 
`MobilePhone`, `SecondMobilePhone`, `WhatsAppNumber`,
`Country`, `City`, `EmpAddress`,
`Sex`, `DateJoining`, `Degree`, 
`EmailForContact`, `EmpEmail`, `EmpPassword`,
`JopTitle`, 
`NotesForHR`, `NotesForDept`, `NotesForTeamMgr`, `EmpStatus`, `Employer`) 
VALUES ('7e4d09f4b5da4c34be7c1dae9fc4a8df', 'Admin', 'PM', '', '2001-5-1', 
'+201116442100', NULL, '+201116442100', 
'Egypt', 'Cairo', 'Down town',
'0', current_timestamp(), 'Bachelor in CIE', 
'ahmedadel23644@gmail.com', 'ahmedadel23644@gmail.com', '23682168',
'WebsiteCreator',
NULL, NULL, NULL, '', '');

-- some users
INSERT INTO User (UserID, FirstName, LastName, SignUpMethod, UserType, SignUpDateTime, MobileAuthenticationEnabled,EmailAuthenticationEnabled)
    VALUES ('66617b2753bd4ecc886d19b35b5afcc4','Joel' , 'Mullen', 0, 0, '2023-02-02 14:47:55', 1, 1);
INSERT INTO UserSignUpEmailPass (UserID, UserEmail, UserPassword, ProfilePicLink) 
    VALUES ('66617b2753bd4ecc886d19b35b5afcc4', 'Joel_Mullen@gmail.com', '12345678', NULL);      
INSERT INTO User (UserID, FirstName, LastName, SignUpMethod, UserType, SignUpDateTime, MobileAuthenticationEnabled,EmailAuthenticationEnabled)
    VALUES ('9a4bc8ab15c3459eafa4d9b4d96a65c8','Dillan' , 'Stevens', 0, 0, '2023-02-02 14:47:55', 1, 1);
INSERT INTO UserSignUpEmailPass (UserID, UserEmail, UserPassword, ProfilePicLink)  
    VALUES ('9a4bc8ab15c3459eafa4d9b4d96a65c8', 'Dillan_Stevens@gmail.com', '12345678', NULL);  

INSERT INTO `permissions` (`EmpID`, `PermissionKey`) VALUES ('7e4d09f4b5da4c34be7c1dae9fc4a8df', '1');

--- Create dept for editing website categories

--- Create dept for HR

--- Create dept for Front page

