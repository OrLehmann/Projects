CAR_X Sales Analytics – BI Project

This Business Intelligence project analyzes sales data for CAR_X, a global automotive retailer. It involves designing a complete data pipeline — from building a Data Warehouse (DW) to performing ETL processes, data modeling, Power BI dashboarding, and deriving business insights.

Project Goals:

* Understand global sales performance by vehicle brand, country, and year

* Track customer behavior: returns, cancellations, repeat purchases

* Relate sales trends to population growth using external OECD data

* Improve decision-making via dynamic dashboards and calculated KPIs

Data Warehouse Architecture:
A normalized Snowflake Schema was implemented to ensure data integrity and support analytical queries.



Fact Table: Fact_Orders
Stores transaction-level sales data:

OrderID, QuantityOrdered, PriceEach, Sales, OrderDate, ProductCode, CustomerID, Status_ID, Location_ID



Derived metrics:

Sales = PriceEach * QuantityOrdered

SalesProp = Sales / TotalSales

CountOfOrders = COUNT(OrderID)



Dimension Tables:
Dim_Customers: Customer names, contact details, history (SCD Type 2)

Dim_Products: Product code, MSRP, manufacturer (SCD Type 1)

Dim_Manufacturer: Manufacturer ID and name (SCD Type 2)

Dim_Status: Status of order (e.g., Shipped, Cancelled)

Dim_Location: Country, city, year, population

Dim_Date: Full calendar dimension with year, month, quarter, etc.



Snowflake Schema Justification: 

* Enables normalized structure for high data integrity

* Scalable and hierarchical (e.g., products → manufacturers)

* SCD handling with Type 1 & Type 2 for temporal data tracking

* Optimized using de-normalization for fact-level efficiency in Power BI queries

ETL Process

1. Implemented using:

2. Excel as staging source

3. SQL Server as the Data Warehouse platform

4. Cleaned data with deduplication, type casting, and dimension table linking

5. External data from OECD Population Statistics integrated into Dim_Location

Power BI Dashboards - Uploaded data into Power BI and created:

* Dynamic date dimension via DAX

* Measures and KPIs including:

TotalSalesAmount, SalesGrowthRate, SalesPerCapita, % of Tesla Sales

ReturningCustomers, CancellationRate, Top5CustomersTotalOrders