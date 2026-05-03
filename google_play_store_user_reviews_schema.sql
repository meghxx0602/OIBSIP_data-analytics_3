/*
Internship Project 3 - Level 2 Data Analytics
Idea: Unveiling the Android App Market: Analyzing Google Play Store Data

Section: User Reviews Table Schema & Cleaning
Purpose:
- Initialize user_reviews table with import-friendly schema
- Clean invalid or non-numeric values in Sentiment_Polarity and Sentiment_Subjectivity
- Convert datatypes to evaluator-ready structure (FLOAT for numeric fields)
Outcome:
- Stable and cleaned user_reviews table schema
- Ready for relational mapping to apps table and subsequent analysis
*/

USE google_play_store;

-- 1. Drop and recreate table (import-friendly schema)
DROP TABLE user_reviews;
CREATE TABLE user_reviews (
    Review_ID INT AUTO_INCREMENT PRIMARY KEY,
    App VARCHAR(255) NOT NULL,
    Translated_Review TEXT,
    Sentiment VARCHAR(20),
    Sentiment_Polarity VARCHAR(50),       -- keep VARCHAR for import
    Sentiment_Subjectivity VARCHAR(50)    -- keep VARCHAR for import
);

-- 2. Clean invalid values in Sentiment_Polarity
UPDATE user_reviews
SET Sentiment_Polarity = NULL
WHERE Sentiment_Polarity = '';

-- 3. Clean invalid values in Sentiment_Subjectivity
UPDATE user_reviews
SET Sentiment_Subjectivity = NULL
WHERE Sentiment_Subjectivity = '';

-- 4. Force non-numeric values to NULL
UPDATE user_reviews
SET Sentiment_Polarity = NULL
WHERE Sentiment_Polarity REGEXP '^[0-9.-]+$' = 0;

UPDATE user_reviews
SET Sentiment_Subjectivity = NULL
WHERE Sentiment_Subjectivity REGEXP '^[0-9.-]+$' = 0;

-- 5. Final Schema Update (Evaluator - friendly datatypes)
ALTER TABLE user_reviews 
MODIFY Translated_Review TEXT,
MODIFY Sentiment VARCHAR(20),
MODIFY Sentiment_Polarity FLOAT,
MODIFY Sentiment_Subjectivity FLOAT;

SELECT * FROM user_reviews;
