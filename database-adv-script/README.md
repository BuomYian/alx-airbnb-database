# Advanced SQL Joins — Airbnb Database

This module explores advanced SQL join operations using the Airbnb schema.  
The goal is to extract meaningful insights from relationships between `users`, `properties`, `bookings`, and `reviews`.

## Files

- **joins_queries.sql** — Contains SQL queries using INNER JOIN, LEFT JOIN, and FULL OUTER JOIN.
- **README.md** — Overview of the queries and their objectives.

## Tables Used

- **users(id, name, email, created_at)**
- **properties(id, title, host_id, price_per_night, location)**
- **bookings(id, user_id, property_id, start_date, end_date, total_price)**
- **reviews(id, property_id, user_id, rating, comment, created_at)**

## Subqueries Practice

This section demonstrates the use of both correlated and non-correlated subqueries in SQL.

### Files

- **subqueries.sql** — Contains two subqueries:
  1. Non-correlated subquery to find properties with an average rating greater than 4.0.
  2. Correlated subquery to find users who have made more than 3 bookings.

### Concepts

- **Non-correlated subquery:** Executes independently and returns a result used by the outer query.
- **Correlated subquery:** Depends on the outer query; it runs once per row of the outer query.

## Aggregations and Window Functions

This section explores the use of SQL aggregate and window functions to analyze Airbnb data.

### Files

- **aggregations_and_window_functions.sql**
  - Query 1: Uses `COUNT` and `GROUP BY` to find the total number of bookings per user.
  - Query 2: Uses `RANK` window function to rank properties by the total number of bookings received.

### Concepts

- **Aggregate Functions:** Perform calculations on groups of rows (e.g., `COUNT`, `SUM`, `AVG`).
- **Window Functions:** Perform calculations across sets of rows related to the current row, without collapsing results into a single row.
