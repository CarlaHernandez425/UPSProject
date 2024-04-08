USE [master]
GO
/****** Object:  Database [dbgroup5]    Script Date: 4/7/2024 7:58:00 PM ******/
CREATE DATABASE [dbgroup5]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'dbgroup5', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\dbgroup5.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'dbgroup5_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\dbgroup5_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [dbgroup5] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [dbgroup5].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [dbgroup5] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [dbgroup5] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [dbgroup5] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [dbgroup5] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [dbgroup5] SET ARITHABORT OFF 
GO
ALTER DATABASE [dbgroup5] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [dbgroup5] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [dbgroup5] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [dbgroup5] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [dbgroup5] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [dbgroup5] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [dbgroup5] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [dbgroup5] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [dbgroup5] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [dbgroup5] SET  ENABLE_BROKER 
GO
ALTER DATABASE [dbgroup5] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [dbgroup5] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [dbgroup5] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [dbgroup5] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [dbgroup5] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [dbgroup5] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [dbgroup5] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [dbgroup5] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [dbgroup5] SET  MULTI_USER 
GO
ALTER DATABASE [dbgroup5] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [dbgroup5] SET DB_CHAINING OFF 
GO
ALTER DATABASE [dbgroup5] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [dbgroup5] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [dbgroup5] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [dbgroup5] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [dbgroup5] SET QUERY_STORE = ON
GO
ALTER DATABASE [dbgroup5] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [dbgroup5]
GO
/****** Object:  Schema [dbgroupfive]    Script Date: 4/7/2024 7:58:00 PM ******/
CREATE SCHEMA [dbgroupfive]
GO
/****** Object:  Schema [m2ss]    Script Date: 4/7/2024 7:58:00 PM ******/
CREATE SCHEMA [m2ss]
GO
/****** Object:  UserDefinedFunction [dbgroupfive].[enum2str$employee_vacations$status]    Script Date: 4/7/2024 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbgroupfive].[enum2str$employee_vacations$status] 
( 
   @setval tinyint
)
RETURNS nvarchar(max)
AS 
   BEGIN
      RETURN 
         CASE @setval
            WHEN 1 THEN 'Pending'
            WHEN 2 THEN 'Approved'
            WHEN 3 THEN 'Denied'
            WHEN 4 THEN ''
            ELSE ''
         END
   END
GO
/****** Object:  UserDefinedFunction [dbgroupfive].[enum2str$shift_switch$Status]    Script Date: 4/7/2024 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbgroupfive].[enum2str$shift_switch$Status] 
( 
   @setval tinyint
)
RETURNS nvarchar(max)
AS 
   BEGIN
      RETURN 
         CASE @setval
            WHEN 1 THEN 'Pending'
            WHEN 2 THEN 'Approved'
            WHEN 3 THEN 'Denied'
            WHEN 4 THEN ''
            ELSE ''
         END
   END
GO
/****** Object:  UserDefinedFunction [dbgroupfive].[norm_enum$employee_vacations$status]    Script Date: 4/7/2024 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbgroupfive].[norm_enum$employee_vacations$status] 
( 
   @setval nvarchar(max)
)
RETURNS nvarchar(max)
AS 
   BEGIN
      RETURN dbgroupfive.enum2str$employee_vacations$status(dbgroupfive.str2enum$employee_vacations$status(@setval))
   END
GO
/****** Object:  UserDefinedFunction [dbgroupfive].[norm_enum$shift_switch$Status]    Script Date: 4/7/2024 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbgroupfive].[norm_enum$shift_switch$Status] 
( 
   @setval nvarchar(max)
)
RETURNS nvarchar(max)
AS 
   BEGIN
      RETURN dbgroupfive.enum2str$shift_switch$Status(dbgroupfive.str2enum$shift_switch$Status(@setval))
   END
GO
/****** Object:  UserDefinedFunction [dbgroupfive].[str2enum$employee_vacations$status]    Script Date: 4/7/2024 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbgroupfive].[str2enum$employee_vacations$status] 
( 
   @setval nvarchar(max)
)
RETURNS tinyint
AS 
   BEGIN
      RETURN 
         CASE @setval
            WHEN 'Pending' THEN 1
            WHEN 'Approved' THEN 2
            WHEN 'Denied' THEN 3
            WHEN '' THEN 4
            ELSE 0
         END
   END
GO
/****** Object:  UserDefinedFunction [dbgroupfive].[str2enum$shift_switch$Status]    Script Date: 4/7/2024 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbgroupfive].[str2enum$shift_switch$Status] 
( 
   @setval nvarchar(max)
)
RETURNS tinyint
AS 
   BEGIN
      RETURN 
         CASE @setval
            WHEN 'Pending' THEN 1
            WHEN 'Approved' THEN 2
            WHEN 'Denied' THEN 3
            WHEN '' THEN 4
            ELSE 0
         END
   END
GO
/****** Object:  UserDefinedFunction [m2ss].[str_to_datetime]    Script Date: 4/7/2024 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [m2ss].[str_to_datetime](@val NVARCHAR(max)) RETURNS DATETIME2(0)
AS
  BEGIN
    IF(@val IS NULL)
        RETURN NULL

    DECLARE @StrVal VARCHAR(MAX)
    DECLARE @StrOutVal VARCHAR(20)
    DECLARE @YearPart VARCHAR(20)
    DECLARE @MonPart VARCHAR(20)
    DECLARE @DayPart VARCHAR(20)
    DECLARE @HrPart VARCHAR(20)
    DECLARE @MinPart VARCHAR(20)
    DECLARE @SecPart VARCHAR(20)
    DECLARE @TempCnt INT
    DECLARE @Tempstring VARCHAR(MAX)
    DECLARE @Tempstring1 VARCHAR(MAX)
    DECLARE @StartIndex INT
    DECLARE @EndIndex INT
    DECLARE @TokenIndex INT
    DECLARE @InputLen INT

    --Removing leading and trailing spaces
    SET @val = RTRIM(LTRIM(@val))

    DECLARE @Punctuation VARCHAR(MAX)
    DECLARE @PunctuationLen INT
    DECLARE @PunctuationCounter INT
    
    --Replacing all the punctuation characters with '-'
    SET @Punctuation = '~!@#$%^&*()_+-={}[]|\:"<>?;'',./'
    SET @PunctuationLen = LEN(@Punctuation)
    SET @PunctuationCounter = 1
      WHILE (@PunctuationCounter <= @PunctuationLen)
        BEGIN
            SET @val = REPLACE(@val, SUBSTRING(@Punctuation,@PunctuationCounter,1),'-')
            Set @PunctuationCounter = @PunctuationCounter + 1
        END

    SET @TempCnt = 1

    --Replacing more than one occurence of '-' with single occurence
      WHILE(@val LIKE '%--%')
        BEGIN
          SET @val = REPLACE(@val,'--','-')
        END

    SET @StrVal = @val

    SET @TempCnt = 1

    --If the string has any punctuation.
    IF(@val LIKE '%-%')
      BEGIN
        SET @InputLen = LEN(@val)
        SET @Tempstring = @val
        SET @Tempstring1 = @val
        SET @StartIndex = 1
        SET @EndIndex = PATINDEX('%-%',@Tempstring1)
        SET @TokenIndex = 0
        WHILE(PATINDEX('%-%',@Tempstring1) > 0 AND @TokenIndex <= 6)
          BEGIN
            SET @EndIndex = PATINDEX('%-%',@Tempstring1)
            SET @Tempstring = SUBSTRING(@Tempstring1,@StartIndex,@EndIndex-1)
            SET @TokenIndex = @TokenIndex +1

        IF(@Tempstring LIKE '% %' AND @TokenIndex <> 3)
        RETURN NULL
        IF(@TokenIndex = 3 AND @Tempstring LIKE '% %' )
          BEGIN
            SET @Tempstring = SUBSTRING(@Tempstring1,@StartIndex,PATINDEX('% %',@Tempstring1)-1)
            SET @EndIndex = PATINDEX('% %',@Tempstring1)
          END

        IF(@TokenIndex = 1)
            SET @YearPart = @Tempstring
        ELSE IF(@TokenIndex = 2)
            SET @MonPart = @Tempstring
        ELSE IF(@TokenIndex = 3)
            SET @DayPart = @Tempstring
        ELSE IF(@TokenIndex = 4)
            SET @HrPart = @Tempstring
        ELSE IF(@TokenIndex = 5)
            SET @MinPart = @Tempstring
        ELSE IF(@TokenIndex = 6)
            SET @SecPart = @Tempstring

        SET @Tempstring1 = SUBSTRING(@Tempstring1,@EndIndex+1,@InputLen-@EndIndex)

        --Removing punctuations and space characters between date and time part
        WHILE(@TempCnt <= LEN(@Tempstring1) AND @TokenIndex = 3 )
          BEGIN
              IF(ASCII(SUBSTRING(@Tempstring1,@TempCnt,1)) BETWEEN 48 AND 57)
                BEGIN
                  SET @Tempstring1 = SUBSTRING(@Tempstring1,@TempCnt,LEN(@Tempstring1))
                  SET @Tempstring1 = RTRIM(@Tempstring1)
                  SET @TempCnt = LEN(@Tempstring1)+1
                END
            SET @TempCnt = @TempCnt +1
          END
      END

      --If Day part is not present
      IF(@TokenIndex < 2)
          RETURN NULL
      --If only two punctuations are there
      IF(@TokenIndex = 2)
        BEGIN
            IF(@Tempstring1 LIKE '% %')
              BEGIN
                  SET @DayPart = LEFT(@Tempstring1,PATINDEX('% %',@Tempstring1)-1)
                  SET @HrPart = LTRIM(SUBSTRING(@Tempstring1,PATINDEX('% %',@Tempstring1)+1,LEN(@Tempstring1)))
              END
            ELSE
              SET @DayPart = @Tempstring1      
        END

      IF(@TokenIndex = 3)   
        SET @HrPart = @Tempstring1 
      IF(@TokenIndex = 4)    
        SET @MinPart = @Tempstring1 
      IF(@TokenIndex = 5)    
        SET @SecPart = @Tempstring1  

        SET @HrPart = CASE WHEN @HrPart IS NULL THEN '0' 
                           WHEN @HrPart ='' THEN '0' 
                           ELSE @HrPart
                      END
        SET @MinPart = CASE WHEN @MinPart IS NULL THEN '0'
                            WHEN @MinPart ='' THEN '0' 
                            ELSE @MinPart 
                        END
        SET @SecPart = CASE WHEN @SecPart IS NULL THEN '0' 
                            WHEN @SecPart ='' THEN '0' 
                            ELSE @SecPart 
                        END

    --Validating Year,Month,Day,Hr,Min,Sec Part
    IF(LEN(@YearPart) > 4 OR LEN(@YearPart) < 2 OR ISNUMERIC(@YearPart) =0  OR
          LEN(@MonPart) > 2 OR ISNUMERIC(@MonPart)=0 OR LEN(@DayPart) > 2 
          OR ISNUMERIC(@DayPart)=0 OR LEN(@HrPart) > 2 OR ISNUMERIC(@HrPart)=0 OR 
          LEN(@MinPart) > 2 OR ISNUMERIC(@MinPart)=0 OR
          LEN(@SecPart) > 2 OR ISNUMERIC(@SecPart)=0)
      BEGIN
          RETURN NULL  
      END 

    IF(LEN(@YearPart) = 2)
      BEGIN
        SET @YearPart = CASE WHEN @YearPart > '69' THEN '19' + @YearPart ELSE '20' + @YearPart END
      END 

    SET @StrOutVal = @YearPart + '-' + @MonPart + '-' + @DayPart + ' ' + 
        @HrPart + ':' + @MinPart + ':' + @SecPart 

  END 
  ELSE
  --If the string has no punctuation.
  BEGIN
     --check for the space in input string
     IF(@StrVal like '% %')
      BEGIN
       RETURN NULL
      END
     --Considering first 14 characters
     SET @StrVal = LEFT(@StrVal,14) 

     IF(LEN(@StrVal) <5)
      BEGIN
          RETURN NULL
      END

     IF(LEN(@StrVal) = 5)
      BEGIN
          SET @StrOutVal = CASE WHEN LEFT(@StrVal,2) >
                                    '69' THEN '19'
                                ELSE '20' END + LEFT(@StrVal,2) + '-'
                                      +SUBSTRING(@StrVal,3,2) + '-' +
                                      RIGHT(@StrVal,1)
                           END

      IF(LEN(@StrVal) = 6)
        BEGIN
          SET @StrOutVal = CASE WHEN LEFT(@StrVal,2) > '69' THEN '19'
                                ELSE '20' END + LEFT(@StrVal,2) + '-'
                                              +SUBSTRING(@StrVal,3,2) + '-' +
                                              RIGHT(@StrVal,2)
        END

      IF(LEN(@StrVal) = 7)
        BEGIN
          SET @StrOutVal = CASE WHEN LEFT(@StrVal,2) > '69' THEN '19'
                                ELSE '20' END + LEFT(@StrVal,2) + '-'
                                      +SUBSTRING(@StrVal,3,2) + '-' +
                                      SUBSTRING(@StrVal,5,2)
        END

      IF(LEN(@StrVal) = 8)
        BEGIN
          SET @StrOutVal = LEFT(@StrVal,4) + '-'+SUBSTRING(@StrVal,5,2)
              + '-' + RIGHT(@StrVal,2)
          END

      IF(LEN(@StrVal) = 9)
        BEGIN
          SET @StrOutVal = CASE WHEN LEFT(@StrVal,2) > '69' THEN '19'
                                ELSE '20' END +
                                                LEFT(@StrVal,2) + '-'+SUBSTRING(@StrVal,3,2)
                                                + '-' + SUBSTRING(@StrVal,5,2)+' '
                                                + SUBSTRING(@StrVal,7,2)+ ':' +
                                                SUBSTRING(@StrVal,9,1)
        END

      IF(LEN(@StrVal) = 10)
        BEGIN
          SET @StrOutVal = CASE WHEN LEFT(@StrVal,2) > '69' THEN '19'
                                ELSE '20' END +
                                                LEFT(@StrVal,2) + '-'+SUBSTRING(@StrVal,3,2)
                                                + '-' + SUBSTRING(@StrVal,5,2)+' '
                                                + SUBSTRING(@StrVal,7,2)+ ':' +
                                                SUBSTRING(@StrVal,9,2)
        END

      IF(LEN(@StrVal) = 11)
        BEGIN
          SET @StrOutVal = CASE WHEN LEFT(@StrVal,2) > '69' THEN '19'
                                ELSE '20' END +
                                                LEFT(@StrVal,2) + '-'+SUBSTRING(@StrVal,3,2)
                                                + '-' + SUBSTRING(@StrVal,5,2)+' '
                                                + SUBSTRING(@StrVal,7,2)+ ':' +
                                                SUBSTRING(@StrVal,9,2)+ ':' +
                                                SUBSTRING(@StrVal,11,1)
        END

      IF(LEN(@StrVal) = 12)
        BEGIN
          SET @StrOutVal = CASE WHEN LEFT(@StrVal,2) > '69' THEN '19' ELSE '20' END +
                            LEFT(@StrVal,2) + '-'+SUBSTRING(@StrVal,3,2)
                            + '-' + SUBSTRING(@StrVal,5,2)+' '
                            + SUBSTRING(@StrVal,7,2)+ ':' +
                            SUBSTRING(@StrVal,9,2)+ ':' +
                            SUBSTRING(@StrVal,11,2)
        END

      IF(LEN(@StrVal) = 13)
        BEGIN
            SET @StrOutVal = CASE WHEN LEFT(@StrVal,2) > '69' THEN '19' ELSE '20' END +
                              LEFT(@StrVal,2) + '-'+SUBSTRING(@StrVal,3,2) + '-' +
                              SUBSTRING(@StrVal,5,2)+' '
                              + SUBSTRING(@StrVal,7,2)+ ':' +
                              SUBSTRING(@StrVal,9,2)+
                              ':' + SUBSTRING(@StrVal,11,2)
        END

      IF(LEN(@StrVal) = 14)
        BEGIN
            SET @StrOutVal = LEFT(@StrVal,4) + '-'+SUBSTRING(@StrVal,5,2) + '-' +
                              SUBSTRING(@StrVal,7,2)+' '
                              + SUBSTRING(@StrVal,9,2)+ ':' +
                              SUBSTRING(@StrVal,11,2)+
                              ':' + SUBSTRING(@StrVal,13,2)
        END
    END
        --Check for valid date
        DECLARE @Year INT
        SET @Year = CAST(LEFT(@StrOutVal, 4) AS INT) % 2000 + 2000

        IF(ISDATE(CAST(@Year + 2000 AS VARCHAR(4)) + RIGHT(@StrOutVal, LEN(@StrOutVal) - 4)) = 1)
              RETURN CONVERT(DATETIME2(0), @StrOutVal, 120)
              
     RETURN NULL
  END
GO
/****** Object:  Table [dbgroupfive].[bonuses]    Script Date: 4/7/2024 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbgroupfive].[bonuses](
	[BonusID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NULL,
	[BonusType] [nvarchar](45) NULL,
	[BonusRecordID] [int] NULL,
	[BonusAmount] [decimal](10, 2) NULL,
	[BonusDate] [date] NULL,
 CONSTRAINT [PK_bonuses_BonusID] PRIMARY KEY CLUSTERED 
(
	[BonusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbgroupfive].[dailysales]    Script Date: 4/7/2024 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbgroupfive].[dailysales](
	[DailySaleID] [int] IDENTITY(21,1) NOT NULL,
	[Date] [date] NULL,
	[TotalTendered] [decimal](10, 2) NULL,
	[TotalDeposited] [decimal](10, 2) NULL,
	[BankRunAmount] [decimal](10, 2) NULL,
 CONSTRAINT [PK_dailysales_DailySaleID] PRIMARY KEY CLUSTERED 
(
	[DailySaleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbgroupfive].[employee_vacations]    Script Date: 4/7/2024 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbgroupfive].[employee_vacations](
	[vacation_id] [int] IDENTITY(1,1) NOT NULL,
	[employee_id] [int] NOT NULL,
	[request_date] [nvarchar](255) NOT NULL,
	[start_date] [nvarchar](255) NOT NULL,
	[end_date] [nvarchar](255) NOT NULL,
	[status] [nvarchar](8) NOT NULL,
 CONSTRAINT [PK_employee_vacations_vacation_id] PRIMARY KEY CLUSTERED 
(
	[vacation_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbgroupfive].[employees]    Script Date: 4/7/2024 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbgroupfive].[employees](
	[EmployeeID] [int] IDENTITY(10,1) NOT NULL,
	[FirstName] [nvarchar](45) NULL,
	[LastName] [nvarchar](45) NULL,
	[Username] [nvarchar](255) NOT NULL,
	[Password] [nvarchar](255) NOT NULL,
	[Position] [nvarchar](45) NULL,
	[IsActive] [smallint] NOT NULL,
	[IsAdmin] [smallint] NOT NULL,
 CONSTRAINT [PK_employees_EmployeeID] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbgroupfive].[mailboxes]    Script Date: 4/7/2024 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbgroupfive].[mailboxes](
	[MailboxID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NULL,
	[EmployeeID] [int] NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[BonusID] [int] NULL,
 CONSTRAINT [PK_mailboxes_MailboxID] PRIMARY KEY CLUSTERED 
(
	[MailboxID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbgroupfive].[notaries]    Script Date: 4/7/2024 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbgroupfive].[notaries](
	[NotaryID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NULL,
	[EmployeeID] [int] NULL,
	[Date] [date] NULL,
	[BonusID] [int] NULL,
 CONSTRAINT [PK_notaries_NotaryID] PRIMARY KEY CLUSTERED 
(
	[NotaryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbgroupfive].[registers]    Script Date: 4/7/2024 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbgroupfive].[registers](
	[RegisterID] [int] IDENTITY(4,1) NOT NULL,
	[RegisterName] [nvarchar](45) NULL,
 CONSTRAINT [PK_registers_RegisterID] PRIMARY KEY CLUSTERED 
(
	[RegisterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbgroupfive].[sales]    Script Date: 4/7/2024 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbgroupfive].[sales](
	[SaleID] [int] IDENTITY(12,1) NOT NULL,
	[RegisterID] [int] NULL,
	[EmployeeID] [int] NULL,
	[SaleDate] [date] NULL,
	[SaleAmount] [decimal](10, 2) NULL,
	[TenderedAmount] [decimal](10, 2) NULL,
	[DepositAmount] [decimal](10, 2) NULL,
 CONSTRAINT [PK_sales_SaleID] PRIMARY KEY CLUSTERED 
(
	[SaleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbgroupfive].[shift_switch]    Script Date: 4/7/2024 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbgroupfive].[shift_switch](
	[RequestID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[SwitchDate] [nvarchar](255) NOT NULL,
	[RequestDate] [nvarchar](255) NOT NULL,
	[Status] [nvarchar](8) NOT NULL,
 CONSTRAINT [PK_shift_switch_RequestID] PRIMARY KEY CLUSTERED 
(
	[RequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbgroupfive].[shifts]    Script Date: 4/7/2024 7:58:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbgroupfive].[shifts](
	[ShiftID] [int] IDENTITY(29,1) NOT NULL,
	[EmployeeID] [int] NULL,
	[ShiftDate] [nvarchar](255) NULL,
	[ScheduledStart] [nvarchar](255) NULL,
	[ScheduledEnd] [nvarchar](255) NULL,
	[ActualStart] [nvarchar](255) NULL,
	[ActualEnd] [nvarchar](255) NULL,
	[TotalHours] [decimal](10, 2) NULL,
	[ssma$rowid] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_shifts_ShiftID] PRIMARY KEY CLUSTERED 
(
	[ShiftID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_shifts_ssma$rowid] UNIQUE NONCLUSTERED 
(
	[ssma$rowid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [Employee-Bonus-Relation_idx]    Script Date: 4/7/2024 7:58:00 PM ******/
CREATE NONCLUSTERED INDEX [Employee-Bonus-Relation_idx] ON [dbgroupfive].[bonuses]
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Employee-Vacation-Relation]    Script Date: 4/7/2024 7:58:00 PM ******/
CREATE NONCLUSTERED INDEX [Employee-Vacation-Relation] ON [dbgroupfive].[employee_vacations]
(
	[employee_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Bonus-Mailbox-Relation_idx]    Script Date: 4/7/2024 7:58:00 PM ******/
CREATE NONCLUSTERED INDEX [Bonus-Mailbox-Relation_idx] ON [dbgroupfive].[mailboxes]
(
	[BonusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Employee-Mailbox-Relation_idx]    Script Date: 4/7/2024 7:58:00 PM ******/
CREATE NONCLUSTERED INDEX [Employee-Mailbox-Relation_idx] ON [dbgroupfive].[mailboxes]
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Bonus-Notary-Relation_idx]    Script Date: 4/7/2024 7:58:00 PM ******/
CREATE NONCLUSTERED INDEX [Bonus-Notary-Relation_idx] ON [dbgroupfive].[notaries]
(
	[BonusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Employee-Notary-Relation_idx]    Script Date: 4/7/2024 7:58:00 PM ******/
CREATE NONCLUSTERED INDEX [Employee-Notary-Relation_idx] ON [dbgroupfive].[notaries]
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Employee-Sales-Relation_idx]    Script Date: 4/7/2024 7:58:00 PM ******/
CREATE NONCLUSTERED INDEX [Employee-Sales-Relation_idx] ON [dbgroupfive].[sales]
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Register-Sales-Relation_idx]    Script Date: 4/7/2024 7:58:00 PM ******/
CREATE NONCLUSTERED INDEX [Register-Sales-Relation_idx] ON [dbgroupfive].[sales]
(
	[RegisterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Employee-Switch-Relation]    Script Date: 4/7/2024 7:58:00 PM ******/
CREATE NONCLUSTERED INDEX [Employee-Switch-Relation] ON [dbgroupfive].[shift_switch]
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [EmployeeID_idx]    Script Date: 4/7/2024 7:58:00 PM ******/
CREATE NONCLUSTERED INDEX [EmployeeID_idx] ON [dbgroupfive].[shifts]
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbgroupfive].[bonuses] ADD  DEFAULT (NULL) FOR [EmployeeID]
GO
ALTER TABLE [dbgroupfive].[bonuses] ADD  DEFAULT (NULL) FOR [BonusType]
GO
ALTER TABLE [dbgroupfive].[bonuses] ADD  DEFAULT (NULL) FOR [BonusRecordID]
GO
ALTER TABLE [dbgroupfive].[bonuses] ADD  DEFAULT (NULL) FOR [BonusAmount]
GO
ALTER TABLE [dbgroupfive].[bonuses] ADD  DEFAULT (NULL) FOR [BonusDate]
GO
ALTER TABLE [dbgroupfive].[dailysales] ADD  DEFAULT (NULL) FOR [Date]
GO
ALTER TABLE [dbgroupfive].[dailysales] ADD  DEFAULT (NULL) FOR [TotalTendered]
GO
ALTER TABLE [dbgroupfive].[dailysales] ADD  DEFAULT (NULL) FOR [TotalDeposited]
GO
ALTER TABLE [dbgroupfive].[dailysales] ADD  DEFAULT (NULL) FOR [BankRunAmount]
GO
ALTER TABLE [dbgroupfive].[employees] ADD  DEFAULT (NULL) FOR [FirstName]
GO
ALTER TABLE [dbgroupfive].[employees] ADD  DEFAULT (NULL) FOR [LastName]
GO
ALTER TABLE [dbgroupfive].[employees] ADD  DEFAULT (NULL) FOR [Position]
GO
ALTER TABLE [dbgroupfive].[mailboxes] ADD  DEFAULT (NULL) FOR [CustomerID]
GO
ALTER TABLE [dbgroupfive].[mailboxes] ADD  DEFAULT (NULL) FOR [EmployeeID]
GO
ALTER TABLE [dbgroupfive].[mailboxes] ADD  DEFAULT (NULL) FOR [StartDate]
GO
ALTER TABLE [dbgroupfive].[mailboxes] ADD  DEFAULT (NULL) FOR [EndDate]
GO
ALTER TABLE [dbgroupfive].[mailboxes] ADD  DEFAULT (NULL) FOR [BonusID]
GO
ALTER TABLE [dbgroupfive].[notaries] ADD  DEFAULT (NULL) FOR [CustomerID]
GO
ALTER TABLE [dbgroupfive].[notaries] ADD  DEFAULT (NULL) FOR [EmployeeID]
GO
ALTER TABLE [dbgroupfive].[notaries] ADD  DEFAULT (NULL) FOR [Date]
GO
ALTER TABLE [dbgroupfive].[notaries] ADD  DEFAULT (NULL) FOR [BonusID]
GO
ALTER TABLE [dbgroupfive].[registers] ADD  DEFAULT (NULL) FOR [RegisterName]
GO
ALTER TABLE [dbgroupfive].[sales] ADD  DEFAULT (NULL) FOR [RegisterID]
GO
ALTER TABLE [dbgroupfive].[sales] ADD  DEFAULT (NULL) FOR [EmployeeID]
GO
ALTER TABLE [dbgroupfive].[sales] ADD  DEFAULT (NULL) FOR [SaleDate]
GO
ALTER TABLE [dbgroupfive].[sales] ADD  DEFAULT (NULL) FOR [SaleAmount]
GO
ALTER TABLE [dbgroupfive].[sales] ADD  DEFAULT (NULL) FOR [TenderedAmount]
GO
ALTER TABLE [dbgroupfive].[sales] ADD  DEFAULT (NULL) FOR [DepositAmount]
GO
ALTER TABLE [dbgroupfive].[shifts] ADD  DEFAULT (NULL) FOR [EmployeeID]
GO
ALTER TABLE [dbgroupfive].[shifts] ADD  DEFAULT (NULL) FOR [ShiftDate]
GO
ALTER TABLE [dbgroupfive].[shifts] ADD  DEFAULT (NULL) FOR [ScheduledStart]
GO
ALTER TABLE [dbgroupfive].[shifts] ADD  DEFAULT (NULL) FOR [ScheduledEnd]
GO
ALTER TABLE [dbgroupfive].[shifts] ADD  DEFAULT (NULL) FOR [ActualStart]
GO
ALTER TABLE [dbgroupfive].[shifts] ADD  DEFAULT (NULL) FOR [ActualEnd]
GO
ALTER TABLE [dbgroupfive].[shifts] ADD  DEFAULT (NULL) FOR [TotalHours]
GO
ALTER TABLE [dbgroupfive].[shifts] ADD  DEFAULT (newid()) FOR [ssma$rowid]
GO
ALTER TABLE [dbgroupfive].[bonuses]  WITH NOCHECK ADD  CONSTRAINT [bonuses$Employee-Bonus-Relation] FOREIGN KEY([EmployeeID])
REFERENCES [dbgroupfive].[employees] ([EmployeeID])
GO
ALTER TABLE [dbgroupfive].[bonuses] CHECK CONSTRAINT [bonuses$Employee-Bonus-Relation]
GO
ALTER TABLE [dbgroupfive].[employee_vacations]  WITH NOCHECK ADD  CONSTRAINT [employee_vacations$Employee-Vacation-Relation] FOREIGN KEY([employee_id])
REFERENCES [dbgroupfive].[employees] ([EmployeeID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbgroupfive].[employee_vacations] CHECK CONSTRAINT [employee_vacations$Employee-Vacation-Relation]
GO
ALTER TABLE [dbgroupfive].[mailboxes]  WITH NOCHECK ADD  CONSTRAINT [mailboxes$Bonus-Mailbox-Relation] FOREIGN KEY([BonusID])
REFERENCES [dbgroupfive].[bonuses] ([BonusID])
GO
ALTER TABLE [dbgroupfive].[mailboxes] CHECK CONSTRAINT [mailboxes$Bonus-Mailbox-Relation]
GO
ALTER TABLE [dbgroupfive].[mailboxes]  WITH NOCHECK ADD  CONSTRAINT [mailboxes$Employee-Mailbox-Relation] FOREIGN KEY([EmployeeID])
REFERENCES [dbgroupfive].[employees] ([EmployeeID])
GO
ALTER TABLE [dbgroupfive].[mailboxes] CHECK CONSTRAINT [mailboxes$Employee-Mailbox-Relation]
GO
ALTER TABLE [dbgroupfive].[notaries]  WITH NOCHECK ADD  CONSTRAINT [notaries$Bonus-Notary-Relation] FOREIGN KEY([BonusID])
REFERENCES [dbgroupfive].[bonuses] ([BonusID])
GO
ALTER TABLE [dbgroupfive].[notaries] CHECK CONSTRAINT [notaries$Bonus-Notary-Relation]
GO
ALTER TABLE [dbgroupfive].[notaries]  WITH NOCHECK ADD  CONSTRAINT [notaries$Employee-Notary-Relation] FOREIGN KEY([EmployeeID])
REFERENCES [dbgroupfive].[employees] ([EmployeeID])
GO
ALTER TABLE [dbgroupfive].[notaries] CHECK CONSTRAINT [notaries$Employee-Notary-Relation]
GO
ALTER TABLE [dbgroupfive].[sales]  WITH NOCHECK ADD  CONSTRAINT [sales$Employee-Sales-Relation] FOREIGN KEY([EmployeeID])
REFERENCES [dbgroupfive].[employees] ([EmployeeID])
GO
ALTER TABLE [dbgroupfive].[sales] CHECK CONSTRAINT [sales$Employee-Sales-Relation]
GO
ALTER TABLE [dbgroupfive].[sales]  WITH NOCHECK ADD  CONSTRAINT [sales$Register-Sales-Relation] FOREIGN KEY([RegisterID])
REFERENCES [dbgroupfive].[registers] ([RegisterID])
GO
ALTER TABLE [dbgroupfive].[sales] CHECK CONSTRAINT [sales$Register-Sales-Relation]
GO
ALTER TABLE [dbgroupfive].[shift_switch]  WITH NOCHECK ADD  CONSTRAINT [shift_switch$Employee-Switch-Relation] FOREIGN KEY([EmployeeID])
REFERENCES [dbgroupfive].[employees] ([EmployeeID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbgroupfive].[shift_switch] CHECK CONSTRAINT [shift_switch$Employee-Switch-Relation]
GO
ALTER TABLE [dbgroupfive].[shifts]  WITH NOCHECK ADD  CONSTRAINT [shifts$Employee-Shift-Relation] FOREIGN KEY([EmployeeID])
REFERENCES [dbgroupfive].[employees] ([EmployeeID])
GO
ALTER TABLE [dbgroupfive].[shifts] CHECK CONSTRAINT [shifts$Employee-Shift-Relation]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'dbgroupfive.employee_vacations' , @level0type=N'SCHEMA',@level0name=N'dbgroupfive', @level1type=N'FUNCTION',@level1name=N'enum2str$employee_vacations$status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'dbgroupfive.shift_switch' , @level0type=N'SCHEMA',@level0name=N'dbgroupfive', @level1type=N'FUNCTION',@level1name=N'enum2str$shift_switch$Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'dbgroupfive.employee_vacations' , @level0type=N'SCHEMA',@level0name=N'dbgroupfive', @level1type=N'FUNCTION',@level1name=N'norm_enum$employee_vacations$status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'dbgroupfive.shift_switch' , @level0type=N'SCHEMA',@level0name=N'dbgroupfive', @level1type=N'FUNCTION',@level1name=N'norm_enum$shift_switch$Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'dbgroupfive.employee_vacations' , @level0type=N'SCHEMA',@level0name=N'dbgroupfive', @level1type=N'FUNCTION',@level1name=N'str2enum$employee_vacations$status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'dbgroupfive.shift_switch' , @level0type=N'SCHEMA',@level0name=N'dbgroupfive', @level1type=N'FUNCTION',@level1name=N'str2enum$shift_switch$Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'dbgroupfive.bonuses' , @level0type=N'SCHEMA',@level0name=N'dbgroupfive', @level1type=N'TABLE',@level1name=N'bonuses'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'dbgroupfive.dailysales' , @level0type=N'SCHEMA',@level0name=N'dbgroupfive', @level1type=N'TABLE',@level1name=N'dailysales'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'dbgroupfive.employee_vacations' , @level0type=N'SCHEMA',@level0name=N'dbgroupfive', @level1type=N'TABLE',@level1name=N'employee_vacations'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'dbgroupfive.employees' , @level0type=N'SCHEMA',@level0name=N'dbgroupfive', @level1type=N'TABLE',@level1name=N'employees'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'dbgroupfive.mailboxes' , @level0type=N'SCHEMA',@level0name=N'dbgroupfive', @level1type=N'TABLE',@level1name=N'mailboxes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'dbgroupfive.notaries' , @level0type=N'SCHEMA',@level0name=N'dbgroupfive', @level1type=N'TABLE',@level1name=N'notaries'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'dbgroupfive.registers' , @level0type=N'SCHEMA',@level0name=N'dbgroupfive', @level1type=N'TABLE',@level1name=N'registers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'dbgroupfive.sales' , @level0type=N'SCHEMA',@level0name=N'dbgroupfive', @level1type=N'TABLE',@level1name=N'sales'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'dbgroupfive.shift_switch' , @level0type=N'SCHEMA',@level0name=N'dbgroupfive', @level1type=N'TABLE',@level1name=N'shift_switch'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'dbgroupfive.shifts' , @level0type=N'SCHEMA',@level0name=N'dbgroupfive', @level1type=N'TABLE',@level1name=N'shifts'
GO
USE [master]
GO
ALTER DATABASE [dbgroup5] SET  READ_WRITE 
GO
