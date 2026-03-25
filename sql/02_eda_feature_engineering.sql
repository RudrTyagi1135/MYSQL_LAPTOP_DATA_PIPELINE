-- 1. DATABASE CONTEXT
USE laptops;

-- 2. DATA INSPECTION: View Head, Tail, and Random Samples
-- View first 5 rows (Head)
SELECT * FROM laptops ORDER BY `id` LIMIT 5;

-- View last 5 rows (Tail)
SELECT * FROM laptops ORDER BY `id` DESC LIMIT 5;

-- View 5 random rows (Sample)
SELECT * FROM laptops ORDER BY rand() LIMIT 5;

-- 3. UNIVARIATE ANALYSIS: Descriptive Statistics for Price
-- Using Window Functions to get a statistical summary in a single row
SELECT 
    COUNT(Price) OVER() AS total_count,
    MIN(Price) OVER() AS min_price,
    MAX(Price) OVER() AS max_price,
    AVG(Price) OVER() AS avg_price,
    STD(Price) OVER() AS std_dev,
    -- Quartiles for box-plot analysis
    PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q1',
    PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY Price) OVER() AS 'Median',
    PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q3'
FROM laptops
LIMIT 1;

-- 4. OUTLIER DETECTION
-- Identifies rows where Price is outside 1.5 * Interquartile Range (IQR)
SELECT * FROM (
    SELECT *,
    PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q1',
    PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q3'
    FROM laptops
) t
WHERE t.Price < t.Q1 - (1.5 * (t.Q3 - t.Q1)) 
   OR t.Price > t.Q3 + (1.5 * (t.Q3 - t.Q1));

-- 5. DATA DISTRIBUTION: Price Buckets (Histogram Representation)
-- Creates a text-based bar chart using REPEAT() to visualize density
SELECT t.buckets, REPEAT('*', COUNT(*) / 5) AS distribution_bar
FROM (
    SELECT 
        CASE 
            WHEN price BETWEEN 0 AND 25000 THEN '0-25K'
            WHEN price BETWEEN 25001 AND 50000 THEN '25K-50K'
            WHEN price BETWEEN 50001 AND 75000 THEN '50K-75K'
            WHEN price BETWEEN 75001 AND 100000 THEN '75K-100K'
            ELSE '>100K'
        END AS 'buckets'
    FROM laptops
) t
GROUP BY t.buckets;

-- 6. BIVARIATE ANALYSIS: Categorical vs Numerical
-- Analysis of Price behavior across different laptop brands
SELECT Company, 
       COUNT(*) AS laptop_count,
       MIN(price) AS min_p,
       MAX(price) AS max_p,
       AVG(price) AS avg_p,
       STD(price) AS std_p
FROM laptops
GROUP BY Company;

-- 7. CROSS-TABULATION (Pivoting): Feature counts by Brand
-- Check Touchscreen availability and CPU brand distribution per Company
SELECT Company,
       SUM(CASE WHEN Touchscreen = 1 THEN 1 ELSE 0 END) AS 'Touchscreen_yes',
       SUM(CASE WHEN Touchscreen = 0 THEN 1 ELSE 0 END) AS 'Touchscreen_no',
       SUM(CASE WHEN cpu_brand = 'Intel' THEN 1 ELSE 0 END) AS 'intel_cpu',
       SUM(CASE WHEN cpu_brand = 'AMD' THEN 1 ELSE 0 END) AS 'amd_cpu'
FROM laptops
GROUP BY Company;

-- 8. HANDLING MISSING VALUES (Imputation)
-- Impute missing prices using the average price of the same Company
-- Note: We use a JOIN here because MySQL restricts updating a table used in a FROM subquery.
UPDATE laptops l1
JOIN (SELECT Company, AVG(Price) as avg_p FROM laptops GROUP BY Company) l2 
  ON l1.Company = l2.Company
SET l1.price = l2.avg_p
WHERE l1.price IS NULL;

-- 9. FEATURE ENGINEERING: PPI & Screen Size
-- Calculate Pixels Per Inch (PPI) for display quality analysis
ALTER TABLE laptops ADD COLUMN ppi INTEGER;
UPDATE laptops
SET ppi = ROUND(SQRT(POW(resolution_width, 2) + POW(resolution_height, 2)) / Inches);

-- Categorize Screen Sizes for simplified grouping
ALTER TABLE laptops ADD COLUMN screen_size VARCHAR(255) AFTER Inches;
UPDATE laptops
SET screen_size = 
    CASE 
        WHEN Inches < 14.0 THEN 'Small'
        WHEN Inches >= 14.0 AND Inches < 17.0 THEN 'Medium'
        ELSE 'Large'
    END;

-- 10. PREPARATION FOR MACHINE LEARNING: One-Hot Encoding
-- Create binary flags for GPU brands (useful for algorithms that require numbers)
SELECT gpu_brand,
       (gpu_brand = 'Intel') AS is_intel,
       (gpu_brand = 'AMD') AS is_amd,
       (gpu_brand = 'Nvidia') AS is_nvidia,
       (gpu_brand = 'ARM') AS is_arm
FROM laptops;
