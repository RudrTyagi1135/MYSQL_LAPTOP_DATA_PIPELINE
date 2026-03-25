# 🧹 Laptop Data Cleaning, EDA & Feature Engineering (MySQL)

A **SQL-based data preprocessing and analytics pipeline** built using **MySQL Workbench**, designed to clean raw laptop data, perform exploratory analysis, and engineer features for machine learning readiness.

This project demonstrates how **relational databases can be used for end-to-end data processing**, not just storage.

---

## 🚀 Project Overview

This system implements a **complete data pipeline in SQL**, covering:

- Data cleaning and standardization  
- Exploratory Data Analysis (EDA)  
- Missing value handling  
- Feature engineering  
- Preparation for machine learning  

The goal is to convert raw, inconsistent data into a **structured, analysis-ready dataset** using production-style SQL workflows.

---

## ⚙️ Architecture Overview

```
Raw Dataset (Excel)
        │
        ▼
MySQL Table (laptops)
        │
        ▼
Data Cleaning (01_data_cleaning.sql)
        │
        ▼
EDA + Feature Engineering (02_eda_feature_engineering.sql)
        │
        ▼
Structured ML-Ready Dataset
```

### Design Principles

- SQL-first data processing pipeline  
- Separation of cleaning and analysis logic  
- Reproducible transformation steps  
- Database-driven feature engineering  

---

## 📂 Project Structure

```
MYSQL_LAPTOP_DATA_PIPELINE/
│
├── data/
│   └── laptops.xlsx
│
├── sql/
│   ├── 01_data_cleaning.sql
│   └── 02_eda_feature_engineering.sql
│
├── README.md
```

---

## 🚀 Features

- 🧹 **End-to-end SQL data cleaning pipeline**
- 📊 **Exploratory Data Analysis using SQL queries**
- 🧠 **Feature engineering directly inside database**
- ⚙️ **Data type standardization and normalization**
- 📉 **Outlier detection using IQR method**
- 🔄 **Missing value imputation using group statistics**
- 🤖 **ML-ready dataset preparation**

---

## 🧠 What This Project Demonstrates

This project highlights:

- **SQL-based ETL pipeline design**
- **Data cleaning in relational systems**
- **Statistical analysis using SQL**
- **Feature engineering inside databases**
- **Handling real-world messy datasets**
- **Preparation of structured data for ML pipelines**

---

## 🔌 Pipeline Workflow

### Step 1: Data Ingestion
- Import Excel dataset into MySQL table `laptops`

---

### Step 2: Data Cleaning

Performed using:

📄 [`01_data_cleaning.sql`](./sql/01_data_cleaning.sql)

Key operations:

- Database and backup table creation  
- Null value removal  
- Duplicate elimination using `DISTINCT`  
- Column cleanup and renaming  

#### Data Type Standardization

- **RAM**
  - Removed "GB"
  - Converted to INTEGER  

- **Weight**
  - Removed "kg"
  - Trimmed whitespace  
  - Handled empty values  

- **Price**
  - Rounded values  
  - Converted to INTEGER  

#### Feature Simplification

- OS normalization (e.g., Windows variants → Windows)  
- GPU brand extraction  
- CPU simplified to core identifier  

---

### Step 3: Exploratory Data Analysis (EDA)

Performed using:

📄 [`02_eda_feature_engineering.sql`](./sql/02_eda_feature_engineering.sql)

Includes:

#### Data Inspection
- Head, tail, random sampling  

#### Statistical Summary
- Count, min, max, mean  
- Standard deviation  
- Quartiles (Q1, Median, Q3)  

#### Outlier Detection
- IQR-based detection for price anomalies  

#### Distribution Analysis
- Histogram-style bucketing in SQL  

#### Bivariate Analysis
- Price trends across companies  

#### Cross Tabulation
- Touchscreen usage by brand  
- CPU distribution per company  

---

### Step 4: Missing Value Handling

- Imputed missing values using:
  - **Average price per company**

---

### Step 5: Feature Engineering

#### PPI (Pixels Per Inch)
- Derived from resolution and screen size  

#### Screen Size Categories
- Small (<14)  
- Medium (14–17)  
- Large (>17)  

---

### Step 6: Machine Learning Preparation

- Created binary encoding for GPU brands:
  - Intel  
  - AMD  
  - Nvidia  
  - ARM  

Result: **Fully ML-compatible dataset**

---

## 📊 Outcome

- Clean and consistent dataset  
- Reduced noise and redundancy  
- Statistical understanding of features  
- Engineered features for ML  
- Structured dataset ready for modeling  

---

## 🛠️ Installation & Setup

### 1. Clone Repository

```bash
git clone https://github.com/your-username/laptop-data-cleaning-mysql.git
cd laptop-data-cleaning-mysql
```

---

### 2. Import Dataset

- Open **MySQL Workbench**
- Import `laptopData.xlsx` into table named:

```
laptops
```

---

## ▶️ Running the Pipeline

Execute queries in order:

```sql
sql/01_data_cleaning.sql
```

```sql
sql/02_eda_feature_engineering.sql
```

---

## ⚠️ Important Notes

- Ensure dataset is correctly imported into MySQL  
- Column names must match expected schema  
- Run scripts sequentially (cleaning → analysis)  

---

## 🧰 Tech Stack

| Technology        | Purpose                          |
|------------------|----------------------------------|
| MySQL            | Data storage & processing        |
| MySQL Workbench  | Query execution environment      |
| SQL              | Data cleaning, EDA, feature engineering |

---

## 📈 Potential Improvements

- Add indexing for query optimization  
- Convert pipeline into stored procedures  
- Integrate with Python (Pandas + SQL)  
- Build automated ETL workflows  
- Connect with AWS (RDS + S3)  
- Feed output into ML models  

---

## 🎯 Learning Outcomes

- Building SQL-based data pipelines  
- Performing EDA inside databases  
- Handling missing and inconsistent data  
- Feature engineering using SQL  
- Preparing structured datasets for ML systems  

---

## 👤 Author

**Rudra Tyagi**

B.Tech Final Year Student  
ML Systems | MLOps | AI Infrastructure