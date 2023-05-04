-- Portfolio Project Part 1: SQL Data Exploration
-- GOAL: Create Several Views in order to later visualize different insured variables and there impact on the severity of accident 

--Initial Look at Data
SELECT * 
FROM `sqlportfolio-385416.claims_data.claims_table` as claims_table LIMIT 10 ;


--Create Customer Info Table
CREATE TABLE `sqlportfolio-385416.claims_data.customer_table` AS
  SELECT policy_number as customer_policy_number,months_as_customer,policy_state,policy_deductable,policy_annual_premium, insured_sex,
  insured_education_level,insured_occupation, insured_relationship,age
  From `sqlportfolio-385416.claims_data.claims_table` as claims_table
;

-- Preview Customer info table
SELECT * From `sqlportfolio-385416.claims_data.customer_table` LIMIT 10;

--CREATE ACCIDENT Info TABLE
CREATE TABLE `sqlportfolio-385416.claims_data.accident_table` AS
SELECT policy_number AS accident_policy_number, incident_type, collision_type,incident_severity,incident_state,incident_hour_of_the_day,
number_of_vehicles_involved,property_damage,bodily_injuries,total_claim_amount,injury_claim,property_claim,auto_make,auto_year,vehicle_claim
From `sqlportfolio-385416.claims_data.claims_table`
;

--Initial Look at Accident Info Table
SELECT * From `sqlportfolio-385416.claims_data.accident_table` LIMIT 10;

-- Lets join the Accident Table and Customer Table on policy_number * NOTE BigQuery Sandbox doesnt allow update statements for free version
--I will drop the accident_policy_number column in Pandas
CREATE TABLE `sqlportfolio-385416.claims_data.combined_table` AS
SELECT *
FROM `sqlportfolio-385416.claims_data.customer_table` AS customer_table 
INNER JOIN `sqlportfolio-385416.claims_data.accident_table` AS accident_table
ON customer_table.customer_policy_number = accident_table.accident_policy_number;

--Now that tables have been created and joined for Analysis, lets explore the data (for visulization)
--Question 1(Insured Profile Based on State): How many customers are insured in each state? 
--What is the average age and policy duration of customers in each state

SELECT policy_state, count(customer_policy_number) AS num_policies_per_state,ROUND(AVG(age),2) AS Avg_customer_age, ROUND(AVG(months_as_customer),2) AS 
customer_duration, 
FROM `sqlportfolio-385416.claims_data.combined_table`
GROUP BY policy_state
Order By 1 asc;


--Question 2
--How are the number of customers distributed across the Gender of the insured
SELECT insured_sex, count(customer_policy_number)
From`sqlportfolio-385416.claims_data.combined_table`
GROUP BY insured_sex;

--Question 3
-- How are the number of custoemrs distributed across Education Level

SELECT insured_education_level, count(customer_policy_number) AS num_policies_per_ed
From`sqlportfolio-385416.claims_data.combined_table`
GROUP BY insured_education_level;

--Question 4
-- What is the total amount of property damage/injury/vehicle claims and average total claim amount that occurred per state of the insured

SELECT policy_state, sum(injury_claim) AS total_inj_claim, sum(property_claim) AS total_prop_claim,sum(vehicle_claim) AS total_veh_claim,
ROUND(AVG(total_claim_amount),2) AS Average_Total_Claims
From`sqlportfolio-385416.claims_data.combined_table`
GROUP BY policy_state;



