USE Egypt_Car_Accidents ;

CREATE TABLE LOCATION (
	Location_ID INT IDENTITY(1,1) PRIMARY KEY ,
	Governorate NVARCHAR(50) NOT NULL ,
	City NVARCHAR(50) NOT NULL ,
	Street_Name NVARCHAR(50) NOT NULL
) ;

CREATE TABLE ACCIDENTS (
	Accident_ID INT IDENTITY(1,1) PRIMARY KEY ,
	Accident_Date DATE DEFAULT GETDATE() ,
	Accident_Time TIME NOT NULL ,
	Weather_Condition NVARCHAR(50) NOT NULL ,
	Accident_Cause NVARCHAR(50) NOT NULL ,
	Description NVARCHAR(150) ,
	
	Location_ID INT ,
	
	CONSTRAINT A1 FOREIGN KEY (Location_ID) REFERENCES LOCATION (Location_ID)
		ON DELETE NO ACTION ON UPDATE CASCADE ,

	CONSTRAINT A2 CHECK (Accident_Date <= GETDATE()) ,
	CONSTRAINT A3 CHECK (Weather_Condition IN(N'مشمس',N'غائم',N'ممطر',N'ضباب',N'عاصفة',N'رياح شديدة')) ,
	CONSTRAINT A4 CHECK (Accident_Cause IN(N'السرعة الزائدة',N'عدم الالتزام بالإشارات المرورية',N'تجاوز خاطئ',N'الانشغال بالهاتف المحمول',N'القيادة تحت تأثير المخدرات أو الكحول',N'عطل بالمركبة',N'انفجار إطار',N'سوء حالة الطريق',N'سوء الأحوال الجوية',N'السير عكس الاتجاه',N'عدم ترك مسافة أمان',N'سبب آخر')) ,
) ;

CREATE TABLE VEHICLES (
	Plate_Number NVARCHAR (50) PRIMARY KEY ,
	Vehicle_Type NVARCHAR(50) NOT NULL ,
	Model NVARCHAR(50) NOT NULL ,
	Brand NVARCHAR(50) NOT NULL ,
	Color NVARCHAR(50) NOT NULL ,
	Damage_Level NVARCHAR(50) NOT NULL ,

	Accident_ID INT ,

	CONSTRAINT H1 FOREIGN KEY (Accident_ID) REFERENCES ACCIDENTS (Accident_ID)
		ON DELETE CASCADE ON UPDATE CASCADE ,

	CONSTRAINT H2 CHECK (Damage_Level IN(N'صغير',N'متوسط',N'شديد',N'خسارة كاملة'))
	CONSTRAINT H3 CHECK(Vehicle_Type IN(N'ملاكي',N'أجرة',N'ميكروباص',N'أتوبيس',N'نقل',N'موتوسيكل',N'توك توك',N'دراجة هوائية',N'سيارة إسعاف',N'سيارة شرطة',N'أخرى'))
) ;

CREATE TABLE ROAD_USER_TYPE (
	Road_User_ID INT IDENTITY(1,1) PRIMARY KEY ,
	Type_Name NVARCHAR(50) NOT NULL ,

	CONSTRAINT R1 CHECK (Type_Name IN(N'سائق',N'راكب',N'مشاة',N'راكب خارج المركبة'))
) ;

CREATE TABLE VICTIMS (
	National_ID INT PRIMARY KEY ,
	Full_Name NVARCHAR(50) NOT NULL ,
	Age TINYINT NOT NULL ,
	Gender NVARCHAR(50) ,
	Phone_Number NVARCHAR(50) NOT NULL ,
	Status NVARCHAR(50) NOT NULL ,
	
	Road_User_ID INT ,
	Plate_Number NVARCHAR(50) ,

	CONSTRAINT V1 FOREIGN KEY (Road_User_ID) REFERENCES ROAD_USER_TYPE (Road_User_ID)
		ON DELETE NO ACTION ON UPDATE CASCADE ,

	CONSTRAINT V2 FOREIGN KEY (Plate_Number) REFERENCES VEHICLES (Plate_Number)
		ON DELETE SET NULL ON UPDATE CASCADE ,

	CONSTRAINT V3 CHECK (Age BETWEEN 0 AND 120 ) ,
	CONSTRAINT V4 CHECK (Gender IN (N'ذكر',N'أنثي')) ,
	CONSTRAINT V5 CHECK (Status IN (N'مصاب',N'متوفي',N'سليم')) ,
	CONSTRAINT V6 UNIQUE (Phone_Number)
) ;

CREATE TABLE INJURIES (
	Injury_ID INT IDENTITY(1,1) PRIMARY KEY ,
	Injury_Type NVARCHAR(50) ,
	Affected_Body_Part NVARCHAR(50) ,
	Severity_Level NVARCHAR(50) ,
	Hospital_Name NVARCHAR(50) ,
	
	National_ID INT ,
	
	CONSTRAINT I1 FOREIGN KEY (National_ID) REFERENCES VICTIMS (National_ID)
		ON DELETE CASCADE ON UPDATE CASCADE ,

	CONSTRAINT I2 CHECK (Severity_Level IN (N'صغير',N'متوسط',N'شديد',N'حرج')) ,
) ;

CREATE TABLE DEATHS (
	Death_ID INT IDENTITY(1,1) PRIMARY KEY ,
	Death_Date DATE DEFAULT GETDATE() ,
	Death_Time TIME ,
	Death_Place NVARCHAR(50) ,
	Cause_Of_Death NVARCHAR(50) ,

	National_ID INT ,

	CONSTRAINT D1 FOREIGN KEY (National_ID) REFERENCES VICTIMS (National_ID)
		ON DELETE CASCADE ON UPDATE CASCADE ,
) ;

CREATE TABLE USERS(
    User_ID INT IDENTITY(1,1) PRIMARY KEY,
    Full_Name NVARCHAR(100) NOT NULL,
    User_Name NVARCHAR(50) NOT NULL,
    Password NVARCHAR(255) NOT NULL,
    Role NVARCHAR(30) NOT NULL,

    CONSTRAINT U1 UNIQUE (User_Name),

    CONSTRAINT U2 CHECK (Role IN (N'مدير النظام', N'موظف إدخال بيانات', N'مشاهد'))
) ;

CREATE SCHEMA CORE ;
CREATE SCHEMA REFERENCE ;
CREATE SCHEMA MEDICAL ;
CREATE SCHEMA USERS ;

ALTER SCHEMA CORE TRANSFER ACCIDENTS ;
ALTER SCHEMA CORE TRANSFER VEHICLES ;
ALTER SCHEMA CORE TRANSFER VICTIMS ;

ALTER SCHEMA REFERENCE TRANSFER LOCATION ;
ALTER SCHEMA REFERENCE TRANSFER ROAD_USER_TYPE ;

ALTER SCHEMA MEDICAL TRANSFER INJURIES ;
ALTER SCHEMA MEDICAL TRANSFER DEATHS ;

ALTER SCHEMA USERS TRANSFER USERS ;
