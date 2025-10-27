-- ============================================================================
-- ALX Airbnb Database Module: Aggregations and Window Functions
-- ============================================================================
-- This script demonstrates advanced SQL techniques for data analysis:
-- 1. Aggregation functions (COUNT, SUM) with GROUP BY
-- 2. Window functions (RANK, ROW_NUMBER) for ranking and analytics
-- ============================================================================

-- ============================================================================
-- 1️⃣ AGGREGATION QUERY: Total Bookings by User
-- ============================================================================
-- Objective: Find the total number of bookings made by each user
-- Uses: COUNT() aggregate function with GROUP BY clause
-- Purpose: Identify most active users and booking patterns
-- ============================================================================

SELECT
    u.id AS user_id,
    u.name AS user_name,
    u.email AS user_email,
    COUNT(b.id) AS total_bookings
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id
GROUP BY u.id, u.name, u.email
ORDER BY total_bookings DESC;

-- ============================================================================
-- 2️⃣ WINDOW FUNCTION QUERY: Rank Properties by Total Bookings
-- ============================================================================
-- Objective: Rank properties based on the total number of bookings received
-- Uses: RANK() window function with ORDER BY
-- Purpose: Identify most popular properties and booking performance
-- ============================================================================

WITH property_bookings AS (
    SELECT
        p.id AS property_id,
        p.title AS property_title,
        p.location AS property_location,
        COUNT(b.id) AS total_bookings
    FROM properties p
    LEFT JOIN bookings b ON p.id = b.property_id
    GROUP BY p.id, p.title, p.location
)
SELECT
    property_id,
    property_title,
    property_location,
    total_bookings,
    RANK() OVER (ORDER BY total_bookings DESC) AS booking_rank,
    ROW_NUMBER() OVER (ORDER BY total_bookings DESC) AS row_num
FROM property_bookings
ORDER BY booking_rank;

-- ============================================================================
-- 3️⃣ ADVANCED: User Booking Statistics with Window Functions
-- ============================================================================
-- Objective: Analyze user booking patterns with percentile ranking
-- Uses: PERCENT_RANK() and DENSE_RANK() window functions
-- Purpose: Understand booking distribution across users
-- ============================================================================

WITH user_booking_stats AS (
    SELECT
        u.id AS user_id,
        u.name AS user_name,
        COUNT(b.id) AS total_bookings,
        SUM(CASE WHEN b.status = 'completed' THEN 1 ELSE 0 END) AS completed_bookings,
        SUM(CASE WHEN b.status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_bookings
    FROM users u
    LEFT JOIN bookings b ON u.id = b.user_id
    GROUP BY u.id, u.name
)
SELECT
    user_id,
    user_name,
    total_bookings,
    completed_bookings,
    cancelled_bookings,
    DENSE_RANK() OVER (ORDER BY total_bookings DESC) AS booking_density_rank,
    PERCENT_RANK() OVER (ORDER BY total_bookings DESC) AS booking_percentile,
    ROUND(100 * PERCENT_RANK() OVER (ORDER BY total_bookings DESC), 2) AS percentile_score
FROM user_booking_stats
ORDER BY booking_density_rank;

-- ============================================================================
-- 4️⃣ ADVANCED: Property Performance with Cumulative Analysis
-- ============================================================================
-- Objective: Analyze property performance with cumulative booking counts
-- Uses: SUM() as window function for running totals
-- Purpose: Track cumulative booking performance over time
-- ============================================================================

WITH property_performance AS (
    SELECT
        p.id AS property_id,
        p.title AS property_title,
        COUNT(b.id) AS total_bookings,
        AVG(r.rating) AS avg_rating,
        COUNT(DISTINCT b.user_id) AS unique_guests
    FROM properties p
    LEFT JOIN bookings b ON p.id = b.property_id
    LEFT JOIN reviews r ON p.id = r.property_id
    GROUP BY p.id, p.title
)
SELECT
    property_id,
    property_title,
    total_bookings,
    ROUND(avg_rating, 2) AS avg_rating,
    unique_guests,
    RANK() OVER (ORDER BY total_bookings DESC) AS booking_rank,
    RANK() OVER (ORDER BY avg_rating DESC) AS rating_rank,
    SUM(total_bookings) OVER (ORDER BY total_bookings DESC) AS cumulative_bookings
FROM property_performance
ORDER BY booking_rank;
