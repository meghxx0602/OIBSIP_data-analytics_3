/*
Internship Project 3 - Level 2 Data Analytics
Idea: Unveiling the Android App Market: Analyzing Google Play Store Data

Section: Apps Table Import
Purpose:
- Import raw apps.csv dataset into the apps table
- Ensure schema alignment with columns (App, Category, Rating, Reviews, Size, Installs, Type, Price, Content_Rating, Genres, Last_Updated, Current_Ver, Android_Ver)
- Handle quoted fields and Windows-style line terminators (\r\n)
- Skip header row to avoid mismatch
Outcome:
- Apps metadata successfully loaded into the apps table
- Dataset ready for cleaning, datatype conversion, and market analysis
*/

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/apps.csv'
INTO TABLE apps
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(App, Category, Rating, Reviews, Size, Installs, Type, Price, Content_Rating, Genres, Last_Updated, Current_Ver, Android_Ver);

SELECT * FROM apps;