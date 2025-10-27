-- 1️⃣ INNER JOIN: Retrieve all bookings and the respective users who made those bookings
SELECT
    b.id AS booking_id,
    u.name AS user_name,
    u.email,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price
FROM bookings b
INNER JOIN users u ON b.user_id = u.id;

-- 2️⃣ LEFT JOIN: Retrieve all properties and their reviews, including properties that have no reviews
SELECT
    p.id AS property_id,
    p.title AS property_title,
    p.location,
    r.rating,
    r.comment
FROM properties p
LEFT JOIN reviews r ON p.id = r.property_id
ORDER BY p.id;

-- 3️⃣ FULL OUTER JOIN: Retrieve all users and all bookings, even if the user has no booking or the booking has no user
-- ⚠️ Note: MySQL doesn’t natively support FULL OUTER JOIN — use UNION of LEFT and RIGHT joins
SELECT
    u.id AS user_id,
    u.name,
    b.id AS booking_id,
    b.property_id,
    b.start_date,
    b.total_price
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id

UNION

SELECT
    u.id AS user_id,
    u.name,
    b.id AS booking_id,
    b.property_id,
    b.start_date,
    b.total_price
FROM users u
RIGHT JOIN bookings b ON u.id = b.user_id
ORDER BY user_id;
