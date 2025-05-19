USE adashi_staging;

SELECT *
FROM plans_plan;

SELECT *
FROM users_customuser;

SELECT *
FROM savings_savingsaccount;

-- First, Find customers with at least one savings plan
-- Difficulty #1: Finding which table signifies type of plan.
/* user_plan AS ( -- First, get a list of each plans and the customer tied to it
SELECT 
	p.id AS plan_id,
    p.owner_id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    p.amount AS amount,
    p.is_a_fund AS investment,
    p.is_regular_savings AS savings
FROM plans_plan p
LEFT JOIN users_customuser u
ON p.owner_id = u.id
ORDER BY owner_id, plan_id),
*/
WITH customers AS ( -- Get a list of the customers with their total savings and investments
SELECT 
	p.owner_id as owner_id, 
    CONCAT(u.first_name, ' ', u.last_name) AS name,
	SUM(p.is_a_fund) as investment_count, 
    SUM(p.is_regular_savings) AS savings_count,
    SUM(p.amount) AS amount
FROM plans_plan p
LEFT JOIN users_customuser u
ON p.owner_id = u.id
GROUP BY owner_id
HAVING sum(p.is_a_fund) > 0 AND sum(p.is_regular_savings) > 0
ORDER BY owner_id)

SELECT 
	c.owner_id, 
	name, 
    savings_count, 
    investment_count,
    (	-- Correlated subquery for the deposits
		SELECT SUM(confirmed_amount) 
		FROM savings_savingsaccount s 
        WHERE s.owner_id = c.owner_id
	)  AS total_deposits
FROM customers c
ORDER BY total_deposits;