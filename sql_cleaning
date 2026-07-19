--Step 1: Join data from July 2025 to June 2026
CREATE TABLE `cedar-turbine-501913-v0.cyclistic_rides.all_rides` AS
SELECT * FROM `cedar-turbine-501913-v0.cyclistic_rides.ride_data2507`
UNION ALL
SELECT * FROM `cedar-turbine-501913-v0.cyclistic_rides.ride_data2508`
UNION ALL
SELECT * FROM `cedar-turbine-501913-v0.cyclistic_rides.ride_data2509`
UNION ALL
SELECT * FROM `cedar-turbine-501913-v0.cyclistic_rides.ride_data2510`
UNION ALL
SELECT * FROM `cedar-turbine-501913-v0.cyclistic_rides.ride_data2511`
UNION ALL
SELECT * FROM `cedar-turbine-501913-v0.cyclistic_rides.ride_data2512`
UNION ALL
SELECT * FROM `cedar-turbine-501913-v0.cyclistic_rides.ride_data2601`
UNION ALL
SELECT * FROM `cedar-turbine-501913-v0.cyclistic_rides.ride_data2602`
UNION ALL
SELECT * FROM `cedar-turbine-501913-v0.cyclistic_rides.ride_data2603`
UNION ALL
SELECT * FROM `cedar-turbine-501913-v0.cyclistic_rides.ride_data2604`
UNION ALL
SELECT * FROM `cedar-turbine-501913-v0.cyclistic_rides.ride_data2605`
UNION ALL
SELECT * FROM `cedar-turbine-501913-v0.cyclistic_rides.ride_data2606`

--Step 2: Remove duplicate values
DELETE FROM `cedar-turbine-501913-v0.cyclistic_rides.all_rides` AS all_rides
WHERE
  EXISTS(
    SELECT 1
    FROM
      (
        SELECT ride_id, MAX(started_at) AS max_started_at
        FROM `cedar-turbine-501913-v0.cyclistic_rides.all_rides`
        GROUP BY ride_id
        HAVING COUNT(*) > 1
      ) AS duplicates
    WHERE
      all_rides.ride_id = duplicates.ride_id
      AND all_rides.started_at < duplicates.max_started_at
  )

--Step 3: Check for null values for ride_id, started_at, ended_at, rideable_type, member_casual
SELECT
  *
FROM `cedar-turbine-501913-v0.cyclistic_rides.all_rides`
WHERE ride_id is null OR started_at is null or ended_at is null or rideable_type is null or member_casual is null

--Step 4: Confirm there are only 2 types for both rideable_type and member_casual
SELECT
  count(distinct rideable_type)
FROM `cedar-turbine-501913-v0.cyclistic_rides.all_rides` 

SELECT
  count(distinct member_casual)
FROM `cedar-turbine-501913-v0.cyclistic_rides.all_rides` 


--Step 5: Delete all records with rides starting after ending
DELETE
FROM cedar-turbine-501913-v0.cyclistic_rides.all_rides
WHERE started_at > ended_at;

--Step 6: Make start and end station names have a unique station name attached to the station ID
UPDATE `cedar-turbine-501913-v0.cyclistic_rides.all_rides` t
SET start_station_name = names.canonical_name
FROM
  (
    SELECT start_station_id, MIN(start_station_name) AS canonical_name
    FROM `cedar-turbine-501913-v0.cyclistic_rides.all_rides`
    WHERE start_station_id IS NOT NULL
    GROUP BY 1
  ) names
WHERE t.start_station_id = names.start_station_id;

UPDATE `cedar-turbine-501913-v0.cyclistic_rides.all_rides` t
SET end_station_name = names.canonical_name
FROM
  (
    SELECT end_station_id, MIN(end_station_name) AS canonical_name
    FROM `cedar-turbine-501913-v0.cyclistic_rides.all_rides`
    WHERE end_station_id IS NOT NULL
    GROUP BY 1
  ) names
WHERE t.end_station_id = names.end_station_id;

--Step 7: Create columns for ride duration and day of the week
ALTER TABLE `cedar-turbine-501913-v0.cyclistic_rides.all_rides`
ADD COLUMN ride_duration INTERVAL;

UPDATE `cedar-turbine-501913-v0.cyclistic_rides.all_rides`
SET ride_duration = ended_at - started_at
WHERE TRUE;

ALTER TABLE cedar-turbine-501913-v0.cyclistic_rides.all_rides
ADD COLUMN day_of_week STRING;

UPDATE `cedar-turbine-501913-v0.cyclistic_rides.all_rides`
SET day_of_week = FORMAT_DATETIME('%A', started_at)
WHERE true;

--Step 8: Redid ride duration column to reflect ride duration as an integer recorded in seconds
ALTER TABLE `cedar-turbine-501913-v0.cyclistic_rides.all_rides`
DROP COLUMN ride_duration;

ALTER TABLE `cedar-turbine-501913-v0.cyclistic_rides.all_rides`
ADD COLUMN ride_duration int64;

UPDATE `cedar-turbine-501913-v0.cyclistic_rides.all_rides`
set ride_duration = time_diff(end_time_only, start_time_only, second)
WHERE true;

--Step 9: Removed rides with negative durations
--then rides with durations under 15 seconds
--assuming inaccurate records
DELETE FROM `cedar-turbine-501913-v0.cyclistic_rides.all_rides`
WHERE ride_duration < 0

DELETE FROM `cedar-turbine-501913-v0.cyclistic_rides.all_rides`
WHERE ride_duration < 15;

