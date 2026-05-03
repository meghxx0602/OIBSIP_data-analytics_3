/*
Internship Project 3 - Level 2 Data Analytics
Idea: Unveiling the Android App Market: Analyzing Google Play Store Data

Section: Database & Apps Table Schema
Purpose:
- Initialize google_play_store database and create apps table with import-friendly schema
- Clean invalid values in Last_Updated, Rating, and Price columns
- Apply datatype conversion pipeline for evaluator-ready structure
Outcome:
- Cleaned apps table with proper datatypes
- Ready for foreign key mapping to user_reviews and subsequent EDA queries
*/

-- 1.Database Reset & Creation
DROP DATABASE IF EXISTS google_play_store;
CREATE database google_play_store;
USE google_play_store;

-- 2. Initial Table Creation (Import - friendly schema)
CREATE TABLE apps (
    App_ID INT AUTO_INCREMENT PRIMARY KEY,  
    App VARCHAR(255) NOT NULL,
    Category VARCHAR(100),
    Rating varchar(20),
    Reviews VARCHAR(20),
    Size VARCHAR(50),  
    Installs VARCHAR(50), 
    Type VARCHAR(10), 
    Price VARCHAR(10),
    Content_Rating VARCHAR(50),
    Genres VARCHAR(100),
    Last_Updated VARCHAR(20),
    Current_Ver VARCHAR(50),
    Android_Ver VARCHAR(50)
);

-- 3. Cleaning Last_Updated Column
SET SQL_SAFE_UPDATES = 0;
-- Convert Last_Updated from '7-Jan-18' style into DATE
UPDATE apps
SET Last_Updated = STR_TO_DATE(Last_Updated, '%d-%b-%y')
WHERE Last_Updated IS NOT NULL;
SET SQL_SAFE_UPDATES = 1;

-- 4. Cleaning Rating Column
SET SQL_SAFE_UPDATES = 0;
-- Replace invalid Rating values with NULL
UPDATE apps
SET Rating = NULL
WHERE Rating IN ('NaN','nan','NULL','');
SET SQL_SAFE_UPDATES = 1;
SET SQL_SAFE_UPDATES = 0;
UPDATE apps
SET Rating = 0
WHERE Rating IS NULL;

-- 5. Cleaning Price Column
-- Remove $ symbol and convert 'Free'/'NaN' to 0.00 or NULL
UPDATE apps
SET Price = REPLACE(Price, '$', '');
UPDATE apps
SET Price = '0.00'
WHERE Price IN ('Free','free','NaN','nan','');

-- 6. Final Schema Update (Evaluator - friendly datatypes)
ALTER TABLE apps
MODIFY App VARCHAR(255) NOT NULL,
MODIFY Category VARCHAR(100),
MODIFY Rating FLOAT,
MODIFY Reviews INT,
MODIFY Size VARCHAR(50),
MODIFY Installs VARCHAR(50),
MODIFY Type ENUM('Free','Paid'),
MODIFY Price DECIMAL(10,2),
MODIFY Content_Rating VARCHAR(50),
MODIFY Genres VARCHAR(100),
MODIFY Last_Updated DATE,
MODIFY Current_Ver VARCHAR(50),
MODIFY Android_Ver VARCHAR(50);

SELECT * FROM apps;