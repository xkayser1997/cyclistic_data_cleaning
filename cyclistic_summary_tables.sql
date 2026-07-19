--Created summary tables for easier analysis


--Total number of trips by member status
CREATE OR REPLACE TABLE `cedar-turbine-501913-v0.cyclistic_rides.trips_by_rider` AS

SELECT
    member_casual,
    COUNT(*) AS total_trips
FROM cedar-turbine-501913-v0.cyclistic_rides.all_rides
GROUP BY member_casual;

--Total number of trips by day of the week and member status
CREATE OR REPLACE TABLE `cedar-turbine-501913-v0.cyclistic_rides.trips_by_day` AS

SELECT
    day_of_week,
    member_casual,
    COUNT(*) AS trips
FROM cedar-turbine-501913-v0.cyclistic_rides.all_rides
GROUP BY day_of_week, member_casual;

--Average ride duration by member status
CREATE OR REPLACE TABLE `cedar-turbine-501913-v0.cyclistic_rides.average_duration_by_rider` AS

SELECT
    member_casual,
    round(avg(ride_duration),2) AS avg_ride_duration,
FROM cedar-turbine-501913-v0.cyclistic_rides.all_rides
GROUP BY member_casual;

--Total number of trips per month by member status
CREATE OR REPLACE TABLE `cedar-turbine-501913-v0.cyclistic_rides.trips_by_month` AS

SELECT
    FORMAT_DATE('%B', DATE(started_at)) AS month,
    EXTRACT(MONTH FROM DATE(started_at)) AS month_num,
    member_casual,
    COUNT(*) AS trips,
FROM cedar-turbine-501913-v0.cyclistic_rides.all_rides
GROUP BY month, month_num, member_casual
ORDER by month_num;

--Total number of trips by hour and member status
CREATE OR REPLACE TABLE `cedar-turbine-501913-v0.cyclistic_rides.trips_by_hour` AS

SELECT
    EXTRACT(HOUR FROM started_at) AS hour,
    member_casual,
    COUNT(*) AS trips
FROM cedar-turbine-501913-v0.cyclistic_rides.all_rides
GROUP BY hour, member_casual
ORDER by hour;

--Total number of trips by bike type and member status
CREATE OR REPLACE TABLE `cedar-turbine-501913-v0.cyclistic_rides.bike_type_usage` AS

SELECT
  rideable_type,
  member_casual,
  count (*) as trips
FROM cedar-turbine-501913-v0.cyclistic_rides.all_rides
GROUP BY rideable_type, member_casual
ORDER BY trips DESC; 

--Top 10 start stations with total trips divided by member status
CREATE OR REPLACE TABLE `cedar-turbine-501913-v0.cyclistic_rides.top_start_stations` AS

WITH top_10_stations AS
    (SELECT
    start_station_name,
    count(*) as trips
FROM cedar-turbine-501913-v0.cyclistic_rides.all_rides
WHERE start_station_name is not null
GROUP by 1
ORDER BY trips DESC
limit 10) 

SELECT
  t.start_station_name,
  r.member_casual,
  count(*) as trip_count
FROM
  `cedar-turbine-501913-v0.cyclistic_rides.all_rides` as r
JOIN top_10_stations as t
  ON r.start_station_name = t.start_station_name
GROUP BY 1,2
ORDER BY start_station_name, trip_count desc

--Top 10 end stations with total trips divided by member status
CREATE OR REPLACE TABLE `cedar-turbine-501913-v0.cyclistic_rides.top_end_stations` AS

WITH top_10_stations AS
    (SELECT
    end_station_name,
    count(*) as trips
FROM cedar-turbine-501913-v0.cyclistic_rides.all_rides
WHERE end_station_name is not null
GROUP by 1
ORDER BY trips DESC
limit 10) 

SELECT
  t.end_station_name,
  r.member_casual,
  count(*) as trip_count
FROM
  `cedar-turbine-501913-v0.cyclistic_rides.all_rides` as r
JOIN top_10_stations as t
  ON r.end_station_name = t.end_station_name
GROUP BY 1,2
ORDER BY end_station_name, trip_count DESC
