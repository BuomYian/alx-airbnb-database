-- ============================================================
-- Airbnb Database Sample Data Seeder
-- Author: Buomkuoth Makuach
-- Project: DataScape - Mastering Database Design
-- Repository: alx-airbnb-database
-- ============================================================

-- Ensure the UUID extension is enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========================
-- 1. Insert Users
-- ========================
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
(uuid_generate_v4(), 'Alice', 'Johnson', 'alice.johnson@example.com', 'hashed_password_1', '+211912345678', 'guest'),
(uuid_generate_v4(), 'Michael', 'Brown', 'michael.brown@example.com', 'hashed_password_2', '+211923456789', 'host'),
(uuid_generate_v4(), 'Sarah', 'Lee', 'sarah.lee@example.com', 'hashed_password_3', '+211934567890', 'guest'),
(uuid_generate_v4(), 'James', 'Kim', 'james.kim@example.com', 'hashed_password_4', '+211945678901', 'host'),
(uuid_generate_v4(), 'Admin', 'User', 'admin@example.com', 'hashed_admin_pass', NULL, 'admin');

-- ========================
-- 2. Insert Properties
-- ========================
INSERT INTO properties (property_id, host_id, name, description, location, price_per_night)
SELECT
uuid_generate_v4(),
u.user_id,
p.name,
p.description,
p.location,
p.price_per_night
FROM users u
JOIN (VALUES
('Lakeview Cottage', 'A serene lakeside cottage perfect for relaxation.', 'Juba, South Sudan', 85.00),
('Downtown Apartment', 'A modern 2-bedroom apartment near city center.', 'Nairobi, Kenya', 120.00),
('Beach House', 'Oceanfront house with private access to the beach.', 'Mombasa, Kenya', 150.00),
('Mountain Cabin', 'Cozy cabin surrounded by nature and trails.', 'Addis Ababa, Ethiopia', 95.00)
) AS p(name, description, location, price_per_night)
ON TRUE
WHERE u.role = 'host'
LIMIT 4;

-- ========================
-- 3. Insert Bookings
-- ========================
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status)
SELECT
uuid_generate_v4(),
p.property_id,
u.user_id,
b.start_date,
b.end_date,
b.total_price,
b.status
FROM users u
JOIN properties p ON p.host_id <> u.user_id
JOIN (VALUES
('2025-11-10', '2025-11-14', 340.00, 'confirmed'),
('2025-12-01', '2025-12-05', 480.00, 'pending'),
('2025-12-20', '2025-12-25', 600.00, 'confirmed'),
('2026-01-10', '2026-01-15', 475.00, 'canceled')
) AS b(start_date, end_date, total_price, status)
ON TRUE
WHERE u.role = 'guest'
LIMIT 4;

-- ========================
-- 4. Insert Payments
-- ========================
INSERT INTO payments (payment_id, booking_id, amount, payment_method)
SELECT
uuid_generate_v4(),
b.booking_id,
b.total_price,
pm.method
FROM bookings b
JOIN (VALUES
('credit_card'),
('paypal'),
('stripe'),
('credit_card')
) AS pm(method)
ON TRUE
LIMIT 4;

-- ========================
-- 5. Insert Reviews
-- ========================
INSERT INTO reviews (review_id, property_id, user_id, rating, comment)
SELECT
uuid_generate_v4(),
p.property_id,
u.user_id,
r.rating,
r.comment
FROM users u
JOIN properties p ON p.host_id <> u.user_id
JOIN (VALUES
(5, 'Amazing place with great views!'),
(4, 'Very comfortable stay, would recommend.'),
(3, 'Good value for money, but could be cleaner.'),
(5, 'Outstanding hospitality and location!')
) AS r(rating, comment)
ON TRUE
WHERE u.role = 'guest'
LIMIT 4;

-- ========================
-- 6. Insert Messages
-- ========================
INSERT INTO messages (message_id, sender_id, recipient_id, message_body)
SELECT
uuid_generate_v4(),
s.user_id,
r.user_id,
m.body
FROM users s
CROSS JOIN users r
JOIN (VALUES
('Hi! Is your property available next weekend?'),
('Yes, it is available. Would you like to book?'),
('Sure, please confirm my reservation.'),
('Thank you! Looking forward to hosting you.')
) AS m(body)
WHERE s.role = 'guest' AND r.role = 'host'
LIMIT 4;

-- ========================
-- ✅ Seeding Complete
-- ========================