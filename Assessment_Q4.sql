SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    -- Calculate tenure in months from signup date to current date
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) AS tenure_months,
    -- Count total transactions
    COUNT(s.id) AS total_transactions,
    -- Calculate estimated CLV
    ROUND(
        (COUNT(s.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE())) * 12 * 
        (SUM(s.confirmed_amount) * 0.001 / COUNT(s.id)),
        2
    ) AS estimated_clv
FROM 
    users_customuser u
LEFT JOIN 
    savings_savingsaccount s ON u.id = s.owner_id
WHERE 
    -- Ensure we have valid transaction data
    s.transaction_date IS NOT NULL
    AND s.confirmed_amount > 0
    -- Ensure the user has been a customer for at least 1 month
    AND TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) > 0
GROUP BY 
    u.id, 
    u.first_name, 
    u.last_name,
    u.date_joined
HAVING 
    -- Ensure we have at least one transaction
    COUNT(s.id) > 0
ORDER BY 
    estimated_clv DESC;