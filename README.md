# Namma Yatri - Trips Analysis Dashboard | SQL + Power BI + Excel

This project presents a data analysis solution built for trip-level metrics using real-world structured data in Excel and SQL, visualized using an interactive Power BI dashboard.

It simulates a business scenario for Namma Yatri (a mobility platform), where key KPIs such as completed trips, driver earnings, conversion rate, and city-wise searches are tracked for better operational decision-making.

---

## 🔍 Project Overview

- 📁 **Data Source**: Excel files (multiple sheets for trips, payment, duration, etc.)
- 🧠 **Backend Processing**: SQL queries to filter, transform, and prepare data (joins, aggregations, CTEs)
- 📊 **Visualization Tool**: Microsoft Power BI
- 🧮 **Business Logic**: Conversion rate, fare vs duration, trip count by location

---

## 💡 Key Insights Delivered

- 🔸 **Driver earnings** totaled **₹751K+** with **983 completed trips**
- 🔸 **Conversion rate** stands at **45.49%** (Quotes vs Searches)
- 🔸 **Top performing areas** by trip count include Nelamangala and Shanti Nagar
- 🔸 **Clear trends** visible in duration, fare, and distance relationships
- 🔸 Geospatial data visualized to show trip concentration across locations

---

## 📈 Dashboard Features

- KPI Cards: Completed trips, searches, earnings, quotes, estimates
- Line Charts: Trips vs Duration, Fare vs Duration, Distance vs Duration
- Tables: Assembly-level search and quote breakdown
- Maps: Trip counts by assembly (location-level mapping)
- Slicers: Filter by location for drill-down analysis

---

## 🧠 SQL Concepts Used

- Joins across multiple tables (`trips`, `trip_details`, `payment`, `duration`)
- Aggregate functions for metrics (SUM, COUNT)
- Grouping by location and status
- Filtering for completed trips only
- Conversion calculation logic

---

## 🛠️ Tools & Technologies

| Tool       | Purpose                      |
|------------|-------------------------------|
| **SQL Server** | Data transformation and logic |
| **Power BI**   | Data visualization & dashboard |
| **Microsoft Excel** | Source data input (multiple sheets) |

---

## 📁 Repository Contents

| File Name                     | Description                         |
|------------------------------|-------------------------------------|
| `namma_yatri_dashboard.pbix` | Power BI dashboard project          |
| `trip_data.xlsx`             | Excel source data                   |
| `queries.sql`                | SQL logic used for transformation   |
| `dashboard_snapshot.png`     | Visual overview of the dashboard    |

---

## 👩‍💻 About Me

I’m an aspiring data analyst who loves combining SQL, Excel, and Power BI to solve real-world problems. This project demonstrates my end-to-end capability in transforming messy data into clean, business-ready insights.

---
