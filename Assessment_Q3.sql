USE adashi_staging;

SELECT *
FROM plans_plan;

SELECT *
FROM savings_savingsaccount;

-- Challenge: Knowing whether to what to classify as inactive account after is_regular_savings and is_fund
WITH date_plan AS(
		SELECT p.id, s.owner_id, type, MAX(transaction_date) AS last_transaction_date
	FROM (
		SELECT 
			*,
			CASE
				WHEN is_a_fund = 1 THEN 'Investment'
				WHEN is_regular_savings = 1 THEN 'Savings'
				ELSE 'Inactive' END AS type
		FROM plans_plan
		) AS p
		RIGHT JOIN savings_savingsaccount s
		ON p.id = s.plan_id
        AND p.owner_id = s.owner_id
        GROUP BY p.id, s.owner_id, type),
inactivity AS (
        SELECT 
			*, 
            datediff((SELECT MAX(transaction_date) FROM savings_savingsaccount), last_transaction_date) AS inactivity_days
		FROM date_plan
        )
SELECT * 
FROM inactivity 
WHERE inactivity_days > 365 
	AND type IN ('Savings', 'Investment')
ORDER BY inactivity_days DESC;