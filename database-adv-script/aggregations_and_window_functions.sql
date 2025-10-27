-- 1️⃣ Aggregation Query:
-- Find the total number of bookings made by each user

SELECT
    u.id AS user_id,
    u.name AS user_name,
    COUNT(b.id) AS total_bookings
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id
GROUP BY u.id, u.name
ORDER BY total_bookings DESC;


-- 2️⃣ Window Function Query:
-- Rank properties based on the total number of bookings they have received

WITH property_bookings AS (
    SELECT
        p.id AS property_id,
        p.title AS property_title,
        COUNT(b.id) AS total_bookings
    FROM properties p
    LEFT JOIN bookings b ON p.id = b.property_id
    GROUP BY p.id, p.title
)
SELECT
    property_id,
    property_title,
    total_bookings,
    RANK() OVER (ORDER BY total_bookings DESC) AS booking_rank
FROM property_bookings
ORDER BY booking_rank;
