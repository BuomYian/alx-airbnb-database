# Task 0: Define Entities and Relationships in ER Diagram

## Objective

Create an **Entity-Relationship (ER) Diagram** for the **Airbnb-like database system**, based on the given specification.  
The diagram should clearly illustrate all entities, their attributes, and relationships — serving as the blueprint for database schema creation.

---

## Entities and Attributes

### 1. User

- **user_id** (PK, UUID)
- first_name (VARCHAR, NOT NULL)
- last_name (VARCHAR, NOT NULL)
- email (VARCHAR, UNIQUE, NOT NULL)
- password_hash (VARCHAR, NOT NULL)
- phone_number (VARCHAR, NULL)
- role (ENUM: guest, host, admin, NOT NULL)
- created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)

---

### 2. Property

- **property_id** (PK, UUID)
- host_id (FK → User.user_id)
- name (VARCHAR, NOT NULL)
- description (TEXT, NOT NULL)
- location (VARCHAR, NOT NULL)
- pricepernight (DECIMAL, NOT NULL)
- created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
- updated_at (TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP)

---

### 3. Booking

- **booking_id** (PK, UUID)
- property_id (FK → Property.property_id)
- user_id (FK → User.user_id)
- start_date (DATE, NOT NULL)
- end_date (DATE, NOT NULL)
- total_price (DECIMAL, NOT NULL)
- status (ENUM: pending, confirmed, canceled, NOT NULL)
- created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)

---

### 4. Payment

- **payment_id** (PK, UUID)
- booking_id (FK → Booking.booking_id)
- amount (DECIMAL, NOT NULL)
- payment_date (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
- payment_method (ENUM: credit_card, paypal, stripe, NOT NULL)

---

### 5. Review

- **review_id** (PK, UUID)
- property_id (FK → Property.property_id)
- user_id (FK → User.user_id)
- rating (INTEGER, CHECK: 1 ≤ rating ≤ 5)
- comment (TEXT, NOT NULL)
- created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)

---

### 6. Message

- **message_id** (PK, UUID)
- sender_id (FK → User.user_id)
- recipient_id (FK → User.user_id)
- message_body (TEXT, NOT NULL)
- sent_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)

---

## Relationships Summary

| Relationship                   | Type | Description                                   |
| ------------------------------ | ---- | --------------------------------------------- |
| **User – Property**            | 1:N  | One user (host) can list multiple properties. |
| **User – Booking**             | 1:N  | One user (guest) can make multiple bookings.  |
| **Property – Booking**         | 1:N  | A property can have many bookings.            |
| **Booking – Payment**          | 1:1  | Each booking has one payment record.          |
| **Property – Review**          | 1:N  | A property can have many reviews.             |
| **User – Review**              | 1:N  | A user can write multiple reviews.            |
| **User – Message (Sender)**    | 1:N  | A user can send many messages.                |
| **User – Message (Recipient)** | 1:N  | A user can receive many messages.             |

---

## ER Diagram Guidelines

When creating your ER diagram (using **Draw.io**, **Lucidchart**, or any ERD tool):

- Use **rectangles** for entities.
- Use **diamonds** or labeled connectors to represent relationships.
- Clearly indicate **primary keys (PK)** and **foreign keys (FK)**.
- Add **crow’s foot notation** to represent cardinality:
  - `1` → `N` (One-to-Many)
  - `1` → `1` (One-to-One)
- Ensure **attribute types** and **constraints** are included or referenced.

---

## File Structure

```

alx-airbnb-database/
│
└── ERD/
├── ERD.drawio # Editable ER diagram
├── ERD.png # Exported diagram image
└── requirements.md # This documentation file

```

---

## Deliverables

- A complete **ER diagram** (`ERD.drawio` or equivalent) showing all entities and relationships.
- This **requirements.md** file documenting attributes, keys, and relationships.

---

```

```
