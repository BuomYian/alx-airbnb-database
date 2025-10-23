# 1. Normalize Your Database Design

## Objective

Apply normalization principles to ensure the Airbnb database schema is in the **Third Normal Form (3NF)**.

---

## Instructions

1. **Review your schema** and identify any potential redundancies or anomalies.
2. **Apply normalization rules** step by step — from **1NF → 2NF → 3NF**.
3. **Update your ER diagram or schema** if changes are required.
4. **Explain your normalization process** clearly in this file.

---

## Step-by-Step Normalization Process

### First Normal Form (1NF)

**Rule:**

- Each table cell should hold a single value (no repeating groups or arrays).
- Each record must be unique.

**Action Taken:**

- Ensured that all attributes contain **atomic values** (e.g., separated full names into `first_name` and `last_name`).
- Assigned **primary keys** to all entities (`user_id`, `property_id`, `booking_id`, etc.).
- Removed repeating or nested data (e.g., multiple property images stored as separate rows in an `Images` table).

**Result:**  
All tables now have atomic values and unique primary keys.

---

### Second Normal Form (2NF)

**Rule:**

- Must already be in 1NF.
- All non-key attributes must depend on the **entire primary key**, not part of it (eliminate partial dependency).

**Action Taken:**

- Moved attributes that depend only on part of a composite key to separate tables.
- Example: Separated `Booking` and `Payment` entities so that payment details depend only on `booking_id`, not on user or property IDs.

**Result:**  
All non-key attributes depend entirely on their table’s primary key.

---

### Third Normal Form (3NF)

**Rule:**

- Must already be in 2NF.
- There should be **no transitive dependencies** (non-key attributes should not depend on other non-key attributes).

**Action Taken:**

- Moved derived or dependent attributes to separate tables.
  - Example: Removed calculated fields like `total_price` from `Booking` (can be derived as `nights * price_per_night`).
- Ensured `User` roles (e.g., Host, Guest) are stored as categorical attributes instead of separate columns.

**Result:**  
Each non-key attribute depends only on the primary key, and there are no transitive dependencies.

---

## Final Normalized Tables (Simplified Overview)

| Table          | Primary Key   | Key Attributes                                                   |
| -------------- | ------------- | ---------------------------------------------------------------- |
| **Users**      | `user_id`     | `first_name`, `last_name`, `email`, `role`                       |
| **Properties** | `property_id` | `host_id`, `title`, `description`, `location`, `price_per_night` |
| **Bookings**   | `booking_id`  | `user_id`, `property_id`, `start_date`, `end_date`, `status`     |
| **Payments**   | `payment_id`  | `booking_id`, `amount`, `payment_date`, `method`, `status`       |
| **Reviews**    | `review_id`   | `user_id`, `property_id`, `rating`, `comment`                    |
| **Images**     | `image_id`    | `property_id`, `image_url`                                       |

---

## Summary

- The database is fully **normalized up to 3NF**.
- **Redundancy reduced**, **data integrity improved**, and **anomalies eliminated**.
- Schema is ready for implementation and indexing in a relational database.

---
