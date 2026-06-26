USE [PeriodLimitedDb_Dev];
GO

/*
    期間限定 DB 回正軌版 v1
    依據：本對話定稿 ERD

    注意：此腳本適用 LocalDB 開發環境。
    若資料庫已有舊版錯誤結構，會先 Drop 相關 Table 後重建。
*/

/* Drop old / wrong tables first */
IF OBJECT_ID('dbo.EventTag', 'U') IS NOT NULL DROP TABLE dbo.EventTag;
IF OBJECT_ID('dbo.EventImage', 'U') IS NOT NULL DROP TABLE dbo.EventImage;
IF OBJECT_ID('dbo.Event', 'U') IS NOT NULL DROP TABLE dbo.Event;
IF OBJECT_ID('dbo.EventSource', 'U') IS NOT NULL DROP TABLE dbo.EventSource;
IF OBJECT_ID('dbo.Area', 'U') IS NOT NULL DROP TABLE dbo.Area;
IF OBJECT_ID('dbo.Tag', 'U') IS NOT NULL DROP TABLE dbo.Tag;
IF OBJECT_ID('dbo.Region', 'U') IS NOT NULL DROP TABLE dbo.Region;
IF OBJECT_ID('dbo.Category', 'U') IS NOT NULL DROP TABLE dbo.Category;
IF OBJECT_ID('dbo.[User]', 'U') IS NOT NULL DROP TABLE dbo.[User];
IF OBJECT_ID('dbo.SYS_CD', 'U') IS NOT NULL DROP TABLE dbo.SYS_CD;
GO

/* SYS_CD */
CREATE TABLE dbo.SYS_CD
(
    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_SYS_CD PRIMARY KEY,

    [Type] VARCHAR(50) NOT NULL,
    Code VARCHAR(50) NOT NULL,
    [Name] NVARCHAR(100) NOT NULL,
    Sort INT NOT NULL CONSTRAINT DF_SYS_CD_Sort DEFAULT(9999),

    EnableFlag BIT NOT NULL CONSTRAINT DF_SYS_CD_EnableFlag DEFAULT(0),
    DeleteFlag BIT NOT NULL CONSTRAINT DF_SYS_CD_DeleteFlag DEFAULT(0),

    CreateDate DATETIME2 NOT NULL CONSTRAINT DF_SYS_CD_CreateDate DEFAULT(SYSDATETIME()),
    CreateUser NVARCHAR(50) NOT NULL,
    ModifyDate DATETIME2 NULL,
    ModifyUser NVARCHAR(50) NULL,
    DeleteDate DATETIME2 NULL,
    DeleteUser NVARCHAR(50) NULL,

    CONSTRAINT UX_SYS_CD_Type_Code UNIQUE ([Type], Code)
);
GO

/* User */
CREATE TABLE dbo.[User]
(
    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_User PRIMARY KEY,

    Account NVARCHAR(50) NOT NULL,
    PasswordHash NVARCHAR(500) NOT NULL,
    [Name] NVARCHAR(50) NOT NULL,
    RoleCode VARCHAR(50) NOT NULL,

    EnableFlag BIT NOT NULL CONSTRAINT DF_User_EnableFlag DEFAULT(0),
    DeleteFlag BIT NOT NULL CONSTRAINT DF_User_DeleteFlag DEFAULT(0),

    CreateDate DATETIME2 NOT NULL CONSTRAINT DF_User_CreateDate DEFAULT(SYSDATETIME()),
    CreateUser NVARCHAR(50) NOT NULL,
    ModifyDate DATETIME2 NULL,
    ModifyUser NVARCHAR(50) NULL,
    DeleteDate DATETIME2 NULL,
    DeleteUser NVARCHAR(50) NULL,

    CONSTRAINT UX_User_Account UNIQUE (Account)
);
GO

/* Category */
CREATE TABLE dbo.Category
(
    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Category PRIMARY KEY,

    [Name] NVARCHAR(100) NOT NULL,
    Sort INT NOT NULL CONSTRAINT DF_Category_Sort DEFAULT(9999),

    EnableFlag BIT NOT NULL CONSTRAINT DF_Category_EnableFlag DEFAULT(0),
    DeleteFlag BIT NOT NULL CONSTRAINT DF_Category_DeleteFlag DEFAULT(0),

    CreateDate DATETIME2 NOT NULL CONSTRAINT DF_Category_CreateDate DEFAULT(SYSDATETIME()),
    CreateUser NVARCHAR(50) NOT NULL,
    ModifyDate DATETIME2 NULL,
    ModifyUser NVARCHAR(50) NULL,
    DeleteDate DATETIME2 NULL,
    DeleteUser NVARCHAR(50) NULL,

    CONSTRAINT UX_Category_Name UNIQUE ([Name])
);
GO

/* Region */
CREATE TABLE dbo.Region
(
    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Region PRIMARY KEY,

    AreaCode VARCHAR(50) NOT NULL,
    City NVARCHAR(50) NOT NULL,
    District NVARCHAR(50) NOT NULL,
    [Name] NVARCHAR(100) NOT NULL,
    Sort INT NOT NULL CONSTRAINT DF_Region_Sort DEFAULT(9999),

    EnableFlag BIT NOT NULL CONSTRAINT DF_Region_EnableFlag DEFAULT(0),
    DeleteFlag BIT NOT NULL CONSTRAINT DF_Region_DeleteFlag DEFAULT(0),

    CreateDate DATETIME2 NOT NULL CONSTRAINT DF_Region_CreateDate DEFAULT(SYSDATETIME()),
    CreateUser NVARCHAR(50) NOT NULL,
    ModifyDate DATETIME2 NULL,
    ModifyUser NVARCHAR(50) NULL,
    DeleteDate DATETIME2 NULL,
    DeleteUser NVARCHAR(50) NULL,

    CONSTRAINT UX_Region_Name UNIQUE ([Name])
);
GO

/* Tag */
CREATE TABLE dbo.Tag
(
    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Tag PRIMARY KEY,

    [Name] NVARCHAR(100) NOT NULL,
    Sort INT NOT NULL CONSTRAINT DF_Tag_Sort DEFAULT(9999),

    EnableFlag BIT NOT NULL CONSTRAINT DF_Tag_EnableFlag DEFAULT(0),
    DeleteFlag BIT NOT NULL CONSTRAINT DF_Tag_DeleteFlag DEFAULT(0),

    CreateDate DATETIME2 NOT NULL CONSTRAINT DF_Tag_CreateDate DEFAULT(SYSDATETIME()),
    CreateUser NVARCHAR(50) NOT NULL,
    ModifyDate DATETIME2 NULL,
    ModifyUser NVARCHAR(50) NULL,
    DeleteDate DATETIME2 NULL,
    DeleteUser NVARCHAR(50) NULL,

    CONSTRAINT UX_Tag_Name UNIQUE ([Name])
);
GO

/* Event */
CREATE TABLE dbo.Event
(
    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Event PRIMARY KEY,

    Title NVARCHAR(200) NOT NULL,
    Summary NVARCHAR(500) NULL,
    CategoryId INT NOT NULL,
    EventTypeCode VARCHAR(50) NOT NULL,
    RegionId INT NOT NULL,
    Address NVARCHAR(300) NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    OrganizerName NVARCHAR(100) NULL,
    ImageUrl NVARCHAR(500) NOT NULL,
    [Description] NVARCHAR(MAX) NOT NULL,
    OfficialUrl NVARCHAR(500) NULL,
    SourceUrl NVARCHAR(500) NOT NULL,
    ContentStatusCode VARCHAR(50) NOT NULL,
    PeriodStatusCode VARCHAR(50) NOT NULL,
    Sort INT NOT NULL CONSTRAINT DF_Event_Sort DEFAULT(9999),

    EnableFlag BIT NOT NULL CONSTRAINT DF_Event_EnableFlag DEFAULT(0),
    DeleteFlag BIT NOT NULL CONSTRAINT DF_Event_DeleteFlag DEFAULT(0),

    CreateDate DATETIME2 NOT NULL CONSTRAINT DF_Event_CreateDate DEFAULT(SYSDATETIME()),
    CreateUser NVARCHAR(50) NOT NULL,
    ModifyDate DATETIME2 NULL,
    ModifyUser NVARCHAR(50) NULL,
    DeleteDate DATETIME2 NULL,
    DeleteUser NVARCHAR(50) NULL,

    CONSTRAINT FK_Event_Category FOREIGN KEY (CategoryId) REFERENCES dbo.Category(Id),
    CONSTRAINT FK_Event_Region FOREIGN KEY (RegionId) REFERENCES dbo.Region(Id),
    CONSTRAINT CK_Event_DateRange CHECK (EndDate >= StartDate)
);
GO

/* EventTag */
CREATE TABLE dbo.EventTag
(
    EventId INT NOT NULL,
    TagId INT NOT NULL,

    CreateDate DATETIME2 NOT NULL CONSTRAINT DF_EventTag_CreateDate DEFAULT(SYSDATETIME()),
    CreateUser NVARCHAR(50) NOT NULL,

    CONSTRAINT PK_EventTag PRIMARY KEY (EventId, TagId),
    CONSTRAINT FK_EventTag_Event FOREIGN KEY (EventId) REFERENCES dbo.Event(Id),
    CONSTRAINT FK_EventTag_Tag FOREIGN KEY (TagId) REFERENCES dbo.Tag(Id)
);
GO

/* Index */
CREATE INDEX IX_Event_List
ON dbo.Event(ContentStatusCode, PeriodStatusCode, DeleteFlag, Sort, StartDate, EndDate);
GO

CREATE INDEX IX_Event_CategoryId
ON dbo.Event(CategoryId);
GO

CREATE INDEX IX_Event_RegionId
ON dbo.Event(RegionId);
GO

CREATE INDEX IX_Event_EventTypeCode
ON dbo.Event(EventTypeCode);
GO

CREATE INDEX IX_EventTag_TagId
ON dbo.EventTag(TagId);
GO

/* Seed SYS_CD */
INSERT INTO dbo.SYS_CD ([Type], Code, [Name], Sort, CreateUser)
VALUES
('EVENT_TYPE', 'PHYSICAL', N'實體', 1, N'system'),
('EVENT_TYPE', 'STORE', N'門市', 2, N'system'),
('EVENT_TYPE', 'ONLINE', N'線上', 3, N'system'),

('CONTENT_STATUS', 'DRAFT', N'草稿', 1, N'system'),
('CONTENT_STATUS', 'PUBLISHED', N'已發布', 2, N'system'),
('CONTENT_STATUS', 'HIDDEN', N'已隱藏', 3, N'system'),

('PERIOD_STATUS', 'UPCOMING', N'即將開始', 1, N'system'),
('PERIOD_STATUS', 'ONGOING', N'進行中', 2, N'system'),
('PERIOD_STATUS', 'ENDED', N'已結束', 3, N'system'),

('USER_ROLE', 'ADMIN', N'系統管理員', 1, N'system'),
('USER_ROLE', 'EDITOR', N'內容編輯者', 2, N'system'),

('AREA', 'NORTH', N'北部', 1, N'system'),
('AREA', 'CENTRAL', N'中部', 2, N'system'),
('AREA', 'SOUTH', N'南部', 3, N'system'),
('AREA', 'EAST', N'東部', 4, N'system'),
('AREA', 'ISLANDS', N'離島', 5, N'system');
GO

/* Seed Category */
INSERT INTO dbo.Category ([Name], Sort, CreateUser)
VALUES
(N'快閃店', 1, N'system'),
(N'展覽', 2, N'system'),
(N'動漫活動', 3, N'system'),
(N'演唱會', 4, N'system'),
(N'市集', 5, N'system'),
(N'美食活動', 6, N'system'),
(N'期間限定商品', 7, N'system'),
(N'其他', 9999, N'system');
GO

/* Verify */
SELECT [Type], Code, [Name], Sort
FROM dbo.SYS_CD
WHERE DeleteFlag = 0
ORDER BY [Type], Sort;
GO
