/*
Internship Project 3 - Level 2 Data Analytics
Idea: Unveiling the Android App Market: Analyzing Google Play Store Data

Section: User Reviews Table Import
Purpose:
- Import user_reviews.txt dataset into the user_reviews table
- Handle tab-delimited fields and Windows-style line terminators (\r\n)
- Skip header row during import to avoid mismatch
- Identify and inspect NULL or missing values across columns
- Impute missing Sentiment_Subjectivity values with default 0.0
Outcome:
- Cleaned user_reviews table with consistent values
- Ready for datatype conversion and relational mapping to apps table
*/

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/user_reviews.txt'
IGNORE
INTO TABLE user_reviews
FIELDS TERMINATED BY '\t'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
(App, Translated_Review, Sentiment, Sentiment_Polarity, Sentiment_Subjectivity);

SHOW WARNINGS;

SELECT * 
FROM user_reviews
WHERE App IS NULL 
   OR Translated_Review IS NULL 
   OR Sentiment IS NULL 
   OR Sentiment_Polarity IS NULL 
   OR Sentiment_Subjectivity IS NULL;
   
SET SQL_SAFE_UPDATES = 0;

UPDATE user_reviews
SET Sentiment_Subjectivity = 0.0
WHERE Sentiment_Subjectivity IS NULL;

SET SQL_SAFE_UPDATES = 1;