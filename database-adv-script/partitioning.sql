-- ============================================================================
-- ALX Airbnb Database Module: Table Partitioning for Large Datasets
-- ============================================================================
-- This script implements partitioning on the Booking table based on start_date
-- Partitioning improves query performance on large datasets by dividing data
-- into smaller, more manageable chunks
-- ============================================================================

-- ============================================================================
-- 📋 PARTITIONING STRATEGY: Range Partitioning by start_date
-- ============================================================================
-- Objective: Partition the bookings table by start_date to improve performance
-- Method: Range partitioning with monthly partitions
-- Benefit: Queries filtering by date range will only scan relevant partitions
-- ============================================================================

-- ============================================================================
-- STEP 1: Create Partitioned Booking Table
-- ============================================================================
-- This creates a new partitioned table structure
-- Note: In production, you would migrate data from the existing table

CREATE TABLE bookings_partitioned (
    id INT NOT NULL,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id, start_date)
) PARTITION BY RANGE (YEAR(start_date), MONTH(start_date)) (
    PARTITION p_2023_01 VALUES LESS THAN (2023, 2),
    PARTITION p_2023_02 VALUES LESS THAN (2023, 3),
    PARTITION p_2023_03 VALUES LESS THAN (2023, 4),
    PARTITION p_2023_04 VALUES LESS THAN (2023, 5),
    PARTITION p_2023_05 VALUES LESS THAN (2023, 6),
    PARTITION p_2023_06 VALUES LESS THAN (2023, 7),
    PARTITION p_2023_07 VALUES LESS THAN (2023, 8),
    PARTITION p_2023_08 VALUES LESS THAN (2023, 9),
    PARTITION p_2023_09 VALUES LESS THAN (2023, 10),
    PARTITION p_2023_10 VALUES LESS THAN (2023, 11),
    PARTITION p_2023_11 VALUES LESS THAN (2023, 12),
    PARTITION p_2023_12 VALUES LESS THAN (2024, 1),
    PARTITION p_2024_01 VALUES LESS THAN (2024, 2),
    PARTITION p_2024_02 VALUES LESS THAN (2024, 3),
    PARTITION p_2024_03 VALUES LESS THAN (2024, 4),
    PARTITION p_2024_04 VALUES LESS THAN (2024, 5),
    PARTITION p_2024_05 VALUES LESS THAN (2024, 6),
    PARTITION p_2024_06 VALUES LESS THAN (2024, 7),
    PARTITION p_2024_07 VALUES LESS THAN (2024, 8),
    PARTITION p_2024_08 VALUES LESS THAN (2024, 9),
    PARTITION p_2024_09 VALUES LESS THAN (2024, 10),
    PARTITION p_2024_10 VALUES LESS THAN (2024, 11),
    PARTITION p_2024_11 VALUES LESS THAN (2024, 12),
    PARTITION p_2024_12 VALUES LESS THAN (2025, 1),
    PARTITION p_2025_01 VALUES LESS THAN (2025, 2),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- ============================================================================
-- STEP 2: Create Indexes on Partitioned Table
-- ============================================================================
-- These indexes improve query performance within each partition

CREATE INDEX idx_bookings_part_user_id ON bookings_partitioned(user_id);
CREATE INDEX idx_bookings_part_property_id ON bookings_partitioned(property_id);
CREATE INDEX idx_bookings_part_status ON bookings_partitioned(status);
CREATE INDEX idx_bookings_part_start_date ON bookings_partitioned(start_date);

-- ============================================================================
-- STEP 3: Migrate Data from Original Table to Partitioned Table
-- ============================================================================
-- This copies all data from the original bookings table to the partitioned table

INSERT INTO bookings_partitioned (id, user_id, property_id, start_date, end_date, status, created_at)
SELECT id, user_id, property_id, start_date, end_date, status, created_at
FROM bookings;

-- ============================================================================
-- STEP 4: Verify Partition Distribution
-- ============================================================================
-- Check how data is distributed across partitions

SELECT 
    PARTITION_NAME,
    PARTITION_EXPRESSION,
    PARTITION_DESCRIPTION,
    TABLE_ROWS,
    AVG_ROW_LENGTH,
    DATA_LENGTH
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_NAME = 'bookings_partitioned'
ORDER BY PARTITION_NAME;

-- ============================================================================
-- 🔍 PERFORMANCE TESTING: Queries on Partitioned Table
-- ============================================================================

-- ============================================================================
-- TEST 1: Query by Date Range (Partition Pruning)
-- ============================================================================
-- This query benefits from partition pruning - only scans relevant partitions
-- Expected: Only scans p_2024_06, p_2024_07, p_2024_08 partitions

EXPLAIN ANALYZE
SELECT 
    b.id,
    b.user_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.status,
    u.name,
    p.title
FROM bookings_partitioned b
INNER JOIN users u ON b.user_id = u.id
INNER JOIN properties p ON b.property_id = p.id
WHERE b.start_date >= '2024-06-01' AND b.start_date < '2024-09-01'
ORDER BY b.start_date DESC;

-- ============================================================================
-- TEST 2: Query by Specific Month (Single Partition)
-- ============================================================================
-- This query scans only one partition (p_2024_07)
-- Expected: Fastest performance due to minimal data scan

EXPLAIN ANALYZE
SELECT 
    b.id,
    b.user_id,
    b.property_id,
    b.start_date,
    b.status,
    COUNT(*) as booking_count
FROM bookings_partitioned b
WHERE b.start_date >= '2024-07-01' AND b.start_date < '2024-08-01'
GROUP BY b.id, b.user_id, b.property_id, b.start_date, b.status
ORDER BY b.start_date DESC;

-- ============================================================================
-- TEST 3: Query with Status Filter and Date Range
-- ============================================================================
-- Combines partition pruning with status filtering
-- Expected: Scans 3 partitions, filters by status within each

EXPLAIN ANALYZE
SELECT 
    b.id,
    b.user_id,
    b.property_id,
    b.start_date,
    b.status,
    u.name,
    p.title,
    p.location
FROM bookings_partitioned b
INNER JOIN users u ON b.user_id = u.id
INNER JOIN properties p ON b.property_id = p.id
WHERE b.start_date >= '2024-06-01' AND b.start_date < '2024-09-01'
  AND b.status = 'completed'
ORDER BY b.start_date DESC;

-- ============================================================================
-- TEST 4: Query Across Multiple Years
-- ============================================================================
-- Scans multiple year partitions
-- Expected: Scans p_2023_12, p_2024_01 through p_2024_12, p_2025_01

EXPLAIN ANALYZE
SELECT 
    YEAR(b.start_date) as year,
    MONTH(b.start_date) as month,
    COUNT(*) as total_bookings,
    SUM(CASE WHEN b.status = 'completed' THEN 1 ELSE 0 END) as completed,
    SUM(CASE WHEN b.status = 'cancelled' THEN 1 ELSE 0 END) as cancelled
FROM bookings_partitioned b
WHERE b.start_date >= '2023-12-01' AND b.start_date < '2025-02-01'
GROUP BY YEAR(b.start_date), MONTH(b.start_date)
ORDER BY year, month;

-- ============================================================================
-- TEST 5: Query Without Date Filter (Full Table Scan)
-- ============================================================================
-- This query scans all partitions (no partition pruning)
-- Expected: Slower than date-filtered queries

EXPLAIN ANALYZE
SELECT 
    b.id,
    b.user_id,
    b.property_id,
    b.start_date,
    b.status,
    COUNT(*) as booking_count
FROM bookings_partitioned b
WHERE b.status = 'completed'
GROUP BY b.id, b.user_id, b.property_id, b.start_date, b.status
ORDER BY b.start_date DESC
LIMIT 100;

-- ============================================================================
-- TEST 6: Aggregation Query with Date Range
-- ============================================================================
-- Aggregates bookings by property within a date range
-- Expected: Scans 3 partitions, aggregates results

EXPLAIN ANALYZE
SELECT 
    b.property_id,
    p.title,
    p.location,
    COUNT(b.id) as total_bookings,
    COUNT(DISTINCT b.user_id) as unique_guests,
    AVG(r.rating) as avg_rating
FROM bookings_partitioned b
INNER JOIN properties p ON b.property_id = p.id
LEFT JOIN reviews r ON p.id = r.property_id
WHERE b.start_date >= '2024-06-01' AND b.start_date < '2024-09-01'
GROUP BY b.property_id, p.title, p.location
ORDER BY total_bookings DESC
LIMIT 50;

-- ============================================================================
-- PARTITION MAINTENANCE QUERIES
-- ============================================================================

-- ============================================================================
-- Add New Partition for Future Dates
-- ============================================================================
-- Run this quarterly to add new partitions

ALTER TABLE bookings_partitioned
ADD PARTITION (PARTITION p_2025_02 VALUES LESS THAN (2025, 3));

-- ============================================================================
-- Drop Old Partition (Archive Old Data First)
-- ============================================================================
-- Run this annually to remove old partitions

-- ALTER TABLE bookings_partitioned
-- DROP PARTITION p_2023_01;

-- ============================================================================
-- Reorganize Partitions
-- ============================================================================
-- Optimize partition performance

ANALYZE TABLE bookings_partitioned;
OPTIMIZE TABLE bookings_partitioned;

-- ============================================================================
-- Check Partition Statistics
-- ============================================================================
-- View partition sizes and row counts

SELECT 
    PARTITION_NAME,
    TABLE_ROWS,
    DATA_LENGTH,
    INDEX_LENGTH,
    ROUND(DATA_LENGTH / 1024 / 1024, 2) as data_mb,
    ROUND(INDEX_LENGTH / 1024 / 1024, 2) as index_mb
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_NAME = 'bookings_partitioned'
  AND PARTITION_NAME IS NOT NULL
ORDER BY PARTITION_NAME;

-- ============================================================================
-- COMPARISON: Partitioned vs Non-Partitioned Query Performance
-- ============================================================================

-- Query on original (non-partitioned) table
-- EXPLAIN ANALYZE
-- SELECT * FROM bookings
-- WHERE start_date >= '2024-06-01' AND start_date < '2024-09-01'
-- ORDER BY start_date DESC;

-- Query on partitioned table (with partition pruning)
-- EXPLAIN ANALYZE
-- SELECT * FROM bookings_partitioned
-- WHERE start_date >= '2024-06-01' AND start_date < '2024-09-01'
-- ORDER BY start_date DESC;

-- ============================================================================
-- EXPECTED PERFORMANCE IMPROVEMENTS
-- ============================================================================
-- 
-- 1. Date Range Query (3 months):
--    - Non-partitioned: Scans 100% of data (~50,000 rows)
--    - Partitioned: Scans ~25% of data (~12,500 rows)
--    - Expected improvement: 60-75% faster
--
-- 2. Single Month Query:
--    - Non-partitioned: Scans 100% of data (~50,000 rows)
--    - Partitioned: Scans ~8% of data (~4,000 rows)
--    - Expected improvement: 85-92% faster
--
-- 3. Full Table Scan (no date filter):
--    - Non-partitioned: Scans 100% of data
--    - Partitioned: Scans 100% of data (no benefit)
--    - Expected improvement: 0% (same performance)
--
-- 4. Aggregation with Date Range:
--    - Non-partitioned: Scans 100% of data
--    - Partitioned: Scans ~25% of data
--    - Expected improvement: 60-75% faster
--
-- ============================================================================
