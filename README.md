# 🍔 Location Intelligence for Limited-Service Restaurant Expansion in Texas

This project applies advanced SQL analytics on Safegraph’s real-world foot traffic and demographic data to identify the best locations for launching a new chain of late-night, limited-service restaurants in Texas. Using population, income, restaurant density, and visit patterns, we deliver actionable recommendations at the city and neighborhood (CBG) level.

---

## 📌 Problem Statement

A real estate investment firm wants to help a client open a successful chain of late-night limited-service restaurants (e.g., fast-casual, fast food) in Texas. The key challenge is to use data to pinpoint **where** new outlets will capture the most demand, targeting consumers aged 10–35 with incomes ≤ $75,000, and outmaneuvering the competition by focusing on underserved areas and late-night demand.

---

## 🎯 Objective

- Identify Texas counties with high target-age and target-income populations
- Find counties that are underserved (low restaurant density for the target group)
- Select the best city within that county for late-night dining popularity
- Provide business metrics (rent, property price, dwell time, visits) at the neighborhood (CBG) level to support site selection

---

## 🗂️ Dataset Overview

- **Safegraph visits:** Monthly foot traffic by place, hour, and location (Jan–Apr 2020)
- **Places data:** POI info (brand, category, coordinates, subcategory, etc.)
- **CBG Demographics:** US Census population, income, home value, rent at census block group (CBG) level
- **FIPS crosswalk:** County & state mapping for location analysis

---

## 🧹 Data Engineering & Exploration

- Joined and aggregated population, income, and restaurant POI data at county and CBG level
- Used CTEs and window functions to calculate percentiles and ranks for targeting and filtering
- Created a master SQL dataset (see `Master Dataset.sql`) for cross-table analytics

---

## 🧠 Research Questions & Methods

### 1️⃣ Which Texas counties have the highest share of target demographic (10–35 y/o, income ≤ $75K)?
- Used percentiles to select top 33% for both age and income.
- **Query Example:** Window functions, CTEs to filter counties (see Query Log).

### 2️⃣ Of these, which are *underserved* (lowest 33% of restaurants per capita)?
- Calculated LSR (Limited-Service Restaurant) density, identified counties with least supply.
- Selected the county with the largest target demographic.

### 3️⃣ In the top underserved county, which city is best for late-night demand (9pm–12am) and ≥10,000 population?
- Aggregated Safegraph hourly visit data to measure late-night popularity.
- Picked city with highest night-time restaurant traffic: **Pharr, TX**.

### 4️⃣ For each CBG in the chosen city, what are the key business metrics (rent, property value, dwell time, visits)?
- Combined restaurant visits and property data for each neighborhood.
- Provided average rent, home value, median dwell time, visitor counts for decision-making.

---

## 📈 Key Results & Insights

- **Target County:** Hidalgo County, TX (large, underserved, high target demo)
- **Best City:** Pharr, TX (top night-time restaurant traffic, >10,000 residents)
- **CBG-Level Metrics:** Supplied rent, property, and traffic details for site planning

**Recommendations:**
1. Launch first outlet in Pharr, Hidalgo County.
2. Use CBG-level metrics to pick an area with favorable rent/property costs and high traffic.
3. Emphasize late-night hours in marketing; data shows robust demand.
4. Framework is scalable—can be reapplied to other cities or states.

---

## 🧪 SQL Techniques & Libraries

- Google BigQuery SQL (CTEs, window functions, percentiles, joins)
- Data sources: Safegraph (visits, places), US Census, CBG crosswalks

---

## 📜 Example SQL Snippet

```sql
-- Find counties in top 33rd percentile for both age and income group
WITH cte_county_population AS (
    -- ...
)
SELECT * FROM ranked_data
WHERE population_10_35_percentile <= 0.33
  AND income_less_75_percentile <= 0.33;
