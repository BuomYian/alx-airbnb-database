-- ============================================================================
-- ALX Airbnb Database Module: Index Optimization
-- ============================================================================
-- This script creates strategic indexes to improve query performance
-- Indexes are created on high-usage columns identified in WHERE, JOIN, and ORDER BY clauses
-- ============================================================================

-- ============================================================================
-- ANALYSIS: High-Usage Columns Identified
-- ============================================================================
-- Based on query analysis, the following columns are frequently used:
--
-- BOOKINGS TABLE (Most Critical):
--   - bookings.user_id (used in JOINs and WHERE clauses)
--   - bookings.property_id (used in JOINs and WHERE clauses)
--   - bookings.status (used in WHERE clauses for filtering)
--   - bookings.id (used in COUNT aggregations)
--
-- USERS TABLE:
--   - users.id (used in JOINs as primary key)
--   - users.email (potential WHERE clause filtering)
--
-- PROPERTIES TABLE:
--   - properties.id (used in JOINs as primary key)
--   - properties.location (used in GROUP BY and filtering)
--
-- REVIEWS TABLE:
--   - reviews.property_id (used in JOINs)
--   - reviews.rating (used in aggregations and sorting)
-- ============================================================================

-- ============================================================================
-- 1️⃣ FOREIGN KEY INDEXES (Critical for JOIN Performance)
-- ============================================================================
-- These indexes dramatically improve JOIN operations by allowing the database
-- to quickly locate matching rows in related tables

-- Index on bookings.user_id for faster user-booking joins
CREATE INDEX idx_bookings_user_id ON bookings(user_id);

-- Index on bookings.property_id for faster property-booking joins
CREATE INDEX idx_bookings_property_id ON bookings(property_id);

-- Index on reviews.property_id for faster property-review joins
CREATE INDEX idx_reviews_property_id ON reviews(property_id);

-- ============================================================================
-- 2️⃣ FILTER COLUMN INDEXES (Critical for WHERE Clause Performance)
-- ============================================================================
-- These indexes improve performance of queries that filter by specific conditions

-- Index on bookings.status for filtering by booking status
CREATE INDEX idx_bookings_status ON bookings(status);

-- Index on users.email for user lookup by email
CREATE INDEX idx_users_email ON users(email);

-- Index on properties.location for location-based filtering
CREATE INDEX idx_properties_location ON properties(location);

-- ============================================================================
-- 3️⃣ COMPOSITE INDEXES (Optimized for Multi-Column Queries)
-- ============================================================================
-- Composite indexes improve performance when multiple columns are used together
-- in WHERE clauses or JOINs

-- Composite index for booking queries filtering by user and status
CREATE INDEX idx_bookings_user_status ON bookings(user_id, status);

-- Composite index for booking queries filtering by property and status
CREATE INDEX idx_bookings_property_status ON bookings(property_id, status);

-- Composite index for property queries with location and rating
CREATE INDEX idx_properties_location_id ON properties(location, id);

-- ============================================================================
-- 4️⃣ AGGREGATION COLUMN INDEXES (Optimized for GROUP BY and COUNT)
-- ============================================================================
-- These indexes improve performance of aggregation queries

-- Index on bookings.id for COUNT operations
CREATE INDEX idx_bookings_id ON bookings(id);

-- Index on reviews.rating for AVG and aggregation operations
CREATE INDEX idx_reviews_rating ON reviews(rating);

-- ============================================================================
-- 5️⃣ COVERING INDEXES (Advanced Optimization)
-- ============================================================================
-- Covering indexes include additional columns to allow index-only scans
-- This means the database doesn't need to access the main table

-- Covering index for user booking queries (includes name for SELECT)
CREATE INDEX idx_bookings_user_covering ON bookings(user_id) INCLUDE (id);

-- Covering index for property booking queries (includes title for SELECT)
CREATE INDEX idx_bookings_property_covering ON bookings(property_id) INCLUDE (id);

-- ============================================================================
-- PERFORMANCE MEASUREMENT: EXPLAIN ANALYZE
-- ============================================================================
-- These queries demonstrate the performance impact of indexes
-- Run these BEFORE creating indexes to see baseline performance
-- Then run them AFTER creating indexes to measure improvement
-- ============================================================================

-- ============================================================================
-- QUERY 1: User Booking Aggregation (Benefits from idx_bookings_user_id)
-- ============================================================================
-- BEFORE INDEX: Run this to see baseline performance
-- EXPLAIN ANALYZE
-- SELECT 
--     u.id,
--     u.name,
--     COUNT(b.id) as total_bookings
-- FROM users u
-- LEFT JOIN bookings b ON u.id = b.user_id
-- GROUP BY u.id, u.name
-- ORDER BY total_bookings DESC;

-- AFTER INDEX: Run this to see improved performance
EXPLAIN ANALYZE
SELECT 
    u.id,
    u.name,
    COUNT(b.id) as total_bookings
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id
GROUP BY u.id, u.name
ORDER BY total_bookings DESC;

-- ============================================================================
-- QUERY 2: Property Booking Status Filter (Benefits from idx_bookings_property_status)
-- ============================================================================
-- BEFORE INDEX: Run this to see baseline performance
-- EXPLAIN ANALYZE
-- SELECT 
--     p.id,
--     p.title,
--     COUNT(b.id) as total_bookings,
--     SUM(CASE WHEN b.status = 'completed' THEN 1 ELSE 0 END) as completed_bookings
-- FROM properties p
-- LEFT JOIN bookings b ON p.id = b.property_id
-- WHERE b.status IN ('completed', 'confirmed')
-- GROUP BY p.id, p.title
-- ORDER BY total_bookings DESC;

-- AFTER INDEX: Run this to see improved performance
EXPLAIN ANALYZE
SELECT 
    p.id,
    p.title,
    COUNT(b.id) as total_bookings,
    SUM(CASE WHEN b.status = 'completed' THEN 1 ELSE 0 END) as completed_bookings
FROM properties p
LEFT JOIN bookings b ON p.id = b.property_id
WHERE b.status IN ('completed', 'confirmed')
GROUP BY p.id, p.title
ORDER BY total_bookings DESC;

-- ============================================================================
-- QUERY 3: Location-Based Property Search (Benefits from idx_properties_location)
-- ============================================================================
-- BEFORE INDEX: Run this to see baseline performance
-- EXPLAIN ANALYZE
-- SELECT 
--     p.id,
--     p.title,
--     p.location,
--     COUNT(b.id) as booking_count,
--     AVG(r.rating) as avg_rating
-- FROM properties p
-- LEFT JOIN bookings b ON p.id = b.property_id
-- LEFT JOIN reviews r ON p.id = r.property_id
-- WHERE p.location = 'New York'
-- GROUP BY p.id, p.title, p.location
-- ORDER BY booking_count DESC;

-- AFTER INDEX: Run this to see improved performance
EXPLAIN ANALYZE
SELECT 
    p.id,
    p.title,
    p.location,
    COUNT(b.id) as booking_count,
    AVG(r.rating) as avg_rating
FROM properties p
LEFT JOIN bookings b ON p.id = b.property_id
LEFT JOIN reviews r ON p.id = r.property_id
WHERE p.location = 'New York'
GROUP BY p.id, p.title, p.location
ORDER BY booking_count DESC;

-- ============================================================================
-- QUERY 4: User Email Lookup (Benefits from idx_users_email)
-- ============================================================================
-- BEFORE INDEX: Run this to see baseline performance
-- EXPLAIN ANALYZE
-- SELECT 
--     u.id,
--     u.name,
--     u.email,
--     COUNT(b.id) as total_bookings
-- FROM users u
-- LEFT JOIN bookings b ON u.id = b.user_id
-- WHERE u.email = 'user@example.com'
-- GROUP BY u.id, u.name, u.email;

-- AFTER INDEX: Run this to see improved performance
EXPLAIN ANALYZE
SELECT 
    u.id,
    u.name,
    u.email,
    COUNT(b.id) as total_bookings
FROM users u
LEFT JOIN bookings b ON u.id = b.user_id
WHERE u.email = 'user@example.com'
GROUP BY u.id, u.name, u.email;

-- ============================================================================
-- QUERY 5: Property Review Aggregation (Benefits from idx_reviews_property_id, idx_reviews_rating)
-- ============================================================================
-- BEFORE INDEX: Run this to see baseline performance
-- EXPLAIN ANALYZE
-- SELECT 
--     p.id,
--     p.title,
--     COUNT(r.id) as review_count,
--     AVG(r.rating) as avg_rating,
--     MAX(r.rating) as max_rating,
--     MIN(r.rating) as min_rating
-- FROM properties p
-- LEFT JOIN reviews r ON p.id = r.property_id
-- GROUP BY p.id, p.title
-- HAVING COUNT(r.id) > 0
-- ORDER BY avg_rating DESC;

-- AFTER INDEX: Run this to see improved performance
EXPLAIN ANALYZE
SELECT 
    p.id,
    p.title,
    COUNT(r.id) as review_count,
    AVG(r.rating) as avg_rating,
    MAX(r.rating) as max_rating,
    MIN(r.rating) as min_rating
FROM properties p
LEFT JOIN reviews r ON p.id = r.property_id
GROUP BY p.id, p.title
HAVING COUNT(r.id) > 0
ORDER BY avg_rating DESC;

-- ============================================================================
-- PERFORMANCE ANALYSIS INSTRUCTIONS
-- ============================================================================
-- To measure performance improvement:
--
-- 1. BASELINE MEASUREMENT (Before Indexes):
--    - Comment out the CREATE INDEX statements below
--    - Uncomment the "BEFORE INDEX" EXPLAIN ANALYZE queries above
--    - Run each query and note the "Planning Time" and "Execution Time"
--    - Record the total rows scanned and execution plan
--
-- 2. CREATE INDEXES:
--    - Run all the CREATE INDEX statements below
--    - Wait for index creation to complete
--
-- 3. PERFORMANCE MEASUREMENT (After Indexes):
--    - Run the "AFTER INDEX" EXPLAIN ANALYZE queries above
--    - Compare the "Planning Time" and "Execution Time" with baseline
--    - Calculate the percentage improvement
--
-- 4. EXPECTED RESULTS:
--    - Query 1: 50-80% faster (JOIN optimization)
--    - Query 2: 60-90% faster (WHERE clause optimization)
--    - Query 3: 40-70% faster (Location filtering)
--    - Query 4: 70-95% faster (Email lookup)
--    - Query 5: 30-60% faster (Aggregation optimization)
-- ============================================================================

-- ============================================================================
-- INDEX MAINTENANCE QUERIES
-- ============================================================================
-- Use these queries to monitor and maintain indexes

-- View all indexes on the bookings table
-- SELECT * FROM information_schema.statistics WHERE table_name = 'bookings';

-- Check index size and usage statistics
-- SELECT index_name, seq_in_index, column_name FROM information_schema.statistics 
-- WHERE table_name = 'bookings' ORDER BY index_name, seq_in_index;

-- Rebuild fragmented indexes (if fragmentation > 10%)
-- ANALYZE TABLE bookings;
-- OPTIMIZE TABLE bookings;

-- ============================================================================
-- PERFORMANCE IMPACT SUMMARY
-- ============================================================================
-- Expected improvements after index creation:
--
-- 1. JOIN Operations: 50-80% faster (especially with foreign key indexes)
-- 2. WHERE Clause Filtering: 60-90% faster (with filter column indexes)
-- 3. GROUP BY Aggregations: 30-50% faster (with aggregation indexes)
-- 4. Overall Query Performance: 40-70% improvement on average
--
-- Trade-offs:
-- - Increased storage space (approximately 20-30% more disk usage)
-- - Slower INSERT/UPDATE/DELETE operations (indexes must be maintained)
-- - Requires periodic maintenance (ANALYZE, OPTIMIZE)
-- ============================================================================
