# 🗃️ Database Schema (DDL) — Airbnb Database

## 🎯 Objective

Define and create the **Airbnb database schema** using SQL DDL statements that adhere to normalization principles and relational integrity constraints.

---

## 📁 Directory

`alx-airbnb-database/database-script-0x01/`

- **schema.sql** — Contains all SQL `CREATE TABLE` statements, constraints, and indexes.
- **README.md** — Documentation explaining the database schema structure and rationale.

---

## 🧩 Database Overview

The database supports an **Airbnb-like platform**, consisting of the following entities:

| Entity         | Description                                         |
| -------------- | --------------------------------------------------- |
| **Users**      | Stores information about guests, hosts, and admins. |
| **Properties** | Represents listings created by hosts.               |
| **Bookings**   | Records user reservations for properties.           |
| **Payments**   | Tracks payments made for bookings.                  |
| **Reviews**    | Contains guest feedback and ratings for properties. |
| **Messages**   | Facilitates communication between users.            |

---

## ⚙️ Key Features

- **UUIDs** for all primary keys ensure global uniqueness.
- **Foreign keys** enforce referential integrity.
- **Constraints** ensure valid data input (CHECK, NOT NULL, UNIQUE).
- **Indexes** optimize query performance.
- **Timestamps** track record creation and updates.

---

## 🧠 Relationships Summary

| Relationship       | Type                                           |
| ------------------ | ---------------------------------------------- |
| User ↔ Property    | One-to-Many (`host_id`)                        |
| User ↔ Booking     | One-to-Many (`user_id`)                        |
| Property ↔ Booking | One-to-Many (`property_id`)                    |
| Booking ↔ Payment  | One-to-One (`booking_id`)                      |
| Property ↔ Review  | One-to-Many (`property_id`)                    |
| User ↔ Message     | Many-to-Many (via `sender_id`, `recipient_id`) |

---

## 🧱 Example Usage

To execute the schema in PostgreSQL:

```bash
psql -U postgres -d airbnb_db -f schema.sql
```
