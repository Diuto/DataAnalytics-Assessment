USE adashi_staging;

SELECT *
FROM users_customuser;

SELECT *
FROM savings_savingsaccount;


WITH /*RECURSIVE dates AS ( -- First, a list of all months in the database
	SELECT date_format(MIN(u1.date_joined), '%Y-%m-01') AS t_month
    FROM users_customuser u1
    UNION ALL
	SELECT date_add(t_month, INTERVAL 1 MONTH)
    FROM dates
    WHERE date_add(t_month, INTERVAL 1 MONTH) <= (SELECT MAX(s.transaction_date) FROM savings_savingsaccount s)
), */
tenure AS ( -- Using the final available transaction date as the most recent date in the data
	SELECT 
		u.id as customer_id, 
		CONCAT(first_name, ' ', last_name) as name,
		timestampdiff(MONTH, u.date_joined, (SELECT MAX(transaction_date) FROM savings_savingsaccount)) AS 	tenure_months
	FROM users_customuser u
    ),
transactions AS (
	SELECT owner_id, COUNT(*) AS total_transactions, AVG(0.001*confirmed_amount) AS avg_ppt
	FROM savings_savingsaccount
	GROUP BY owner_id
    )
    
SELECT 
	customer_id,
    name,
    tenure_months,
    COALESCE(total_transactions, 0) AS total_transactions, -- Replace Null Transactions with zero transactions
	ROUND(COALESCE((total_transactions/tenure_months)*12*avg_ppt, 0),2) AS estimated_clv -- Replace Null CLV with zero value
FROM tenure te
LEFT JOIN transactions tr
ON te.customer_id = tr.owner_id
ORDER BY estimated_clv DESC;