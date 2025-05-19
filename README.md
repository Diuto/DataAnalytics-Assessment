# DataAnalytics-Assessment
SQL Proficiency Challenge for Cowrywise

## 1. Assessment_Q1: High-Value Customers with Multiple Products
In this exercise, we were tasked with finding all customers who have funded plans for both savings and investments.

**Approach:** The case study guide already referred to savings and investments as "is_regular_savings = 1" and "is_a_fund = 1" respectively. 
Hence, the steps taken were as follows:

- Use a CTE to get a list of owners, along with the number of savings and investment plans and filter out customers with either savings or  investments = 0.
- In the main query, use a correlated subquery to obtain the total deposits (in kobo) of each customer.

**Difficulty:** At first, it was difficult to follow just the two columns specified  as savings and investments. A lot of time was spent deciding if
"open_savings_plan" was to be considered, alongside "fixed_investments." In the end, I chose to go solely with the guide specifications.


## 2. Transaction Frequency Analysis
This exercise may have been a personal favourite here. Categorising the average number of transactions per customer per month.

**Approach:** The method used here involved categorising the months and performing the calculations based on that, then categorising the results.

- First, a recursive CTE was used to create a date table/list from the earliest date in the database (the first customer's join date) to the latest (the most recent transaction date.
- Use this CTE to join owner id and calculate the number of transactions that happen in a month for each customer.
- Find the monthly average number of transactions per customer and label the with High, Low, and Medium Frequency. "No Transaction" is added to catch errors on the category area.

**Difficulty:** About 994 customers had no transaction date. This number could cause a skew the results, hence, customers with No Transaction were filtered out.


## 3. Account Inactivity Alert
The requirement for this task was to retrieve a list of accounts with no cash inflow for over 365 days.

**Approach:** Since the question specified "investments and savings," everything else is labelled as an inactive account. All dates start from customer join date and end in the most recent transaction date in the database.

- First, a CTE with a subquery is created to obtain the owner as well as their most recent transaction date.
- Use a datediff function in the second cte to find the number of days since the most recent transaction by an account.
- Filter out all less than 365 days.

**Difficulty:** Classifying what could count as an active account was a little trickky. Eventually, all non-savings/non-investment accounts wwere futue referene.

## 4. Customer Lifetime Value (CLV) Estimation
Finding the  CLV simply involved calculating all the laid-out parameters before hand. It was done so:
- Calculate the number of months each customer has stayed since their signup.
- Calculate the total number of transactions each customer, as well as the profit per transaction, using "confirmed_amount*0.001."
- Finally, make use of the appropriate formula to control the CLV.
- Coalesce the customer transactions and estimated CLVs as well, to show zero in the event of a null.

**Difficulty:** N/A
