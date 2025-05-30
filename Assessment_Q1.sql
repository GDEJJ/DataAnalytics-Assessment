SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.id END) AS savings_count, -- for each row where condition matches, return the rows savings id because it is unique for each savings account
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.id END) AS investment_count, -- for each row where condition matches, return the rows savings id because it is unique for each investment account
    SUM(s.confirmed_amount) AS total_deposits -- sums all confirmed amount values for each users account
FROM 
    users_customuser u
JOIN 
    savings_savingsaccount s ON u.id = s.owner_id
JOIN 
    plans_plan p ON s.plan_id = p.id
WHERE 
    s.confirmed_amount > 0
GROUP BY 
    u.id, u.first_name, u.last_name
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.id END) > 0 
    AND 
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.id END) > 0 -- filters the resulting groupings to include only users with at least one savings plan and one investment plan
ORDER BY 
    total_deposits DESC;