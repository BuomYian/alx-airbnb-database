# 🌱 Seed the Database with Sample Data

## Objective

Populate the Airbnb-like database with realistic **sample data** to simulate production usage for testing and development.

---

## Directory

`alx-airbnb-database/database-script-0x02/`

- **seed.sql** — Contains SQL `INSERT` statements to populate all major tables.
- **README.md** — Documentation explaining the sample data generation and relationships.

---

## Tables Seeded

| Table          | Sample Data Count | Description                               |
| -------------- | ----------------: | ----------------------------------------- |
| **users**      |                 5 | Hosts, guests, and admin accounts         |
| **properties** |                 4 | Property listings owned by hosts          |
| **bookings**   |                 4 | Reservations linking users and properties |
| **payments**   |                 4 | Transactions associated with bookings     |
| **reviews**    |                 4 | Guest feedback on properties              |
| **messages**   |                 4 | Conversations between guests and hosts    |

---

## Highlights

- Uses **UUIDs** for all identifiers.
- Reflects **real-world relationships** (e.g., hosts own properties, guests make bookings).
- Data includes **confirmed, pending, and canceled bookings** for testing workflows.
- Sample messages simulate in-app communication.

---

## Execution

To seed your database, run the following command in PostgreSQL:

```bash
psql -U postgres -d airbnb_db -f seed.sql
```
