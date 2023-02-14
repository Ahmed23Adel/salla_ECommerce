DROP DATABASE IF EXISTS Shoopy;
CREATE DATABASE Shoopy;
use Shoopy;

-- User Seller/Normal
CREATE TABLE User(
    UserID varchar(32),
    FirstName varchar(32) NOT NULL,
    LastName varchar(32) NOT NULL,
    SignUpMethod TINYINT(1) NOT NULL, -- 0: Email and password, 1: Facebook, 2: Gmail
    UserType TINYINT(1) NOT NULL, -- 0: Normal 1: Seller, 2: Seller still not accepted yer
    SignUpDateTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    MobileAuthenticationEnabled BOOLEAN NOT NULL,
    EmailAuthenticationEnabled BOOLEAN NOT NULL, -- You should first check for Mobile and then check for email.
    MobilePhone varchar(20),
    CONSTRAINT PK_User PRIMARY KEY (UserID),
    CONSTRAINT CHK_SignUP CHECK (SignUpMethod=0 OR SignUpMethod=1 OR SignUpMethod=2), 
    CONSTRAINT CHK_UserType CHECK (UserType=0 OR UserType=1 OR UserType=2) -- For emailPass, they must use transaction,
    

);

CREATE TABLE SellersDocs(
    UserID varchar(32),
    DocName varchar(32) NOT NULL, 
    DocLink varchar(64) NOT NULL,
    DateAdded DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES User(UserID)

);

CREATE TABLE BuyInformation(
    UserID varchar(32),
    UserCountry varchar(20) NOT NULL,
    UserCity varchar(20) NOT NULL,
    UserZipCode varchar(20),
    UserAddress varchar(64) NOT NULL,
    MobilePhone1 varchar(20) NOT NULL,
    MobilePhone2 varchar(20) NOT NULL,
    ExtraInfo varchar(256),
    ExtraInfoFromEmp varchar(512),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

CREATE TABLE UserSignUpEmailPass(
    UserID varchar(32) NOT NULL,
    UserEmail varchar(32) NOT NULL,
    UserPassword varchar(32) NOT NULL,
    ProfilePicLink varchar(128) DEFAULT NULL,
    BirthDate DATETIME NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    CONSTRAINT PK_USER PRIMARY KEY(UserID)  
);



CREATE TABLE Category(
    CategoryID varchar(32),
    CategoryName varchar(64) NOT NULL,
    CategoryPicLink varchar(128) NOT NULL,
    CateogoryType TINYINT(1) NOT NULL,
    ParentCategoryID varchar(32) REFERENCES Category(CategoryID),
    CONSTRAINT PK_Ctgy PRIMARY KEY (CategoryID),
    CONSTRAINT CHK_Type CHECK (CateogoryType=0 OR CateogoryType=1 OR CateogoryType=2)

);


CREATE TABLE Spec(
    CategoryID varchar(32),
    SpecName varchar(20) NOT NULL,
    SpecType TINYINT(1) NOT NULL,
    CONSTRAINT PK_Spec PRIMARY KEY (CategoryID,SpecName),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    CONSTRAINT CHK_SpcType CHECK (SpecType > 0)
);

CREATE TABLE SpecFinite(
    CategoryID varchar(32),
    SpecName varchar(20) NOT NULL,
    SpecValue varchar(20) NOT NULL,
    FOREIGN KEY (CategoryID, SpecName) REFERENCES Spec(CategoryID, SpecName)
);

CREATE TABLE SpecRange(
    CategoryID varchar(32),
    SpecName varchar(20) NOT NULL,
    Min DECIMAL(2,2) NOT NULL,
    Max DECIMAL(2,2) NOT NULL,
    FOREIGN KEY (CategoryID, SpecName) REFERENCES Spec(CategoryID, SpecName),
    CONSTRAINT CHK_Min CHECK(Min>=0),
    CONSTRAINT CHK_Max CHECK(Max>=0)
);

CREATE TABLE SpecRangeFinit(
    CategoryID varchar(32),
    SpecName varchar(20) NOT NULL,
    Min DECIMAL(2,2) NOT NULL,
    Max DECIMAL(2,2) NOT NULL,
    FOREIGN KEY (CategoryID, SpecName) REFERENCES Spec(CategoryID, SpecName),
    CONSTRAINT CHK_Min CHECK(Min>=0),
    CONSTRAINT CHK_Max CHECK(Max>=0)
);

CREATE TABLE SpecRangeFinitSection(
    CategoryID varchar(32),
    SpecName varchar(20) NOT NULL,
    ValueMin DECIMAL(2,2) NOT NULL,
    ValueMax DECIMAL(2,2) NOT NULL,
    FOREIGN KEY (CategoryID, SpecName) REFERENCES Spec(CategoryID, SpecName),
    CONSTRAINT CHK_Min CHECK(ValueMin>=0),
    CONSTRAINT CHK_Max CHECK(ValueMax>=0)
);



CREATE TABLE Item(
    ItemID varchar(32),
    ItemName varchar(64) NOT NULL, -- Item Main Pic ID is always 0
    ItemMaxBuy SMALLINT,
    CategoryID varchar(32),
    SellerID varchar(32),
    ItemCreationDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    ItemDescription varchar(300),
    ItemOverviewHTMLLink varchar(128),
    ItemShow BOOLEAN,
    ItemQuantatiy SMALLINT,
    CONSTRAINT PK_Item PRIMARY KEY (ItemID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    FOREIGN KEY (SellerID) REFERENCES User(UserID),
    CONSTRAINT CHK_Qty CHECK(ItemQuantatiy>=0),
    CONSTRAINT CHK_MaxBuy CHECK(ItemMaxBuy>=0)
);

CREATE TABLE ItemDelete(
    ItemID varchar(32) NOT NULL,
    DeleteDate DATETIME NOT NULL,
    Deleter varchar(32), -- It could be SellerID/ EmployeeID
    DeleteType BOOLEAN, -- 0: Seller, 1: Employee
    CONSTRAINT PK_Item PRIMARY KEY (ItemID)
);


CREATE TABLE ItemSpec(
    ItemID varchar(32) NOT NULL,
    CategoryID varchar(32) NOT NULL,
    SpecName varchar(20) NOT NULL,
    SpecValue varchar(32),
    CONSTRAINT PK_Item PRIMARY KEY (ItemID,CategoryID,SpecName),
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

CREATE TABLE PriceHistory(
    ItemID varchar(32),
    DateAdded DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Price DECIMAL(5,5),
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    CONSTRAINT CHK_Price CHECK(Price>=0)
);

CREATE TABLE AdditionSpec(
    SpecKey varchar(32) NOT NULL,
    SpecValue varchar(64) NOT NULL,
    ItemID varchar(32) NOT NULL,
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    CONSTRAINT PK_ASpec PRIMARY KEY (ItemID, SpecKey)
);

CREATE TABLE ItemAbout(
    ItemID varchar(32) NOT NULL,
    BulletPoint varchar(128),
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID)
);

CREATE TABLE Picture(
    ItemID varchar(32),
    PicID TINYINT(1),
    PicLink varchar(128) NOT NULL,
    CONSTRAINT PK_Pic PRIMARY KEY (ItemID, PicID),
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    CONSTRAINT CHK_PicID CHECK(PicID>=0)
    
);



-- Owner of Item can only make the discount
CREATE TABLE ItemDiscount(
    DiscountPercentage DOUBLE(3, 2) NOT NULL,
    ItemID varchar(32),
    DateCreation DATETIME NOT NULL,
    DATEEXPIRE DATETIME NOT NULL,
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    CONSTRAINT CHK_Discount CHECK(DiscountPercentage>0)
);

CREATE TABLE Views(
    NrmlUsrID varchar(32),
    ItemID varchar(32),
    AmountTimeScroll TIME NOT NULL,
    AmountTimeFocus TIME,
    DateView DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_View PRIMARY KEY (NrmlUsrID, ItemID, DateView),
    CONSTRAINT CHK_Scrl CHECK(AmountTimeScroll>=0),
    CONSTRAINT CHK_Fcs CHECK(AmountTimeFocus>=0)
);

CREATE TABLE Rate(
    UserID varchar(32),
    ItemID varchar(32),
    RateValue TINYINT(1) NOT NULL,
    Header varchar(64),
    Text varchar(256),
    DateCreation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID)
);

CREATE TABLE Cart(
    UserID varchar(32) NOT NULL,
    ItemID varchar(32) NOT NULL,
    DateAdded DATETIME NOT NULL,
    Quantity TINYINT(1) NOT NULL DEFAULT 1, 
    CONSTRAINT PK_crt PRIMARY KEY (UserID, ItemID),
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID)
);
-- When seller makes coupon, it applies only for his items
CREATE TABLE Coupon(
    CouponID varchar(32),
    SellerID varchar (32),
    CouponTxt varchar(16) UNIQUE,
    DateCreation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DateExpire DATETIME, -- If null--> till infinity
    CouponDiscount DOUBLE(3, 2) NOT NULL,
    CouponMaxDiscount DECIMAL(5, 2),
    IsForAll Binary,
    CONSTRAINT PK_cpn PRIMARY KEY (CouponID),
    FOREIGN KEY (SellerID) REFERENCES User(UserID),
    CONSTRAINT CHK_DteCrtion CHECK(DateExpire > DateCreation),
    -- CONSTRAINT CHK_CpnTxt CHECK(len(CouponTxt)> 5),
    CONSTRAINT CHK_CpnDiscnt CHECK(CouponDiscount > 0),
    CONSTRAINT CHK_MxDiscount CHECK(CouponMaxDiscount > 0)
);


-- if not for all

CREATE TABLE CouponFor(
    CouponID varchar(32),
    ItemID varchar(32),
    CONSTRAINT PK_Cpn PRIMARY KEY (CouponID,ItemID),
    FOREIGN KEY (CouponID) REFERENCES Coupon(CouponID)
);


CREATE TABLE BuyPackage(
    PackageID varchar(32) NOT NULL ,
    NrmlUserID varchar(32),
    DateBuy DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_pck PRIMARY KEY (PackageID),
    FOREIGN key (NrmlUserID) REFERENCES User(UserID)
);


CREATE TABLE PackageItems(
    PackageID varchar(32) NOT NULL,
    ItemID varchar(32) NOT NULL,
    Quantity SMALLINT NOT NULL,
    CouponID varchar(32),

    FOREIGN key (PackageID) REFERENCES BuyPackage(PackageID),
    FOREIGN key (ItemID) REFERENCES Item(ItemID),
    FOREIGN key (CouponID) REFERENCES Coupon(CouponID)
);
-- it might have canceled
CREATE TABLE PackageItemPhase(
    PackageID varchar(32) NOT NULL,
    ItemID varchar(32) NOT NULL,
    LastPhaseReached TINYINT(1), 
    DatePhaseReached DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,


    CONSTRAINT PK_pck PRIMARY KEY (PackageID, ItemID, LastPhaseReached),
    FOREIGN key (PackageID) REFERENCES BuyPackage(PackageID),
    FOREIGN key (ItemID) REFERENCES Item(ItemID)
);

CREATE TABLE  Employee (
        EmpID varchar(32) NOT NULL,
        FName varchar(32) NOT NULL,
        LName varchar(32) NOT NULL, 
        RestOfName varchar(64), 
        Bdate DATE NOT NULL, 
        MobilePhone varchar(15) NOT NULL, 
        SecondMobilePhone varchar(15),
        WhatsAppNumber varchar(15), 
        Country varchar(32) NOT NULL,
        City varchar(32) NOT NULL,
        EmpAddress varchar(32), 
        Sex BOOLEAN NOT NULL, -- 0:Male, 1: Female
        DateJoining DATE NOT NULL DEFAULT CURRENT_TIMESTAMP, 
        Degree varchar(64),
        EmailForContact varchar(20) , 
        EmpEmail varchar(32) NOT NULL,
        EmpPassword varchar(32) NOT NULL,
        JopTitle varchar(64),
        NotesForHR varchar(256),
        NotesForDept varchar(256), 
        NotesForTeamMgr varchar(256),
        EmpStatus TINYINT(1) NOT NULL, -- 0: hired, 1: in process, 2:fired, 3: resigned
        Employer varchar(255) NOT NULL REFERENCES Employee(EmpID),
        CONSTRAINT PK_Emp PRIMARY KEY (EmpID)
);



CREATE TABLE EmployeeDocs(
    EmpID varchar(32),
    DocName varchar(32) NOT NULL, 
    DocLink varchar(64) NOT NULL,
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)

);

CREATE TABLE SalaryHistory(
    EmpID varchar(32),
    Salary DECIMAL(5,5) NOT NULL,
    UpdaterID varchar(32),
    DateUpded DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID),
    FOREIGN KEY (UpdaterID) REFERENCES Employee(EmpID)
);

CREATE TABLE OfficeNumber(
    EmpID varchar(32),
    OfficeName varchar(32),
    BuildingName varchar(32),
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)
);

CREATE TABLE DeductionHistory(
    DeductedAmount DECIMAL(3,3) NOT NULL,
    IsPercentage BOOLEAN,
    Deductor varchar(32),
    DeductedFrom varchar(32),
    FOREIGN KEY (Deductor) REFERENCES Employee(EmpID),
    FOREIGN KEY (DeductedFrom) REFERENCES Employee(EmpID)

);


CREATE TABLE Department(
    DeptID varchar(32),
    DeptName varchar(32) NOT NULL,
    DeptLocation varchar(64),
    DeptMgrID varchar(32),
    CONSTRAINT PK_Front PRIMARY KEY (DeptID),
    FOREIGN KEY (DeptMgrID) REFERENCES Employee(EmpID)
);

CREATE TABLE FrontPage(
    FrontPageVersionID varchar(32), 
    FrontVersion DECIMAL(2, 2),
    CreatorrEmpID varchar(32),
    DateCreated DATETIME NOT NULL DEFAULT  CURRENT_TIMESTAMP,
    CONSTRAINT PK_Front PRIMARY KEY (FrontPageVersionID),
    FOREIGN KEY (CreatorrEmpID) REFERENCES Employee(EmpID)
);

CREATE TABLE FrontPageRows(
    FrontPageVersionID varchar(32), 
    RowNumber TINYINT(1),
    RowValue TINYINT(1), -- TODO Each value should corespont to something
    CONSTRAINT PK_Front PRIMARY KEY (FrontPageVersionID, RowNumber),
    CONSTRAINT CHK_RowNumber CHECK(RowNumber > 0),
    CONSTRAINT CHK_RowValue CHECK(RowValue > 0)
);

CREATE TABLE FrontPageSection(
    FrontPageVersionID varchar(32), 
    RowNumber TINYINT(1),
    ColNum TINYINT(1),
    ColValue TINYINT(1),
    CONSTRAINT PK_Front PRIMARY KEY (FrontPageVersionID, RowNumber),
    CONSTRAINT CHK_ColNum CHECK(ColNum > 0),
    CONSTRAINT CHK_ColValue CHECK(ColValue > 0)
);


CREATE TABLE FrontPageMeta(
    VersionUsedID varchar(32),
    StartUsageDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP

);

CREATE TABLE Thread(
    ThreadID varchar(32),
    NrmlOpenerID varchar(32),
    HeadLine varchar(128) NOT NULL,
    DateCreated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    IsFinished BOOLEAN DEFAULT 0,
    Rate TINYINT(1),
    CONSTRAINT PK_Thread PRIMARY KEY (ThreadID),
    FOREIGN KEY (NrmlOpenerID) REFERENCES User(UserID)
);

CREATE TABLE ThreadMsg(
    ThreadID varchar(32),
    MsgHeadline varchar(128),
    MsgTxt varchar(512),
    DateSent DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UserID varchar(32), -- if null then senderrr is employe
    EmployeID varchar(32), -- if null then senderrr is user
    IsSeen Binary, -- For answered or not, you can deduce it by seeing if the last msg is from employee
    FOREIGN KEY (ThreadID) REFERENCES Thread(ThreadID),
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (EmployeID) REFERENCES Employee(EmpID)
);

CREATE TABLE WebsiteCommision(
    CommPercentage  DECIMAL(2,2) NOT NULL,
    PMAdder varchar(32),
    DateAdded DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PMAdder) REFERENCES Employee(EmpID)
);

CREATE TABLE ShippingPrice(
    City  varchar(20) NOT NULL,
    Price  varchar(20) NOT NULL,
    PMAdder varchar(32),
    DateAdded DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PMAdder) REFERENCES Employee(EmpID),
    CONSTRAINT CHK_Price CHECK(Price > 0)
);


CREATE TABLE Team(
    TeamID varchar(32),
    DeptID varchar(32),
    TeamName varchar(20) NOT NULL,
    TeamLeaderID varchar(32) NOT NULL,
    DateCreate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    NotesForHR varchar(512),
    NotesForDeptMgr varchar(512),
    Vision varchar(256),
    TeamDescription varchar(512),
    CONSTRAINT PK_tm PRIMARY KEY (TeamID),
    FOREIGN KEY (TeamLeaderID) REFERENCES Employee(EmpID),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

CREATE TABLE TeamMembers(
    TeamID varchar(32) NOT NULL,
    EmpID varchar(32) NOT NULL,
    Notes varchar(256), 
    FromDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ToDate DATETIME NOT NULL,
    CONSTRAINT PK_tmMem PRIMARY KEY (TeamID, EmpID),
    FOREIGN KEY (TeamID) REFERENCES Team(TeamID),
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)    
);

--  employee has to finish certain amount of points
-- bonus is not counted on some task
-- additional task points is counted as bonus as well
CREATE TABLE Bonus(
    EmpID varchar(32) NOT NULL,
    Raiser varchar(32) NOT NULL,
    BonusPoints TINYINT(1) NOT NULL,
    DateAdded DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Notes varchar(512),
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID),
    FOREIGN KEY (Raiser) REFERENCES Employee(EmpID)   
);


CREATE TABLE SocialMedia(
    EmpID varchar(32) NOT NULL,
    SocialMediaName varchar(20) NOT NULL,
    SocialMediaLink varchar(256) NOT NULL,
    CONSTRAINT PK_Media PRIMARY KEY (EmpID, SocialMediaName),
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)
);

CREATE TABLE EmployeeStatus(
    EmpID varchar(32) NOT NULL,
    EmpStatus TINYINT(1),
    EmpStatusDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Status PRIMARY KEY (EmpID, EmpStatus),
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)
);

CREATE TABLE Task(
    TaskID varchar(32),
    TaskGiver varchar(32) NOT NULL,
    TaskName varchar(32) NOT NULL,
    TaskDesc varchar(512),
    TaskPoints TINYINT(1) NOT NULL,
    DateCreation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DateFrom DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DateTo DATETIME NOT NULL,
    CONSTRAINT PK_Task PRIMARY KEY (TaskID),
    FOREIGN KEY (TaskGiver) REFERENCES Employee(EmpID)
);

CREATE TABLE TaskWorker(
    TaskID varchar(32)NOT NULL,
    EmpID varchar(32) NOT NULL,
    IsDone Binary NOT NULL DEFAULT 0,
    PointsEarned TINYINT(1),
    FOREIGN KEY (TaskID) REFERENCES Task(TaskID),
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)
);

CREATE TABLE Meeting(
    MeetingID varchar(32),
    CreatorID varchar(32) NOT NULL,
    MeetingLeaderID varchar(32),
    DateCreation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    MeetingDate DATETIME,
    Vision varchar(512),
    MeetingDescription varchar(512),
    OutputNotes varchar(512),
    CONSTRAINT PK_mtng PRIMARY KEY (MeetingID),
    FOREIGN KEY (CreatorID) REFERENCES Employee(EmpID),
    FOREIGN KEY (MeetingLeaderID) REFERENCES Employee(EmpID)
);

CREATE TABLE MeetingAttender(
    MeetingID varchar(32) NOT NULL,
    EmpID varchar(32) NOT NULL,
    CONSTRAINT PK_mtng PRIMARY KEY (EmpID, MeetingID),
    FOREIGN KEY (MeetingID) REFERENCES Meeting(MeetingID)
);

CREATE TABLE Permissions(
    EmpID varchar(32) NOT NULL,
    PermissionKey SMALLINT(1) NOT NULL,
    CONSTRAINT PK_Prmsn PRIMARY KEY (EmpID,PermissionKey),
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)  
);

CREATE TABLE GeneralCoupon(
    CouponID varchar(32),
    EmpID varchar (32),
    CouponTxt varchar(16) UNIQUE,
    DateCreation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DateExpire DATETIME, -- If null--> till infinity
    CouponDiscount DOUBLE(3, 2) NOT NULL,
    CouponMaxDiscount DECIMAL(5, 2),
    IsForAll Binary,
    CONSTRAINT PK_cpn PRIMARY KEY (CouponID),
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID),
    CONSTRAINT CHK_DteCrtion CHECK(DateExpire > DateCreation),
    -- CONSTRAINT CHK_CpnTxt CHECK(len(CouponTxt)> 5),
    CONSTRAINT CHK_CpnDiscnt CHECK(CouponDiscount > 0),
    CONSTRAINT CHK_MxDiscount CHECK(CouponMaxDiscount > 0)
);
