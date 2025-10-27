-- 1️⃣ Non-Correlated Subquery:
-- Find all properties where the average rating is greater than 4.0

SELECT
    p.id AS property_id,
    p.title AS property_title,
    p.location,
    p.price_per_night
FROM properties p
WHERE p.id IN (
    SELECT property_id
    FROM reviews
    GROUP BY property_id
    HAVING AVG(rating) > 4.0
)
ORDER BY p.id;

-- 📝 Explanation:
-- The inner query calculates the average rating for each property.
-- The outer query selects property details for those with average rating > 4.0.


-- 2️⃣ Correlated Subquery:
-- Find users who have made more than 3 bookings

SELECT
    u.id AS user_id,
    u.name AS user_name,
    u.email
FROM users u
WHERE (
    SELECT COUNT(*)
    FROM bookings b
    WHERE b.user_id = u.id
) > 3
ORDER BY u.id;

-- 📝 Explanation:
-- The inner query counts bookings for each user (correlated with the outer query).
-- The outer query filters only users with more than 3 bookings.
