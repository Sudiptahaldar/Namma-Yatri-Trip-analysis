-- Using Nammayatri database
use nammayatri;

-- droping table if exist
drop table assembly, date_dim, payment, tripdetails, trips;

-- Importing datasets using table data import wizard and Show the table
select * from nammayatri_assembly;
select * from nammayatri_date;
select * from nammayatri_payment;
select * from nammayatri_tripdetails;
select * from nammayatri_trips;

-- Rename column inside tables 
ALTER TABLE nammayatri_assembly
RENAME COLUMN ï»¿ID TO ID;

ALTER TABLE nammayatri_payment
RENAME COLUMN ï»¿id TO ID;

ALTER TABLE nammayatri_tripdetails
RENAME COLUMN ï»¿tripid TO tripid;

ALTER TABLE nammayatri_trips
RENAME COLUMN ï»¿tripid TO tripid;

-- Adding new column route in trips table
ALTER TABLE nammayatri_trips
ADD route VARCHAR(255);

SET SQL_SAFE_UPDATES = 0;
-- To create the route column we have to join the assembly table twice
UPDATE nammayatri_trips t
JOIN nammayatri_assembly a_from ON t.loc_from = a_from.id
JOIN nammayatri_assembly a_to   ON t.loc_to   = a_to.id
SET t.route = CONCAT(a_from.Assembly, ' → ', a_to.Assembly);

-- Category 1: Revenue & Pricing Analysis

-- 1. Total Revenue by Payment Method: Calculate the total fare collected for each payment method (Cash, UPI, etc.).
SELECT p.method AS payment_method, SUM(tp.fare) AS total_revenue FROM nammayatri_trips tp
JOIN nammayatri_payment p ON tp.faremethod = p.ID
GROUP BY p.method
ORDER BY total_revenue DESC;

-- 2. Average Fare per Area: Which Assembly area (loc_from) has the highest average fare per trip?
SELECT a.Assembly, AVG(tp.fare) AS avg_fare FROM nammayatri_trips tp 
JOIN nammayatri_assembly a on tp.loc_from = a.ID
GROUP BY a.Assembly
ORDER BY avg_fare DESC;

-- 3. High-Value Trips: Find the total number of trips where the fare was greater than 500 and the payment method was 'Credit Card'.
SELECT COUNT(*) AS high_value_trips FROM nammayatri_trips tp
JOIN nammayatri_payment p ON tp.faremethod = p.ID
WHERE tp.fare > 500 AND p.method = 'credit card';

-- 4. Fare per Distance Efficiency: Calculate the average fare-per-distance (fare / distance) for each payment method.
SELECT p.method AS payment_method, AVG(tp.fare / tp.distance) AS avg_fare_per_distance
FROM nammayatri_trips tp JOIN nammayatri_payment p ON tp.faremethod = p.ID
WHERE tp.distance > 0
GROUP BY p.method
ORDER BY avg_fare_per_distance DESC;

-- 5. Earnings by Duration: Which duration range (from the Duration table, e.g., "0-1", "1-2") generates the highest total revenue?
SELECT d.duration AS duration_range, SUM(tp.fare) AS total_revenue
FROM nammayatri_trips tp
JOIN nammayatri_date d ON tp.duration = d.id
GROUP BY d.duration
ORDER BY total_revenue DESC;

-- Category 2: Driver & Customer Performance

-- 1. Top 5 Earners: Identify the top 5 drivers (driverid) based on total earnings.
SELECT driverid, SUM(fare) AS total_earnings FROM nammayatri_trips 
GROUP BY driverid ORDER BY total_earnings DESC LIMIT 5;

-- 2. Frequent Travelers: Find the top 5 customers (custid) who have taken the most number of rides.
SELECT custid, COUNT(tripid) AS total_rides FROM nammayatri_trips
GROUP BY custid ORDER BY total_rides DESC LIMIT 5;

-- 3. Driver Utilization: List drivers who have completed more than 50 trips.
SELECT driverid, COUNT(tripid) AS total_trips FROM nammayatri_trips
GROUP BY driverid HAVING COUNT(tripid) > 50;

-- 4. Single Trip High Spenders: Identify customers who have taken exactly 1 trip, but that trip cost more than 750
SELECT custid, SUM(fare) AS total_spent, COUNT(tripid) AS total_trips FROM nammayatri_trips
GROUP BY custid HAVING COUNT(tripid) = 1 AND SUM(fare) > 750;

-- 5. Driver Average Distance: Calculate the average distance traveled per trip for each driver, sorted in descending order.
SELECT driverid, AVG(distance) AS avg_distance FROM nammayatri_trips 
GROUP BY driverid ORDER BY avg_distance DESC;

-- Category 3: Operational Funnel (Conversion & Cancellations)

-- 1. Search to Estimate Rate: For each assembly area, calculate the percentage of searches that resulted in an estimate (searches_got_estimate / searches).
SELECT loc_from, ROUND(SUM(searches_got_estimate) * 100.0 / SUM(searches),2) AS estimate_rate_percentage 
FROM nammayatri_tripdetails GROUP BY loc_from;

-- 2. Driver Cancellation Hotspots: Which assembly area has the highest number of driver cancellations (where driver_not_cancelled = 0)?
SELECT a.Assembly, COUNT(*) AS driver_cancellations FROM nammayatri_tripdetails td join nammayatri_assembly a
on td.loc_from = a.ID WHERE td.driver_not_cancelled = 0
GROUP BY a.Assembly ORDER BY driver_cancellations DESC LIMIT 1;

-- 3. Customer Cancellation Hotspots: Which assembly area has the highest number of customer cancellations (where customer_not_cancelled = 0)?
SELECT a.Assembly, COUNT(*) AS customer_cancellations FROM nammayatri_tripdetails td join nammayatri_assembly a
on td.loc_from = a.ID WHERE td.customer_not_cancelled = 0
GROUP BY a.Assembly ORDER BY customer_cancellations DESC LIMIT 1;

-- 4. OTP Drop-offs: Find the total number of trips where an OTP was entered (otp_entered = 1) but the ride was not completed (end_ride = 0).
SELECT COUNT(*) AS otp_dropoff_trips FROM nammayatri_tripdetails
WHERE otp_entered = 1 AND end_ride = 0;

-- 5. End-to-End Conversion: Calculate the overall conversion rate from 'search' to 'end_ride' (Total Completed Rides / Total Searches) for the entire dataset.
SELECT ROUND(SUM(end_ride) * 100.0 / SUM(searches),2) AS overall_conversion_rate_percentage
FROM nammayatri_tripdetails;

-- Category 4: Location & Route Analysis

-- 1. Most Popular Pickup Locations: List the top 3 Assembly names (e.g., "Jayanagar") that generated the most trip requests (searches).
SELECT a.Assembly, SUM(td.searches) AS total_searches
FROM nammayatri_tripdetails td JOIN nammayatri_assembly a ON td.loc_from = a.ID
GROUP BY a.Assembly ORDER BY total_searches DESC
LIMIT 3;

-- 2. Top Routes: Identify the most frequent route (combination of loc_from and loc_to).
SELECT route, COUNT(*) AS total_trips FROM nammayatri_trips 
GROUP BY route ORDER BY total_trips DESC LIMIT 1;

-- 3. Long Distance Connections: Find the pair of Assembly areas (loc_from and loc_to) with the longest average distance.
SELECT route, AVG(distance) AS avg_distance FROM nammayatri_trips
GROUP BY route ORDER BY avg_distance DESC LIMIT 1;

-- 4. Demand vs. Supply (Quotes): Which Assembly area has the lowest "Quote Acceptance" rate (ratio of searches_got_quotes to searches_for_quotes)?
SELECT a.Assembly, (SUM(td.searches_got_quotes) * 1.0 / SUM(td.searches_for_quotes)) AS quote_rate 
FROM nammayatri_tripdetails td join nammayatri_assembly a on td.loc_from = a.ID
GROUP BY a.Assembly ORDER BY quote_rate asc LIMIT 1;

-- 5.Payment Preference by Location: For a specific area (e.g., 'Hebbal'), what is the most commonly used payment method?
SELECT a.Assembly, p.method as Payment_method, COUNT(*) AS usage_count FROM 
nammayatri_payment p join nammayatri_trips t on p.ID = t.faremethod 
join nammayatri_assembly a on t.loc_from = a.ID WHERE a.Assembly = 'Hebbal'
GROUP BY p.method ORDER BY usage_count DESC LIMIT 1;




