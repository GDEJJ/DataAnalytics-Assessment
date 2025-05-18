WITH monthly_customer_transactions AS (
    -- Calculate transactions per customer per month
    SELECT
        s.owner_id,
        EXTRACT(YEAR FROM s.transaction_date) AS year,
        EXTRACT(MONTH FROM s.transaction_date) AS month,
        COUNT(*) AS transaction_count
    FROM
        savings_savingsaccount s
    WHERE
        s.transaction_date IS NOT NULL
    GROUP BY
        s.owner_id,
        EXTRACT(YEAR FROM s.transaction_date),
        EXTRACT(MONTH FROM s.transaction_date)
),
customer_avg_transactions AS (
    -- Calculate average transactions per month for each customer
    SELECT
        owner_id,
        AVG(transaction_count) AS avg_transactions_per_month
    FROM
        monthly_customer_transactions
    GROUP BY
        owner_id
),
categorized_customers AS (
    -- Categorize customers based on their average transactions
    SELECT
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        COUNT(*) AS customer_count,
        ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
    FROM
        customer_avg_transactions
    GROUP BY
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END
)

-- Final result
SELECT
    frequency_category,
    customer_count,
    avg_transactions_per_month
FROM
    categorized_customers
ORDER BY
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        WHEN frequency_category = 'Low Frequency' THEN 3
    END;