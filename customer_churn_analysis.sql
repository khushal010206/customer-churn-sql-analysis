-------------------------------------------------------------
--Data Validation
-------------------------------------------------------------
--Check Total Records
SELECT COUNT(*) AS total_records
FROM customer_churn;

--Check Duplicate Customer IDs
SELECT
    customerid,
    COUNT(*)
FROM customer_churn
GROUP BY customerid
HAVING COUNT(*) > 1;

--Check NULL Values
SELECT
    COUNT(*) FILTER (WHERE customerid IS NULL) AS customerid_null,
    COUNT(*) FILTER (WHERE totalcharges IS NULL) AS totalcharges_null,
    COUNT(*) FILTER (WHERE monthlycharges IS NULL) AS monthlycharges_null,
    COUNT(*) FILTER (WHERE tenure IS NULL) AS tenure_null,
    COUNT(*) FILTER (WHERE churn IS NULL) AS churn_null
FROM customer_churn;

--Check Empty Strings
SELECT *
FROM customer_churn
WHERE
TRIM(customerid) = ''
OR TRIM(contract) = ''
OR TRIM(churn) = '';

--Validate Categorical Values
SELECT DISTINCT churn FROM customer_churn;

SELECT DISTINCT contract FROM customer_churn;

SELECT DISTINCT internetservice FROM customer_churn;

--Check Numeric Ranges
SELECT
MIN(tenure),
MAX(tenure),
MIN(monthlycharges),
MAX(monthlycharges)
FROM customer_churn;

--Check Negative Values
SELECT *
FROM customer_churn
WHERE
tenure < 0
OR monthlycharges < 0
OR totalcharges < 0;

--Check CustomerID Uniqueness
SELECT
COUNT(customerid),
COUNT(DISTINCT customerid)
FROM customer_churn;


-------------------------------------------------------------
-- Customer Churn Exploratory Data Analysis (EDA) & Insights
-------------------------------------------------------------

--Find the total number of customers.

SELECT COUNT(*) AS total_customer FROM customer_churn;


--Find the number of churned customers.

SELECT COUNT(*) AS churned_customer FROM customer_churn
WHERE churn = 'Yes';

--Find the churn rate (%).
SELECT 
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    COUNT(*) AS total_customers,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)::numeric / COUNT(*) * 100,
        2
    ) AS churn_rate_percent
FROM customer_churn;

--Find the average monthly charges.

SELECT ROUND(AVG(monthlycharges),2) AS avg_monthlycharges 
FROM customer_churn;

--Find the average tenure.

SELECT ROUND(AVG(tenure),2) AS avg_tenure 
FROM customer_churn;

--Find the minimum and maximum monthly charges.

SELECT  MAX(monthlycharges) AS max_monthlycharges , 
MIN(monthlycharges) AS min_monthlycharges 
FROM customer_churn;


--Count customers by gender.

SELECT gender,COUNT(*) AS total_customer
FROM customer_churn
GROUP BY gender;

--Count customers by contract type.

SELECT contract AS contract_type, COUNT(*) AS total_customers 
FROM customer_churn
GROUP BY contract;

--Count customers by payment method.
SELECT paymentmethod , COUNT(*) AS total_customer
FROM customer_churn
GROUP BY paymentmethod;

--Count customers by internet service type.

SELECT internetservice , COUNT(*) AS total_customer
FROM customer_churn
GROUP BY internetservice;

--Find the average monthly charge for each contract type.

SELECT contract , ROUND(AVG(monthlycharges),2) AS avg_monthlycharges
FROM customer_churn
GROUP BY contract;

--Find the average tenure for each contract type.

SELECT contract , ROUND(AVG(tenure),2) AS avg_tenure
FROM customer_churn
GROUP BY contract;

--Find the average monthly charge by gender.
SELECT gender , ROUND(AVG(monthlycharges),2) AS avg_monthlycharges
FROM customer_churn
GROUP BY gender;

--Count senior citizens and non-senior citizens.

SELECT seniorcitizen, COUNT(*) AS total_customers
FROM customer_churn
GROUP BY seniorcitizen;

--Find the percentage of senior citizens.

SELECT 
    COUNT(*) AS total_customer,
    SUM(CASE WHEN seniorcitizen = 1 THEN 1 ELSE 0 END) AS senior_citizens, -- Fixed spelling
    ROUND(100.0 * SUM(CASE WHEN seniorcitizen = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS senior_citizen_percent
FROM customer_churn;


-------------------------------------------------------------
-- Business Analysis
-------------------------------------------------------------

--Which contract type has the highest churn rate?
SELECT contract AS contract_type,
    ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customer_churn
GROUP BY contract;

--Which payment method has the highest churn rate?
SELECT paymentmethod,
    ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customer_churn
GROUP BY paymentmethod;

--Which internet service has the highest churn rate?

SELECT internetservice,
    ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customer_churn
GROUP BY internetservice;

--Does tenure affect churn?

SELECT 
    CASE 
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 48 THEN '25-48 months'
        WHEN tenure <= 60 THEN '49-60 months'
        ELSE '60+ months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)::numeric / COUNT(*) * 100,
        2
    ) AS churn_rate_percent
FROM customer_churn
GROUP BY tenure_group
ORDER BY MIN(tenure);

--Do customers with higher monthly charges churn more?
WITH monthly_charge AS (
    SELECT
        monthlycharges,
        churn,
        CASE
            WHEN monthlycharges < 54 THEN 'Low'
            WHEN monthlycharges BETWEEN 54 AND 74 THEN 'Medium'
            ELSE 'High'
        END AS monthlycharge_group
    FROM customer_churn
)

SELECT
    monthlycharge_group,
    COUNT(*) AS total_customer,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customer,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_percentage
FROM monthly_charge
GROUP BY monthlycharge_group
ORDER BY churn_percentage DESC;

--Compare churn rates by gender.

SELECT gender, COUNT(*) AS total_customer,SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customer,
ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2 ) AS churn_rate
FROM customer_churn
GROUP BY gender
ORDER BY churn_rate DESC;

--Compare churn rates for senior citizens and non-senior citizens.

SELECT seniorcitizen,
COUNT(*) AS total_customer,
SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customer,
ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2 ) AS churn_rate
FROM customer_churn
GROUP BY seniorcitizen
ORDER BY churn_rate DESC;

--Compare churn rates by partner status.

SELECT partner,
COUNT(*) AS total_customer,
SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customer,
ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2 ) AS churn_rate
FROM customer_churn
GROUP BY partner
ORDER BY churn_rate DESC;

--Compare churn rates by dependents.
SELECT dependents,
COUNT(*) AS total_customer,
SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customer,
ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2 ) AS churn_rate
FROM customer_churn
GROUP BY dependents
ORDER BY churn_rate DESC;

--Which combinations of services have the highest churn?

SELECT
    internetservice,
    onlinesecurity,
    techsupport,
    streamingtv,
    streamingmovies,

    COUNT(*) AS total_customer,

    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customer,

    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate

FROM customer_churn

GROUP BY
    internetservice,
    onlinesecurity,
    techsupport,
    streamingtv,
    streamingmovies

HAVING COUNT(*) >= 20

ORDER BY churn_rate DESC, total_customer DESC;

--Find the top 10 customers with the highest monthly charges.
SELECT *
FROM (
      SELECT 
	        customerid,
			monthlycharges,
			DENSE_RANK() OVER(ORDER BY monthlycharges DESC ) AS monthly_charges_rank
	  FROM customer_churn
) AS ranked
WHERE monthly_charges_rank <= 10;

--Rank customers based on monthly charges.

SELECT
    customerid,
    monthlycharges,
    DENSE_RANK() OVER (ORDER BY monthlycharges DESC) AS monthly_charge_rank
FROM customer_churn;


--Find the top 5 longest-tenure customers using a window function.

SELECT *
FROM (
    SELECT
        customerid,
        tenure,
        DENSE_RANK() OVER (ORDER BY tenure DESC) AS tenure_rank
    FROM customer_churn
) AS ranked_customers
WHERE tenure_rank <= 5;


--Find customers whose tenure is above the average tenure.

SELECT
    customerid,
    tenure
FROM customer_churn
WHERE tenure > (
    SELECT AVG(tenure)
    FROM customer_churn

)
ORDER BY tenure DESC;

--Find the second-highest monthly charge.

SELECT *
FROM (
      SELECT 
	        customerid,
			monthlycharges,
			DENSE_RANK() OVER(ORDER BY monthlycharges DESC ) AS monthly_charges_rank
	  FROM customer_churn
)
WHERE monthly_charges_rank = 2;

--Find the third-highest monthly charge.
SELECT *
FROM (
      SELECT 
	        customerid,
			monthlycharges,
			DENSE_RANK() OVER(ORDER BY monthlycharges DESC ) AS monthly_charges_rank
	  FROM customer_churn
)
WHERE monthly_charges_rank = 3;
--Find customers who use every available service.
SELECT
    customerid,
    onlinesecurity,
    onlinebackup,
    deviceprotection,
    techsupport,
    streamingtv,
    streamingmovies
FROM customer_churn
WHERE
    onlinesecurity = 'Yes'
    AND onlinebackup = 'Yes'
    AND deviceprotection = 'Yes'
    AND techsupport = 'Yes'
    AND streamingtv = 'Yes'
    AND streamingmovies = 'Yes';

--Segment customers into High, Medium, and Low value based on MonthlyCharges.

WITH monthly_charge AS (
    SELECT customerid,
        CASE
            WHEN monthlycharges < 54 THEN 'Low'
            WHEN monthlycharges BETWEEN 54 AND 74 THEN 'Medium'
            ELSE 'High'
        END AS segment_customer
    FROM customer_churn
)

SELECT
    segment_customer,
    COUNT(*) AS customer_count
FROM monthly_charge
GROUP BY segment_customer;

--Identify high-risk customers (high charges + month-to-month contract + active).

SELECT
    customerid,
    monthlycharges,
    contract,
    churn
FROM customer_churn
WHERE monthlycharges >= 74        
  AND contract = 'Month-to-month'
  AND churn = 'No'                
ORDER BY monthlycharges DESC;


--Identify loyal customers (long tenure + two-year contract + not churned).

SELECT
    customerid,
    tenure,
    contract,
    monthlycharges
FROM customer_churn
WHERE tenure > 60 
  AND contract = 'Two year'
  AND churn = 'No'
ORDER BY tenure DESC;