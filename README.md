# TechStop-Database

**SQL Server database schema for a small business inventory and sales system**, designed for future integration with a .NET web application.  
This database models products, suppliers, customers, employees, orders, and order items.

---

## Features

- Normalized relational schema with foreign keys
- Support for inventory tracking, customer orders, and supplier management
- Unique constraints and indexes for data integrity
- Ready for future expansion (e.g., triggers, stored procedures, reporting)

---

## Prerequisites

- SQL Server 2019+ (or Azure SQL)
- SQL Server Management Studio (SSMS) 19+

---

## Project Structure

docs/
TechStop.png # ERD image
TechStop_DB_ERD.pdf # ERD PDF
TechStop.dbml # dbdiagram.io source
sql/
01_create_database.sql
02_create_tables.sql
03_insert_sample_data.sql # (ongoing)
04_create_indexes.sql # (coming soon)

## Setup / How to Run

### Azure SQL Database Setup

1. **Create Azure Resources:**

   - Create an Azure SQL Server and Database
   - Note your connection details

2. **Connect SSMS to Azure:**

   - Server: `your-server.database.windows.net`
   - Authentication: SQL Server Authentication
   - Connect directly to your target database

3. **Run Scripts:**
   - Skip `01_create_database.sql` (database created in Azure portal)
   - Run `02_create_tables.sql`
   - Run `03_insert_sample_data.sql`

### Local Development Setup Requires SQL Server + SSMS.

1. Run scripts in order from the `/sql` folder:

   - `01_create_database.sql`
   - `02_create_tables.sql`

2. ER Diagram
   ![ER Diagram](docs/TechStop.png)

3. Schema source (dbdiagram)
   See [`docs/TechStop.dbml`](docs/TechStop.dbml).

## Current Status

- [x] Database created (`TechStop`)
- [x] Core tables created (Supplier, Product, Customer, Employee, CustomerOrder, OrderItem)
- [x] Sample data
- [ ] Indexes
- [ ] Views / Stored Procedures / Triggers

## Notes

- Money fields use `DECIMAL(10,2)`.
- `CustomerOrder` & `OrderItem` names avoid T-SQL reserved words.

## License

This project is licensed under the [MIT License](LICENSE).
