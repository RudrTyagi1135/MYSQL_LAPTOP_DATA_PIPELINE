CREATE DATABASE laptops;

USE laptops;
SELECT * FROM laptops;

-- 1. Create backup
CREATE TABLE laptops_backup LIKE laptops;
INSERT INTO laptops_backup SELECT * FROM laptops;


-- 2. Check number of rows
SELECT COUNT(*) AS total_rows FROM laptops;


-- 3. Check memory consumption for reference
SELECT 
    table_name AS "Table",
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "Size (MB)"
FROM information_schema.TABLES
WHERE table_schema = 'laptops' AND table_name = 'laptops';


-- 4. Drop non important cols
ALTER TABLE laptops RENAME COLUMN `unnamed: 0` TO `index`;

-- 5. Drop null values
DELETE FROM laptops 
WHERE Company IS NULL AND TypeName IS NULL AND Inches IS NULL
AND ScreenResolution IS NULL AND Cpu IS NULL AND Ram IS NULL
AND Memory IS NULL AND Gpu IS NULL AND OpSys IS NULL AND
WEIGHT IS NULL AND Price IS NULL;



-- 6. Drop duplicates
CREATE TABLE temp_laptops AS 
SELECT DISTINCT * FROM laptops;

TRUNCATE TABLE laptops;

INSERT INTO laptops SELECT * FROM temp_laptops;

DROP TABLE temp_laptops;


-- 7. Clean RAM -> change col data type
UPDATE laptops SET Ram = REPLACE(Ram, 'GB', '');
ALTER TABLE laptops MODIFY COLUMN Ram INT;


-- 8. Clean weight -> change col type
UPDATE laptops 
SET Weight = NULL 
WHERE Weight = '' OR Weight = ' ';

UPDATE laptops 
SET Weight = REPLACE(Weight, 'kg', '') 
WHERE Weight LIKE '%kg%';

UPDATE laptops 
SET Weight = TRIM(Weight);




-- 9. ROUND price col and change to integer
UPDATE laptops SET Price = ROUND(Price);
ALTER TABLE laptops MODIFY COLUMN Price INT;



-- Simplify OpSys (e.g., "Windows 10" to "Windows")
UPDATE laptops SET OpSys = SUBSTRING_INDEX(OpSys, ' ', 1);

-- Simplify Gpu (e.g., "Intel HD Graphics 620" to "Intel")
UPDATE laptops SET Gpu = SUBSTRING_INDEX(Gpu, ' ', 1);

-- Simplify Cpu (e.g., "Intel Core i5 7200U 2.5GHz" to "Intel Core i5")
UPDATE laptops SET Cpu = SUBSTRING_INDEX(Cpu, ' ', 3);


SELECT * FROM laptops;