SELECT 
    s.plan_id,
    s.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE(), MAX(s.transaction_date)) AS inactivity_days
FROM 
    savings_savingsaccount s
JOIN 
    plans_plan p ON s.plan_id = p.id
WHERE 
    -- Remove the is_active check since that column doesn't exist
    (
        -- Find accounts where last transaction is older than 365 days
        (s.transaction_date IS NOT NULL AND s.transaction_date < DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY))
        OR 
        -- Or accounts with no transactions at all
        s.transaction_date IS NULL
    )
GROUP BY 
    s.plan_id,
    s.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END
HAVING 
    MAX(s.transaction_date) < DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)
    OR MAX(s.transaction_date) IS NULL
ORDER BY 
    inactivity_days DESC;