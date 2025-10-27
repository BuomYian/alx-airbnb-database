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

-- 📝 Explanation:
-- COUNT(b.id) aggregates the number of bookings per user.
-- LEFT JOIN ensures users with zero bookings are included.


-- 2️⃣ Window Function Query:
-- Rank properties based on the total number of bookings they have received

SELECT
    p.id AS property_id,
    p.title AS property_title,
    COUNT(b.id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.id) DESC) AS booking_rank
FROM properties p
LEFT JOIN bookings b ON p.id = b.property_id
GROUP BY p.id, p.title
ORDER BY booking_rank;

-- 📝 Explanation:
-- COUNT(b.id) counts total bookings per property.
-- RANK() assigns a rank — 1 for most booked property, higher numbers for less booked ones.
-- ORDER BY ensures the most popular properties appear first.
