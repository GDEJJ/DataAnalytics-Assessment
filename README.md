# DataAnalytics-Assessment
Cowrywise Data Analytics Assessment

## Question 1
The goal is write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

### Approach
First, I use the `SELECT` statement to retrieve the user’s ID and full name by selecting data from the `users_customuser` table. Next, I join this table with the `savings_savingsaccount` table to link users to their accounts, and with the `plans_plan` table to identify whether each account is a savings or investment account.

For each user, I calculate the number of unique savings accounts using a conditional count where the `is_regular_savings` flag is true and the number of unique investment accounts using a similar conditional count for the `is_a_fund` flag. I also calculate the total confirmed deposits by summing the `confirmed_amount` field for all accounts with positive values, as specified in the `WHERE` clause.

I group the results by each user’s ID and name to ensure that calculations are performed per user. A `HAVING` clause filters the results to include only users who have at least one savings account and one investment account. Finally, I sort the data in descending order by the total deposit amount, prioritizing users with the highest deposits.


## Question 2
The goal is to calculate the average number of transactions per customer per month and categorize them.

### Approach
The first step, represented by the monthly_customer_transactions CTE, calculates the total number of transactions made by each customer for every month. It extracts the year and month from the transaction_date column and groups the data by the customer’s owner_id and the extracted year and month. A COUNT(*) is used to calculate the total transactions per customer per month.
The second step, implemented in the customer_avg_transactions CTE, calculates the average number of transactions per month for each customer. Using the data from the first step, it groups the transactions by owner_id and computes the average of the monthly transaction counts using the AVG(transaction_count) function. This provides each customer’s average transaction frequency across all months.
In the categorized_customers CTE, customers are categorized based on their average monthly transaction frequency:

Customers with 10 or more average monthly transactions are labeled as "High Frequency."
Customers with an average of 3 to 9 transactions are labeled as "Medium Frequency."
Customers with fewer than 3 average monthly transactions are labeled as "Low Frequency."
The CASE statement is used to assign these categories. It also calculates the total number of customers in each category (COUNT(*)), and the rounded average of their monthly transactions (ROUND(AVG(avg_transactions_per_month), 1)).
The final SELECT statement retrieves the frequency categories along with the number of customers (customer_count) and their average monthly transactions (avg_transactions_per_month). The results are ordered by category in descending frequency priority: "High Frequency," "Medium Frequency," and "Low Frequency." This ordering is achieved using a CASE statement in the ORDER BY clause.

## Question 3
The goal is to find all active accounts (savings or investments) with no transactions in the last 1 year (365 days).

### Approach
The query starts by selecting the plan_id and owner_id of each account from the savings_savingsaccount table. These fields help uniquely identify each account and its owner. A CASE statement is used to assign each account a type based on its plan e.g If the plan is marked as is_regular_savings, the account is categorized as "Savings.", If the plan is marked as is_a_fund, the account is categorized as "Investment." etc. The MAX(s.transaction_date) function retrieves the most recent transaction date for each account. This indicates the last activity on the account.
The inactivity period calculates the number of days since the last transaction using the DATEDIFF(CURRENT_DATE(), MAX(s.transaction_date)) function. For accounts without any transactions (transaction_date IS NULL), the MAX function ensures they are also included in the analysis.
The result is then filtered for inactive accounts (Accounts with a transaction_date older than 365 days are flagged as inactive...) using the WHERE clause.
The result is grouped by plan_id, owner_id, and the categorized type to ensure calculations are specific to each account. This prevents overlapping results between accounts. 
The HAVING clause refines the grouped results to include only accounts meeting the inactivity criteria of Last transaction date is older than 365 days, No transaction date exists. 
Result is sorted by inactivity_days in descending.

## Question 4
The goal is to estimate CLV based on account tenure and transaction volume (simplified model). For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate Account tenure, total transactions, estimated CLV.

### Approach

I select each user’s unique ID as customer_id and their full name by combining their first and last names. Next, I determine how long each user has been a customer by calculating their tenure in months. This is achieved by measuring the time between their signup date (date_joined) and the current date. This tenure value is essential for understanding customer engagement over time. To measure activity, I count the total number of transactions each user has made, ensuring that only valid transactions with a positive confirmed amount are included.
sing this data, I estimate the Customer Lifetime Value by calculating the average monthly transaction rate, annualizing it, and then multiplying it by the average transaction value. This gives an estimated yearly contribution from each customer, scaled and rounded to two decimal places for readability.
Transactions with invalid dates or zero amounts are filtered out and users with a tenure of less than one month are excluded. Additionally, only customers with at least one transaction are included in the final results.

The data is grouped by each customer to calculate their aggregated metrics like total transactions and estimated CLV. Finally, the results are sorted by the estimated CLV in descending order, highlighting the customers with the highest lifetime value at the top.
