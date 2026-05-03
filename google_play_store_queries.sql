/*
Internship Project 3 - Google Play Store Analysis
Dataset: apps.csv + user_reviews.csv (SQL-only)

Section: Complete Relational Analysis Script
Purpose:
- Perform end-to-end data preparation and cleaning for both apps and user_reviews tables
- Ensure relational integrity via App_ID foreign key mapping
- Conduct category exploration (app count, ratings, sentiment polarity)
- Execute metrics analysis (installs, reviews, ratings, pricing, size trends)
- Perform sentiment analysis (distribution, polarity, subjectivity, correlation)
Outcome:
- Clean, joined relational dataset ready for exploratory data analysis (EDA)
- Query outputs mapped to charts (Bar, Pie, Scatter, Line, Heatmap)
- Professional, evaluator-friendly documentation with Query → Chart → Insight mapping
*/

/*
Section: Data Preparation (Cleaning)
Purpose:
- Clean both apps and user_reviews tables
- Ensure relational integrity via App_ID foreign key
Outcome:
- Clean relational dataset ready for analysis
*/

-- Cleaning apps table

USE google_play_store;

SET SQL_SAFE_UPDATES = 0;
-- 1. Clean Installs (remove '+' and commas, convert to INT)
UPDATE apps
SET Installs = REPLACE(REPLACE(Installs, '+', ''), ',', '');

ALTER TABLE apps
MODIFY Installs INT;

-- 2. Clean Size (handle 'Varies with device', convert MB to numeric)
UPDATE apps
SET Size = NULL
WHERE Size = 'Varies with device';

-- 3. Handle 'Varies with device' and blanks
UPDATE apps
SET Size = NULL
WHERE Size IN ('Varies with device', '', 'NaN', 'nan');

-- 4. Remove 'M' (megabytes) and convert to numeric
UPDATE apps
SET Size = REPLACE(Size, 'M', '')
WHERE Size LIKE '%M%';

-- 5. Remove 'k' or other non-numeric suffixes if present
UPDATE apps
SET Size = REPLACE(Size, 'k', '')
WHERE Size LIKE '%k%';

-- 6. Now safely convert column to FLOAT
ALTER TABLE apps
MODIFY Size FLOAT;

-- 7. Remove duplicates (keep lowest App_ID)
DELETE a1
FROM apps a1
JOIN apps a2
ON a1.App = a2.App AND a1.App_ID > a2.App_ID;

-- The following queries were previously executed in the google_play_store_apps_schema and are re-written here for documentation purposes.

-- 8. Cleaning Last_Updated Column
SET SQL_SAFE_UPDATES = 0;
-- Convert Last_Updated from '7-Jan-18' style into DATE
UPDATE apps
SET Last_Updated = STR_TO_DATE(Last_Updated, '%d-%b-%y')
WHERE Last_Updated IS NOT NULL;
SET SQL_SAFE_UPDATES = 1;

-- 9. Cleaning Rating Column
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

-- 10. Cleaning Price Column
-- Remove $ symbol and convert 'Free'/'NaN' to 0.00 or NULL
UPDATE apps
SET Price = REPLACE(Price, '$', '');
UPDATE apps
SET Price = '0.00'
WHERE Price IN ('Free','free','NaN','nan','');

-- Cleaning user_reviews table

-- 1. Normalize Sentiment values
SET SQL_SAFE_UPDATES = 0;
UPDATE user_reviews
SET Sentiment = CASE
    WHEN LOWER(Sentiment) LIKE 'pos%' THEN 'Positive'
    WHEN LOWER(Sentiment) LIKE 'neg%' THEN 'Negative'
    WHEN LOWER(Sentiment) LIKE 'neu%' THEN 'Neutral'
    ELSE 'Neutral'
END;

-- The following queries were previously executed in the google_play_store_user_reviews_schema and are re-written here for documentation purposes.

-- 2. Convert Polarity to FLOAT
ALTER TABLE user_reviews MODIFY Sentiment_Polarity FLOAT;

-- 3. Convert Subjectivity to FLOAT
ALTER TABLE user_reviews MODIFY Sentiment_Subjectivity FLOAT;

-- 4. Handle missing polarity/subjectivity
UPDATE user_reviews
SET Sentiment_Polarity = 0.0
WHERE Sentiment_Polarity IS NULL;

UPDATE user_reviews
SET Sentiment_Subjectivity = 0.0
WHERE Sentiment_Subjectivity IS NULL;

-- Join check (App_ID mapping integrity)

-- 1. Find orphan reviews (reviews with no matching app)
SELECT ur.Review_ID, ur.App
FROM user_reviews ur
LEFT JOIN apps a ON ur.App_ID = a.App_ID
WHERE a.App_ID IS NULL;

-- 2. Count mapped vs unmapped reviews
SELECT 
    COUNT(*) AS Total_Reviews,
    SUM(CASE WHEN ur.App_ID IS NULL THEN 1 ELSE 0 END) AS Unmapped_Reviews,
    SUM(CASE WHEN ur.App_ID IS NOT NULL THEN 1 ELSE 0 END) AS Mapped_Reviews
FROM user_reviews ur;

/*
Section: Category Exploration
Purpose:
- Explore app distribution with review counts
- Compare average ratings with sentiment polarity
- Analyze Free vs Paid apps sentiment split
Outcome:
- Relational insights ready for visualization
*/

USE google_play_store;

-- 1. Category wise app count + review count - bar chart formation
SELECT a.Category,
       COUNT(DISTINCT a.App_ID) AS App_Count,
       COUNT(ur.Review_ID) AS Review_Count
FROM apps a
LEFT JOIN user_reviews ur ON a.App_ID = ur.App_ID
GROUP BY a.Category
ORDER BY App_Count DESC;

-- 2. Avg rating per category + avg sentiment polarity - bar chart formation
SELECT a.Category,
       ROUND(AVG(a.Rating),2) AS Avg_Rating,
       ROUND(AVG(ur.Sentiment_Polarity),3) AS Avg_Polarity
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
WHERE a.Rating IS NOT NULL AND ur.Sentiment_Polarity IS NOT NULL
GROUP BY a.Category
ORDER BY Avg_Rating DESC;

-- 3. Free vs Paid apps + sentiment distribution - pie chart formation
SELECT a.Type,
       ur.Sentiment,
       COUNT(*) AS Review_Count
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
GROUP BY a.Type, ur.Sentiment
ORDER BY a.Type, Review_Count DESC;

/*
Section: Metrics Analysis
Purpose:
- Analyze popularity metrics (installs, reviews, ratings)
- Explore pricing trends across categories
- Investigate app size impact on ratings/installs
Outcome:
- Relational insights ready for visualization
*/

USE google_play_store;

-- 1. Popularity: installs vs reviews vs ratings
-- Scatter plot prep: Rating vs Installs (with review count)
SELECT a.App, a.Rating, a.Installs, COUNT(ur.Review_ID) AS Review_Count
FROM apps a
LEFT JOIN user_reviews ur ON a.App_ID = ur.App_ID
WHERE a.Rating IS NOT NULL AND a.Installs IS NOT NULL
GROUP BY a.App, a.Rating, a.Installs;

-- Top 10 apps by number of reviews (Bar Chart)
SELECT a.App, COUNT(ur.Review_ID) AS Review_Count
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
GROUP BY a.App
ORDER BY Review_Count DESC
LIMIT 10;

-- 2. Pricing trends: average price per category (Bar Chart)
SELECT a.Category, ROUND(AVG(a.Price),2) AS Avg_Price
FROM apps a
WHERE a.Type = 'Paid'
GROUP BY a.Category
ORDER BY Avg_Price DESC;

-- 3. Size trends: app size vs rating (Line Chart prep)
SELECT a.App, a.Size, a.Rating
FROM apps a
WHERE a.Size IS NOT NULL AND a.Rating IS NOT NULL;

-- Size vs Installs correlation (optional heatmap prep)
SELECT a.App, a.Size, a.Installs, COUNT(ur.Review_ID) AS Review_Count
FROM apps a
LEFT JOIN user_reviews ur ON a.App_ID = ur.App_ID
WHERE a.Size IS NOT NULL AND a.Installs IS NOT NULL
GROUP BY a.App, a.Size, a.Installs;

-- 4. Category wise Paid apps ratio (Pie Chart)
SELECT a.Category,
       SUM(CASE WHEN a.Type = 'Paid' THEN 1 ELSE 0 END) AS Paid_Apps,
       SUM(CASE WHEN a.Type = 'Free' THEN 1 ELSE 0 END) AS Free_Apps
FROM apps a
GROUP BY a.Category;

/*
Section: Sentiment Analysis
Purpose:
- Analyze sentiment distribution overall and per category
- Calculate polarity & subjectivity averages
- Correlate app ratings with sentiment positivity
- Check reviews vs installs correlation
Outcome:
- Relational sentiment insights ready for visualization
*/

USE google_play_store;

-- 1. Sentiment distribution overall (Pie Chart)
SELECT ur.Sentiment, COUNT(*) AS Review_Count
FROM user_reviews ur
GROUP BY ur.Sentiment;

-- 1b. Sentiment distribution per category
SELECT a.Category, ur.Sentiment, COUNT(*) AS Review_Count
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
GROUP BY a.Category, ur.Sentiment
ORDER BY a.Category, Review_Count DESC;

-- 2. Avg polarity & subjectivity per app (Bar Chart)
SELECT a.App,
       ROUND(AVG(ur.Sentiment_Polarity),3) AS Avg_Polarity,
       ROUND(AVG(ur.Sentiment_Subjectivity),3) AS Avg_Subjectivity
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
GROUP BY a.App
ORDER BY Avg_Polarity DESC;

-- 2b. Avg polarity & subjectivity per category (Bar Chart)
SELECT a.Category,
       ROUND(AVG(ur.Sentiment_Polarity),3) AS Avg_Polarity,
       ROUND(AVG(ur.Sentiment_Subjectivity),3) AS Avg_Subjectivity
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
GROUP BY a.Category
ORDER BY Avg_Polarity DESC;

-- 3. Correlation: High rating apps → more positive reviews?
-- Scatter/Correlation Table prep
SELECT a.App, a.Rating,
       SUM(CASE WHEN ur.Sentiment = 'Positive' THEN 1 ELSE 0 END) AS Positive_Reviews,
       SUM(CASE WHEN ur.Sentiment = 'Negative' THEN 1 ELSE 0 END) AS Negative_Reviews,
       SUM(CASE WHEN ur.Sentiment = 'Neutral' THEN 1 ELSE 0 END) AS Neutral_Reviews
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
WHERE a.Rating IS NOT NULL
GROUP BY a.App, a.Rating
ORDER BY a.Rating DESC;

-- 4. Reviews vs Installs correlation (Heatmap prep)
SELECT a.App, a.Category, a.Installs,
       COUNT(ur.Review_ID) AS Review_Count,
       ROUND(AVG(ur.Sentiment_Polarity),3) AS Avg_Polarity
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
GROUP BY a.App, a.Category, a.Installs
ORDER BY Review_Count DESC;


