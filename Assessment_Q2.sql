USE adashi_staging;

SELECT *
FROM users_customuser;

SELECT *
FROM savings_savingsaccount;

SELECT 
	owner_id,
    u.date_joined AS first_month,
    MAX(s.transaction_date) AS last_month,
    COUNT(s.transaction_reference) as number_of_transactions
FROM savings_savingsaccount s
LEFT JOIN users_customuser u
ON u.id = s.owner_id;


WITH RECURSIVE dates AS ( -- First, a list of all months in the database
	SELECT date_format(MIN(u1.date_joined), '%Y-%m-01') AS t_month
    FROM users_customuser u1
    UNION ALL
	SELECT date_add(t_month, INTERVAL 1 MONTH)
    FROM dates
    WHERE date_add(t_month, INTERVAL 1 MONTH) <= (SELECT MAX(s.transaction_date) FROM savings_savingsaccount s)
),
tran_monthly AS ( 
-- Find the number of transactions each customer did in each month of their stay
-- 994 customers had no transactions, so we filter them out
	SELECT owner_id, t_month, COUNT(*) AS num_transactions 
	FROM savings_savingsaccount s
	LEFT JOIN dates d
	ON date_format(s.transaction_date, '%Y-%m-01') = d.t_month
	GROUP BY owner_id, t_month
),
cus_per_month AS ( -- Calculate the average monthly transaction for each customer
SELECT 
	owner_id,
    AVG(num_transactions) AS avg_tran,
    CASE 
		WHEN AVG(num_transactions) = 0 THEN 'No Transaction'
        WHEN AVG(num_transactions) < 3 THEN 'Low Frequency'
        WHEN AVG(num_transactions) < 10 THEN 'Medium Frequency'
        ELSE 'High Frequency' END AS frequency_category
FROM tran_monthly
GROUP BY owner_id
)
SELECT 
	frequency_category, 
    COUNT(owner_id) AS customer_count,
    AVG(avg_tran) AS avg_transactions_per_month
FROM cus_per_month
GROUP BY frequency_category;