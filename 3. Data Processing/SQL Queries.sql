SELECT
  *
FROM
  "BRIGHTTV"."PUBLIC"."BRIGHTTV_VIEWERSHIP"
LIMIT
  10;


SELECT
  *
FROM
  "BRIGHTTV"."PUBLIC"."USERPROFILE"
LIMIT
  10;

  SELECT DISTINCT
       channel2
    FROM
  "BRIGHTTV"."PUBLIC"."BRIGHTTV_VIEWERSHIP";


----------

SELECT DISTINCT gender
FROM
  "BRIGHTTV"."PUBLIC"."USERPROFILE";


SELECT DISTINCT race
FROM
  "BRIGHTTV"."PUBLIC"."USERPROFILE";

SELECT DISTINCT province
FROM
  "BRIGHTTV"."PUBLIC"."USERPROFILE";



---------1.GENDER-----------

---Replacing the null values in the column with Uknown------
SELECT userid, race, province,
     CASE 
         WHEN gender = 'None' THEN 'Unknown'
         WHEN gender = 'null' THEN 'Uknown'
         ELSE gender
         END AS gender
FROM
  "BRIGHTTV"."PUBLIC"."USERPROFILE";

--2.RACE

--Replacing the null values in the column with Unspecified
SELECT 
    CASE 
        WHEN race IN ('None','other') THEN 'Unspecified'
        WHEN race IS NULL THEN 'Unspecified'
        ELSE race
        END AS race
        
FROM
  "BRIGHTTV"."PUBLIC"."USERPROFILE";

--3.PROVINCE

--Replacing the null values in the Province column with Uknown
SELECT DISTINCT
    CASE 
        WHEN province = 'None' THEN 'Unknown'
        WHEN province IS NULL THEN 'Unknown'
        ELSE province
        END AS province
        
FROM
  "BRIGHTTV"."PUBLIC"."USERPROFILE";

--4.AGE

--Checking min, avg and maximum age of viewers
SELECT MIN(age) AS min_age
FROM
  "BRIGHTTV"."PUBLIC"."USERPROFILE";
--min age=0

SELECT MAX(age) AS max_age
FROM
  "BRIGHTTV"."PUBLIC"."USERPROFILE";
--max age=114

SELECT AVG(age) AS avg_age
FROM
  "BRIGHTTV"."PUBLIC"."USERPROFILE";
--avg age=27

--Checking null values in age
SELECT age 
FROM
  "BRIGHTTV"."PUBLIC"."USERPROFILE"
WHERE age IS NULL; 
--no null values

--Grouping Age
SELECT userid, gender, race, province,
 CASE
     WHEN age BETWEEN 0 AND 12 THEN 'kids'
     WHEN age BETWEEN 13 AND 19 THEN 'teens'
     WHEN age BETWEEN 20 AND 40 THEN 'adults'
     ELSE 'senior'
     END AS age_groups
FROM
  "BRIGHTTV"."PUBLIC"."USERPROFILE";     

-----------------------------------------------------------------------------------------------------------------------------

-----Creating a temporary table called users
CREATE OR REPLACE TEMP TABLE users AS (

SELECT userid, age,
  CASE 
         WHEN gender = 'None' THEN 'unknown'
         WHEN gender IS NULL THEN 'uknown'
         ELSE gender
         END AS gender,

  CASE       
        WHEN race IN ('None','other') THEN 'unspecified'
        WHEN race IS NULL THEN 'unspecified'
        ELSE race
        END AS race,

   CASE 
        WHEN province = 'None' THEN 'Uknown'
        WHEN province IS NULL THEN 'Unknown'
        ELSE province
        END AS province,     
        
   CASE
     WHEN age <= 0 THEN '1. Infant'
     WHEN age BETWEEN 0 AND 12 THEN '2. 0-12 kids'
     WHEN age BETWEEN 13 AND 19 THEN '3. 13-19 teens'
     WHEN age BETWEEN 20 AND 40 THEN '4. 20-40 adults'
     ELSE '5. 40+ senior'
     END AS age_groups,     

 FROM
  "BRIGHTTV"."PUBLIC"."USERPROFILE");

 
-----------------------------------------------------------------------------------------------------------------------------

--Viewership Table

 SELECT
  *
FROM BRIGHTTV_VIEWERSHIP;

--Creating temporary table
CREATE OR REPLACE TEMP TABLE views AS (

--Formating the time stamp and categorising the dates
SELECT userid,channel2,duration2,

-- This detect all possible mixed time formats and convert to time stamp
COALESCE(
    TRY_TO_TIMESTAMP(recorddate2, 'YYYY/MM/DD HH24:MI'),
    TRY_TO_TIMESTAMP(recorddate2, 'MM/DD/YYYY HH24:MI'),
    TRY_TO_TIMESTAMP(recorddate2, 'YYYY-MM-DD HH24:MI:SS'),
    TRY_TO_TIMESTAMP(recorddate2) 
) AS recorddate2_ts,

   TO_DATE(recorddate2_ts) AS watch_date,
   MONTHNAME(recorddate2_ts) AS month_name,
   DAYNAME(recorddate2_ts) AS day_name,    
  CASE
      WHEN day_name NOT IN ('Saturday', 'Sunday') THEN 'Weekday'
      ELSE 'Weekend'
      END AS day_category,

   TO_TIME(recorddate2_ts) AS watch_time,   
  CASE
      WHEN watch_time BETWEEN '06:00:00' AND '11:59:59' THEN '1. 6am-12pm Morning slot'
      WHEN watch_time BETWEEN '12:00:00' AND '14:59:59' THEN '2. 12pm-3pm Day slot'
      WHEN watch_time BETWEEN '15:00:00' AND '17:59:59' THEN '3. 3pm-6pm Afternoon slot'
      WHEN watch_time BETWEEN '18:00:00' AND '23:59:59' THEN '4. 6pm-12am Evening slot'
      ELSE '5. Early morning slot'
      END AS watch_time_slots,

FROM BRIGHTTV_VIEWERSHIP);      

----------------Joining the two temporary tables---------------------------------------

SELECT DISTINCT A.userid, channel2,duration2, recorddate2_ts, watch_date, day_name, day_category, month_name, watch_time, watch_time_slots, age, gender, race, province, age_groups,
COUNT(*) AS total_views,
FROM views AS A
LEFT JOIN users AS B
ON A.userid = B.userid
GROUP BY ALL;
