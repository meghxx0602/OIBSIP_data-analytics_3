# 📱 Unveiling the Android App Market: Google Play Store Analysis

**OIBSIP Internship – Level 2 Data Analytics | Project 3**

A complete **SQL-only** exploratory data analysis (EDA) of the Google Play Store, covering app metadata and user reviews. The project performs end-to-end data cleaning, relational mapping, category exploration, metrics analysis, and sentiment analysis — all within MySQL — with results documented in professional EDA and visualization reports.

---

## 📑 Table of Contents

- [Project Overview](#project-overview)
- [Repository Structure](#repository-structure)
- [Datasets](#datasets)
- [Database Schema](#database-schema)
- [SQL Workflow](#sql-workflow)
- [Analysis Sections](#analysis-sections)
- [EDA Visualizations](#eda-visualizations)
- [Setup & Usage](#setup--usage)
- [Tools Used](#tools-used)

---

## Project Overview

| Item | Detail |
|---|---|
| **Goal** | Analyze the Android app ecosystem using Google Play Store data |
| **Approach** | Pure SQL (MySQL 8.0) — no Python or BI tools |
| **Datasets** | `apps.csv` (app metadata) + `user_reviews.csv` (user feedback) |
| **Outcome** | Clean relational dataset, query-driven insights, and professional EDA reports |

Key questions answered:
- Which categories dominate the Play Store?
- How do ratings, installs, and reviews correlate?
- What are the pricing trends across categories?
- How does app size affect ratings?
- What is the overall and per-category sentiment of user reviews?
- Do highly-rated apps receive more positive reviews?

---

## Repository Structure

```
OIBSIP_data-analytics_3/
│
├── google_play_store_apps_schema.sql          # Creates & cleans the apps table
├── google_play_store_user_reviews_schema.sql  # Creates & cleans the user_reviews table
├── googleplaystore_apps_import.sql            # LOAD DATA for apps.csv
├── google_play_store_user_reviews_import.sql  # LOAD DATA for user_reviews dataset
├── google_play_store_debugtoaddfk.sql         # Debug script to add App_ID foreign key
├── google_play_store_queries.sql              # Main EDA queries (all 4 analysis sections)
│
├── google_play_store_unprocessed_dataset/
│   ├── google_play_store_apps_unprocessed_dataset.csv
│   └── google_play_store_user_reviews_unprocessed_dataset.csv
│
├── google_play_store_processed_dataset/
│   ├── google_play_store_processed_apps_dataset.csv
│   └── google_play_store_processed_user_reviews_dataset.csv
│
└── EDA_Visualization_Reports/
    ├── Google_play_store_eda_report.docx
    ├── Google_play_store_visualization_report.docx
    ├── heatmap.pdf
    ├── Avg Polarity & Subjectivity per Category.jpeg
    ├── Avg Rating per Category + Avg Sentiment Polarity.jpeg
    ├── Category Wise App Count + Review Count .jpeg
    ├── Category Wise Paid Apps Ratio.jpeg
    ├── Free vs Paid Apps + Sentiment Distribution.jpeg
    ├── Overall Sentiment Distribution.jpeg
    ├── Pricing Trends Average Price per Category.jpeg
    ├── Rating vs Installs .jpeg
    ├── Size Trends App Size vs Rating.jpeg
    └── Top 10 Apps by Number of Reviews .jpeg
```

---

## Datasets

### Apps Dataset (`apps.csv`)
Contains metadata for thousands of Android apps scraped from the Google Play Store.

| Column | Description |
|---|---|
| `App` | App name |
| `Category` | App category (e.g., GAME, TOOLS, SOCIAL) |
| `Rating` | Average user rating (1–5) |
| `Reviews` | Number of user reviews |
| `Size` | App size (MB) |
| `Installs` | Number of installs |
| `Type` | Free or Paid |
| `Price` | App price in USD |
| `Content_Rating` | Target audience (e.g., Everyone, Teen) |
| `Genres` | App genre(s) |
| `Last_Updated` | Date of last update |
| `Current_Ver` | Current app version |
| `Android_Ver` | Minimum Android version required |

### User Reviews Dataset (`user_reviews.csv`)
Contains pre-processed user review text with sentiment labels.

| Column | Description |
|---|---|
| `App` | App name |
| `Translated_Review` | English-translated review text |
| `Sentiment` | Positive / Negative / Neutral |
| `Sentiment_Polarity` | Polarity score (−1.0 to 1.0) |
| `Sentiment_Subjectivity` | Subjectivity score (0.0 to 1.0) |

---

## Database Schema

The MySQL database `google_play_store` contains two relational tables joined via `App_ID`:

```sql
apps (
    App_ID INT AUTO_INCREMENT PRIMARY KEY,
    App VARCHAR(255),
    Category VARCHAR(100),
    Rating FLOAT,
    Reviews INT,
    Size FLOAT,
    Installs INT,
    Type ENUM('Free','Paid'),
    Price DECIMAL(10,2),
    Content_Rating VARCHAR(50),
    Genres VARCHAR(100),
    Last_Updated DATE,
    Current_Ver VARCHAR(50),
    Android_Ver VARCHAR(50)
)

user_reviews (
    Review_ID INT AUTO_INCREMENT PRIMARY KEY,
    App VARCHAR(255),
    Translated_Review TEXT,
    Sentiment VARCHAR(20),
    Sentiment_Polarity FLOAT,
    Sentiment_Subjectivity FLOAT,
    App_ID INT  -- foreign key → apps.App_ID
)
```

---

## SQL Workflow

Execute the SQL files in the following order:

| Step | File | Purpose |
|---|---|---|
| 1 | `google_play_store_apps_schema.sql` | Create database, create `apps` table, clean and convert datatypes |
| 2 | `googleplaystore_apps_import.sql` | Import `apps.csv` into the `apps` table |
| 3 | `google_play_store_user_reviews_schema.sql` | Create `user_reviews` table, clean and convert datatypes |
| 4 | `google_play_store_user_reviews_import.sql` | Import user reviews dataset into `user_reviews` table |
| 5 | `google_play_store_debugtoaddfk.sql` | Add `App_ID` foreign key to `user_reviews` for relational mapping |
| 6 | `google_play_store_queries.sql` | Run all EDA queries (cleaning + exploration + metrics + sentiment) |

> **Note:** Update the `LOAD DATA INFILE` paths in the import scripts to match your local MySQL upload directory before running.

---

## Analysis Sections

### 1. Data Preparation & Cleaning
- Strips `+` and `,` from `Installs` and converts to `INT`
- Resolves `"Varies with device"` and `NaN` values in `Size`, converts to `FLOAT`
- Removes duplicate apps (keeps lowest `App_ID`)
- Parses `Last_Updated` strings into `DATE` format
- Nullifies invalid `Rating` values and defaults to `0`
- Strips `$` from `Price`, converts `"Free"` → `0.00`
- Normalizes `Sentiment` labels to `Positive`, `Negative`, `Neutral`
- Validates relational integrity (orphan review check)

### 2. Category Exploration
- Category-wise app count and review count
- Average rating per category vs. average sentiment polarity
- Free vs. Paid app split with sentiment distribution

### 3. Metrics Analysis
- Rating vs. Installs scatter plot data
- Top 10 apps by number of reviews
- Average price per category (paid apps only)
- App size vs. rating trend
- Category-wise paid app ratio

### 4. Sentiment Analysis
- Overall sentiment distribution (Positive / Negative / Neutral)
- Per-category sentiment breakdown
- Average polarity & subjectivity per app and per category
- Correlation: high-rated apps → more positive reviews?
- Reviews vs. Installs correlation (heatmap prep)

---

## EDA Visualizations

All charts are saved in `EDA_Visualization_Reports/` and documented in the Word reports.

| Chart | Type | Insight |
|---|---|---|
| Category Wise App Count + Review Count | Bar | Identifies the most active categories |
| Avg Rating per Category + Avg Sentiment Polarity | Bar | Compares objective ratings with subjective sentiment |
| Free vs Paid Apps + Sentiment Distribution | Pie | Shows the sentiment split across app types |
| Overall Sentiment Distribution | Pie | Broad user sentiment across all apps |
| Pricing Trends Average Price per Category | Bar | Highlights premium-priced app categories |
| Rating vs Installs | Scatter | Explores popularity vs. quality correlation |
| Size Trends App Size vs Rating | Line | Impact of app size on user ratings |
| Top 10 Apps by Number of Reviews | Bar | Most-reviewed apps on the Play Store |
| Avg Polarity & Subjectivity per Category | Bar | Category-level sentiment characteristics |
| Category Wise Paid Apps Ratio | Pie | Monetization strategy by category |
| Heatmap (Reviews vs Installs) | Heatmap (PDF) | Correlation matrix of key numeric metrics |

---

## Setup & Usage

### Prerequisites
- MySQL Server 8.0+
- MySQL Workbench (recommended) or any MySQL client

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/meghxx0602/OIBSIP_data-analytics_3.git
   cd OIBSIP_data-analytics_3
   ```

2. **Place the CSV files** in your MySQL secure upload directory  
   (default: `C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/` on Windows)

3. **Run the SQL files** in order (see [SQL Workflow](#sql-workflow) above)

4. **Explore the results** using the EDA queries in `google_play_store_queries.sql`

5. **Review the reports** in the `EDA_Visualization_Reports/` folder

---

## Tools Used

| Tool | Purpose |
|---|---|
| **MySQL 8.0** | Database creation, data cleaning, EDA queries |
| **MySQL Workbench** | SQL execution and schema management |
| **Microsoft Word** | EDA and visualization reports |
| **Excel / Charting** | Visualization of query outputs |

---

*Internship: Oasis Infobyte | Level 2 Data Analytics | Project 3*
