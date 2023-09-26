use sakila;

-- 1. Create a view to summarize rental information for each customer
CREATE OR REPLACE VIEW customer_rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email AS email_address,
    COUNT(r.rental_id) AS rental_count
FROM
    customer c
LEFT JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id, customer_name, email_address;

-- 2. Create a Temporary Table to calculate total amount paid by each customer
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    crs.customer_id,
    SUM(p.amount) AS total_paid
FROM
    customer_rental_summary crs
LEFT JOIN
    payment p ON crs.customer_id = p.customer_id
GROUP BY
    crs.customer_id;

# Step 3: Create a CTE and the Customer Summary Report
# Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.
-- Create a CTE to join rental and payment summaries
WITH customer_summary_cte AS (
    SELECT
        crs.customer_id,
        crs.customer_name,
        crs.email_address,
        crs.rental_count,
        cps.total_paid
    FROM
        customer_rental_summary crs
    LEFT JOIN
        customer_payment_summary cps ON crs.customer_id = cps.customer_id
)

-- Generate the Customer Summary Report
SELECT
    customer_name,
    email_address,
    rental_count,
    total_paid
FROM
    customer_summary_cte
ORDER BY
    customer_name;


