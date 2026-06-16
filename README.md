# 🍔 Burger Franchise End-to-End SQL Analytics & Revenue Optimization Pipeline

Welcome to my portfolio! This project showcases the development, cleaning, and optimization of a relational database for a fast-casual burger franchise. Using **MySQL Engine 8.0**, I transformed raw, unstandardized transactional data into executive-level business intelligence by executing a strict diagnostic matrix.

---

## 🛠️ Technical Stack & Frameworks
* **Database Engine:** MySQL Server
* **Interface Layer:** MySQL Workbench
* **Advanced SQL Concepts:** Data Normalization, Type Standardization, Multi-Table JOIN Operations, Aggregations, Conditional Logic (`CASE WHEN`), Window Functions (`LAG()`, `DENSE_RANK()`, `CUME_DIST()`).

---

## 🧽 Phase 1: Advanced Data Hygiene & Integrity Pipeline
To ensure absolute accuracy for business metrics, I designed a multi-step cleaning script to audit and standardize all tables before analysis:

* **Stray Space & Missing Value Filtering:** Implemented deep structural checks across `customers`, `orders`, `order_items`, `products`, and `waiters` tables using `LENGTH(TRIM())` and `IS NULL` filters.
* **String Standardization:** Grouped and cleaned irregular text anomalies across the string layers.
* **Schema Evolution:** Altered structural data columns using `ALTER TABLE` and `MODIFY COLUMN` constraints to convert data layers smoothly into native `DATE` and `DATETIME` formats.

---

## 📈 Phase 2: Core Analytical Matrix (Business Deep-Dive)

The analytics engine processes raw business data through specialized thematic areas to surface maximum financial value:

### 1. High-Level Performance Tracking (KPIs)
* **Volume Metrics:** Modeled gross order volume tracking over historical timelines.
* **Financial Baseline:** Calculated absolute franchise earnings (`SUM(quantity * price)`) across complex item associations.

### 2. Menu Intelligence & Pricing Optimization
* **Demand vs. Value Discovery:** Isolated high-volume products (like *Loaded Fries*) and contrasted them against high-revenue products (*Double Patty* and *Beef Burgers*) to pinpoint pricing inefficiencies.
* **Pareto Analysis (The 80/20 Rule):** Used the advanced `CUME_DIST()` window function to identify the top 20% of products driving the franchise's entire financial core.
* **Market Basket Analysis:** Built a multi-join self-referencing relationship framework to uncover underlying consumer purchase combinations (e.g., *Zinger Burger + Loaded Fries*).

### 3. Operational Performance & Logistics Analytics
* **Peak Hour Bottleneck Mapping:** Isolated order behaviors across strict lunch (12 PM–3 PM) and dinner (6 PM–10 PM) time ranges to optimize kitchen staffing.
* **Hourly Velocity Tracking:** Modeled strict hourly order density charts using `HOUR()` extractions.
* **Payment Architecture Preference Mapping:** Computed conditional percentages across geographic markets using `COUNT(*)` over partitioned city matrices.

### 4. Advanced Customer Lifetime Value (CLV) Modelling
* **VIP Customer Segmentation:** Identified highly active buyers with greater than 5 orders to lay the groundwork for direct retention campaigns.
* **7-Day Retention Churn Metric:** Built a dual-table comparison to isolate repeat behaviors within a tight 7-day conversion window.
* **Lifespan Duration Mapping:** Computed the exact metric average of customer active windows using `DATEDIFF()` between original and recent orders.

### 5. Staff Output & Revenue Attribution
* **Upselling Performance Audit:** Attributed total order revenue generation directly to employee IDs using multi-layered group models, successfully isolating top performers from floor staff needing training.

### 6. Seasonality & Cash Flow Stability Analysis
* **Month-Over-Month (MoM) Growth Analytics:** Leveraged the `LAG()` analytical window function to calculate absolute revenue gains and drops across consecutive months, safeguarding the business against seasonal cash crunches.

---

## 🚀 Key Business Takeaways Delivered by This Project
1. **Uncovered Hidden Combos:** Discovered standalone menu items frequently ordered together, allowing the client to package them into high-margin official menu combos.
2. **Staff Optimization Insights:** Mapped clear labor cost savings by identifying low-volume hours (Sundays) and high-volume rushes (10 AM and 7 PM) to better schedule staff.
3. **Menu Pricing Adjustments:** Identified high-demand products that were priced too low, opening up opportunities for strategic price increases without losing customer loyalty.

---
💡 *This portfolio project showcases a complete bridge between technical database execution and real-world business value optimization.*
