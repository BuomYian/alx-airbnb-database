# 🏙️ DataScape: Mastering Database Design

**A relational database system designed for an Airbnb-like application, focusing on scalability, normalization, and real-world functionality.**

---

## 📘 Overview

**DataScape: Mastering Database Design** is a comprehensive project developed as part of the **ALX Airbnb Database Module**.  
The project emphasizes designing, normalizing, and implementing a robust relational database that models real-world operations of an accommodation booking platform similar to Airbnb.

By completing this project, learners demonstrate their ability to:

- Model complex systems using ER diagrams
- Apply normalization up to **Third Normal Form (3NF)**
- Create optimized SQL schemas with **constraints, keys, and indexing**
- Seed the database with **realistic sample data**

---

## 🎯 Learning Objectives

This project helps you master the following key database design principles:

- **Advanced database modeling:** Crafting scalable and normalized schemas
- **Data normalization:** Eliminating redundancy and improving integrity
- **SQL DDL mastery:** Writing clean, optimized, and constraint-rich schema scripts
- **SQL DML practice:** Populating tables with realistic Airbnb-like data
- **Collaboration readiness:** Structuring repositories and documentation professionally

---

## 🧩 Project Structure

```

datascape-airbnb-database/
│
├── diagrams/
│ └── ERD.png # Entity Relationship Diagram (Draw.io or similar)
│
├── sql/
│ ├── 01_create_schema.sql # SQL DDL script – defines tables, keys, constraints
│ ├── 02_seed_data.sql # SQL DML script – inserts sample data
│ └── 03_indexes.sql # Additional indexing and optimization
│
├── docs/
│ ├── normalization.md # Explanation of normalization steps (up to 3NF)
│ └── design_decisions.md # Notes on design choices and constraints
│
└── README.md # Project documentation (this file)

```

---

## 🧠 Database Design Specification

### **Entities & Attributes**

#### 🧑 User

| Attribute     | Type                           | Constraint                |
| ------------- | ------------------------------ | ------------------------- |
| user_id       | UUID                           | Primary Key, Indexed      |
| first_name    | VARCHAR                        | NOT NULL                  |
| last_name     | VARCHAR                        | NOT NULL                  |
| email         | VARCHAR                        | UNIQUE, NOT NULL          |
| password_hash | VARCHAR                        | NOT NULL                  |
| phone_number  | VARCHAR                        | NULL                      |
| role          | ENUM('guest', 'host', 'admin') | NOT NULL                  |
| created_at    | TIMESTAMP                      | DEFAULT CURRENT_TIMESTAMP |

#### 🏡 Property

| Attribute     | Type      | Constraint                  |
| ------------- | --------- | --------------------------- |
| property_id   | UUID      | Primary Key, Indexed        |
| host_id       | UUID      | Foreign Key → User(user_id) |
| name          | VARCHAR   | NOT NULL                    |
| description   | TEXT      | NOT NULL                    |
| location      | VARCHAR   | NOT NULL                    |
| pricepernight | DECIMAL   | NOT NULL                    |
| created_at    | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP   |
| updated_at    | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP |

#### 📅 Booking

| Attribute   | Type                                     | Constraint                          |
| ----------- | ---------------------------------------- | ----------------------------------- |
| booking_id  | UUID                                     | Primary Key, Indexed                |
| property_id | UUID                                     | Foreign Key → Property(property_id) |
| user_id     | UUID                                     | Foreign Key → User(user_id)         |
| start_date  | DATE                                     | NOT NULL                            |
| end_date    | DATE                                     | NOT NULL                            |
| total_price | DECIMAL                                  | NOT NULL                            |
| status      | ENUM('pending', 'confirmed', 'canceled') | NOT NULL                            |
| created_at  | TIMESTAMP                                | DEFAULT CURRENT_TIMESTAMP           |

#### 💳 Payment

| Attribute      | Type                                    | Constraint                        |
| -------------- | --------------------------------------- | --------------------------------- |
| payment_id     | UUID                                    | Primary Key, Indexed              |
| booking_id     | UUID                                    | Foreign Key → Booking(booking_id) |
| amount         | DECIMAL                                 | NOT NULL                          |
| payment_date   | TIMESTAMP                               | DEFAULT CURRENT_TIMESTAMP         |
| payment_method | ENUM('credit_card', 'paypal', 'stripe') | NOT NULL                          |

#### 🌟 Review

| Attribute   | Type      | Constraint                               |
| ----------- | --------- | ---------------------------------------- |
| review_id   | UUID      | Primary Key, Indexed                     |
| property_id | UUID      | Foreign Key → Property(property_id)      |
| user_id     | UUID      | Foreign Key → User(user_id)              |
| rating      | INTEGER   | CHECK (rating BETWEEN 1 AND 5), NOT NULL |
| comment     | TEXT      | NOT NULL                                 |
| created_at  | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP                |

#### 💬 Message

| Attribute    | Type      | Constraint                  |
| ------------ | --------- | --------------------------- |
| message_id   | UUID      | Primary Key, Indexed        |
| sender_id    | UUID      | Foreign Key → User(user_id) |
| recipient_id | UUID      | Foreign Key → User(user_id) |
| message_body | TEXT      | NOT NULL                    |
| sent_at      | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP   |

---

## ⚙️ Constraints & Indexing

- **Primary Keys**: Automatically indexed
- **Unique**: `email` in the `User` table
- **Foreign Keys**: Properly reference parent tables with cascading rules
- **Check constraints**: Enforce valid `rating` and `status` values
- **Indexes**:
  - `email` in **User**
  - `property_id` in **Property** and **Booking**
  - `booking_id` in **Booking** and **Payment**

---

## 🧾 Normalization Summary

Each entity in this design has been normalized up to **Third Normal Form (3NF)**:

1. **1NF** – No repeating groups, atomic attributes
2. **2NF** – All non-key attributes depend fully on the primary key
3. **3NF** – No transitive dependencies

This ensures:

- Minimal data redundancy
- High consistency and integrity
- Optimized query performance

---

## 🧪 Setup & Usage

### **1. Clone the repository**

```bash
git clone https://github.com/your-username/datascape-airbnb-database.git
cd datascape-airbnb-database
```

### **2. Create the database**

```sql
CREATE DATABASE airbnb_db;
```

### **3. Run schema and seed scripts**

```bash
psql -U your_username -d airbnb_db -f sql/01_create_schema.sql
psql -U your_username -d airbnb_db -f sql/02_seed_data.sql
```

### **4. Verify**

Run queries to confirm relationships and data integrity:

```sql
SELECT * FROM users LIMIT 5;
SELECT * FROM properties LIMIT 5;
```

---

## 🧰 Tools Used

- **PostgreSQL / MySQL** (Relational Database)
- **Draw.io / Lucidchart** (ER Diagram Design)
- **Git & GitHub** (Version Control)
- **SQL DDL/DML** (Schema + Data Definition)

---

## 📄 License

This project is open-source and available under the **MIT License**.

```

```
