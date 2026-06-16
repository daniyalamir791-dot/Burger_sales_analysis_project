CREATE DATABASE IF NOT EXISTS burger_project;
USE burger_project;

-- Data clearning phase 
-- Finding null values or empty spaces 

SELECT *
FROM customers
WHERE customer_id IS NULL
OR customer_name IS NULL
OR LENGTH(TRIM(customer_name)) = 0
OR gender IS NULL
OR LENGTH(TRIM(gender)) = 0
OR city IS NULL
OR LENGTH(TRIM(city)) = 0
OR signup_date IS NULL;

SELECT *
FROM orders
WHERE order_id IS NULL
OR customer_id IS NULL
OR order_date IS NULL
OR payment_method IS NULL
OR LENGTH(TRIM(payment_method)) = 0
OR delivery_type IS NULL
OR LENGTH(TRIM(delivery_type)) = 0
OR waiter_id IS NULL
OR status IS NULL
OR LENGTH(TRIM(status)) = 0;

SELECT *
FROM order_items
WHERE order_item_id IS NULL
OR order_id IS NULL
OR product_id IS NULL
OR quantity IS NULL;

SELECT *
FROM products
WHERE product_id IS NULL
OR product_name IS NULL
OR LENGTH(TRIM(product_name)) = 0
OR category IS NULL
OR LENGTH(TRIM(category)) = 0
OR price IS NULL
OR rating IS NULL;

SELECT *
FROM waiters
WHERE waiter_id IS NULL
OR waiter_name IS NULL
OR LENGTH(TRIM(waiter_name)) = 0;

-- this query is for making a separate group where the customer_names are not normal 

UPDATE customers
SET customer_name = 'Unknown Customer'
WHERE customer_name LIKE 'Customer_%';

-- for finding unstandardized column texts 

SELECT DISTINCT
customer_name,
gender,
city,
signup_date
FROM customers;

-- converting text to date format of signup_date column 

-- Columns are already in standard date/datetime formats
ALTER TABLE customers MODIFY COLUMN signup_date DATE;
ALTER TABLE orders MODIFY COLUMN order_date DATETIME;

-- Data analysis phase 

-- business questions
-- question 1 How many total orders did the restaurant receive?
SELECT COUNT(*) AS total_orders
FROM orders;
-- business problem:so the business was unawared about the total orders they had.
-- business impact: so now the business can track an important metric of their business and take decisions on the basis of this kpi 

-- question 2 :How much money did the restaurant earn?
SELECT SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;
-- business problem : was unawared about the total revenue their business was making now this will help the business to take decisons for improving business decisions regarding to total revenue 
-- business impact : now this will help the business to take decisons for improving business decisions regarding to total revenue 
-- the total revenue is around '8978700'

-- business question 3 
-- Which are the top 5 high ordered products?
SELECT p.product_name,
       SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 5;
-- business problem : the business was unawared about  which product of their restruant is most demanding 
-- business impact: loaded fries are the most demanding product even though they are not in the top 5 higest revenue generating products this is an insight that there is a pricing issue while double patty burger and beef burger were the most highest revenue generating products but are not much ordered this can also be a pricing  issue indicating that may be the price of loaded fries is very low that is it is not generating much revneu and the price of the double patty and beef burger too high thats why it is less ordered

-- question 4  :
-- Which are the top 5 products that are  making  the most money?
SELECT p.product_name,
       SUM(oi.quantity * p.price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;
-- business problem : the restraunt was unawared that which products were the most money making 
-- business impact : Business can take decisions to increase the number of orders of the most high generating products like double patty burger which is the highest revenue generating product and beef burger while to improve the pricing issue that are at demanding but are generating low revenue like loaded fries 

-- question 5: How much does a customer spend per order?
SELECT AVG(order_total) AS avg_order_value
FROM (
    SELECT o.order_id,
           SUM(oi.quantity * p.price) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY o.order_id
) t;
-- business problem: the business was anwared that on how much average an existing customers spends per order
-- business impact: business can take measures to improve average order value by making such deals and offers that the exisiting customers prefers buying from their restraunt without needing much nuew customers. business can run sucessfully 

-- question 6 
-- how many number of orders are there which are delivery bases and are completed successfully with cash payment done ?
SELECT COUNT(*) AS cash_delivery_completed_orders
FROM orders
WHERE payment_method = 'Cash'
AND delivery_type = 'Delivery'
AND status = 'Completed';
-- business problem : the business wanted to find the numebr of completed delivery orders with cash payment 
-- business impact: out of 2500 orders only 147 orders were completed succesfully that were delivery orders and cash payment was done. this will help business improve logistics worload and fruad or cancellation analysis of the business orders 

-- question 7 
-- find customers that have never ordered ?
SELECT c.customer_id, c.customer_name, c.city
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
-- business problem : the business wanted to know are there were any fake customers 
-- business impact: there were no fake customers found means that this is a postive sign that after registering a customer has atleast tried the meals of the restraunt 

-- question 8 
-- Which customers ordered  more than once?
SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1
ORDER BY total_orders DESC;
-- business problem : the business was unawared that do there customers come after their first meal
-- business impact : out of 400 customers only 4 customers were there who never came back after orderding their first meal 

-- qustion 9 
-- which payment method is preferred by different customers of different cities 
SELECT 
c.city,
o.payment_method,
COUNT(*) AS total_orders,
ROUND(
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY c.city),
    2
) AS percentage
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.city, o.payment_method
ORDER BY c.city, percentage DESC;
-- business problem:the business was unawared about customers preferences about payment method of different cites
-- business impact: the customers from both the twin cites uses cash more while customers related to karachi and lahore prefer card  more while easy paisa is preferred by customers of multan
-- so business can take decisons to improve personalized payment methods for each of the customers of different cites to make customers personalized 

-- question 10
-- which are the top 3 highest revenue generating cites
SELECT 
c.city,
SUM(p.price * oi.quantity) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.city
ORDER BY total_revenue DESC
LIMIT 3;
-- business problem: the business was unawared about the highest revenue generating cites 
-- business impact: karachi,rawalpinid,lahore generates the highest business revnue this will help the business to make better marketing and make better combos and offers in the less revenue generating cites 

-- question 11
-- so find the products which have never been ordered?
SELECT 
    p.product_id, 
    p.product_name, 
    p.category, 
    p.price
FROM 
    products p
LEFT JOIN 
    order_items oi ON p.product_id = oi.product_id
WHERE 
    oi.product_id IS NULL;
-- business problem: the business was unawared of the products that have never been sold or wheather such products or not 
-- business impact:Now the business has the knowldege that there is no product of them that has never been sold all the products have been sold atleast sometimes

-- question 12 
-- find the orders placed in peak hours 
-- from 12 pm to 3 pm
-- from 6 pm to 10 pm 
SELECT 
    CASE 
        WHEN TIME(o.order_date) BETWEEN '12:00:00' AND '15:00:00' THEN 'Lunch Peak (12PM-3PM)'
        WHEN TIME(o.order_date) BETWEEN '18:00:00' AND '22:00:00' THEN 'Dinner Peak (6PM-10PM)'
    END AS peak_period,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS total_items_sold,
    SUM(oi.quantity * p.price) AS total_revenue
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
WHERE 
    TIME(o.order_date) BETWEEN '12:00:00' AND '15:00:00'
    OR TIME(o.order_date) BETWEEN '18:00:00' AND '22:00:00'
GROUP BY 
    peak_period;
-- business problem  : So the business wanted to know which peak time is performing the most ?
-- business impact: so dineer time having more orders more items sold and is generating more revenue than lunch peak time .On the basis of this insight business should take decisions like reducing the staff and operations at lunch time and increasing the staff and other operations at the dinner time to manage customer orders and decreasing delaying orders 
 
-- Finding the customers that have ordered more than 5 times ?
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.customer_name
HAVING 
    COUNT(o.order_id) > 5
ORDER BY 
    total_orders DESC;

-- find customers having orders more than 5 ?
SELECT 
    COUNT(*) AS total_vip_customers
FROM (
    SELECT 
        customer_id
    FROM 
        orders
    GROUP BY 
        customer_id
    HAVING 
        COUNT(order_id) > 5
) AS loyal_customers_list;

SELECT 
    COUNT(DISTINCT customer_id) AS grand_total_customers
FROM 
    customers;
-- business problem : the business was curious about the total customers that have ordered more than 5 times
-- business impact : Out of 400 customers 232 customers have ordered more than 5 times create a loyality program for the 58% of the customers while for other 42% customers create a reangement program to follow this will decrease the acqusition costs that mostly restraunts spend too much to find new customers 

-- question 14 
-- find the total orders and total revenue by different payment methods ?
SELECT 
    o.payment_method,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_revenue
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    o.payment_method
ORDER BY 
    total_revenue DESC;
-- business problem : the business was curious about the total orders and total revenue generated by each of the payment method ?
-- business impact: card payment is the most preferred payment by customers while jazz cash is the most less preferred by customers 
-- this will help to maintain avaiblity of card payment especially at the peak times of lunch and dinner times
 
-- question 15
-- what is the montly trend by revenue ?
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_revenue
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    order_month
ORDER BY 
    order_month ASC;
-- business problem : the  business wanted to know the monthly trend of revenue 
-- business impact: July was the highest revenue generating month while january was the lowest and there was a decline in total revenue till the end of year restraunts can take steps to set promotional campaings for ending year like 25 december discount offer or for the new year make promotional campaigns like new year new discounts while for the high revenue generating months manage more staff in those months and make logistics working better 
    
-- question 16 
-- Which day of the week has the highest sales ?
SELECT 
    DAYNAME(o.order_date) AS day_of_week,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_revenue
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    day_of_week
ORDER BY 
    total_revenue DESC;
-- business problem :Business wanted to  find that weekdays are the most high selling 
-- business impact:Wednesday and Monday are the most high revenue giving days also the most orders come on these days unlikely the historical assumptions for restraunts weekends brings more orders and revenue for burger restraunt it is completely inverse sunday is giving the most lowest sells business needs to take steps immediately to cut staffs from sunday to bring them more on busy days to save wages and manage workload on high busy days 

-- question 17 
-- What is the average order value per city ?
SELECT 
    c.city,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_revenue,
    SUM(oi.quantity * p.price) / COUNT(DISTINCT o.order_id) AS avg_spending_per_order
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    c.city
ORDER BY 
    avg_spending_per_order DESC;
-- Business problem: the business was unknown to which city has the highest spending customers 
-- Business impact:Islamabad has the lowest orders but has the highest average order value indicating that the customers of islamabad are ordering less but when they order they order premium and expensive items while lahore has high orders but lowest average order value indicating that the customers of lahore tend to spend on low cost items business can take decisons to make aggresive campaings to bring more customers because there current customers are spending less right now and they can make introduce more premium items to cites having high order value 
    
-- question 18 
-- Find percentage contribution of each category to total revenue.	
SELECT 
    p.category,
    SUM(oi.quantity * p.price) AS category_revenue,
    (SUM(oi.quantity * p.price) / (
        SELECT SUM(oi2.quantity * p2.price)
        FROM order_items oi2
        JOIN products p2 ON oi2.product_id = p2.product_id
    )) * 100 AS percentage_contribution
FROM 
    order_items oi
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    p.category
ORDER BY 
    percentage_contribution DESC;
-- business problem : the business was unawared about the contribution of each category of the restraunt to its total revenue 
-- business impact: deserts take much time and labour cost but are giving revenue nearly equal to drinks which require no labour due to this there can be a kitchen overload and the main cateogry of burgers may be disturbed and let to hungry and frustrated customers 
    
-- question 19 
-- Find which hour of the day has highest order volume.		
SELECT 
    HOUR(o.order_date) AS order_hour,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_revenue
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    order_hour
ORDER BY 
    total_orders DESC;
-- The Business Problem
-- "The restaurant faces two massive, completely different rushes: one at 10 AM (morning break) and one at 7 PM (dinner). This means the kitchen has to completely switch its speed and setup twice a day, which can cause chaos if the staff isn't prepared for a morning rush."
-- The Business Impact
-- "If the restraunt assumes mornings are sleepy and only schedules a few workers before noon, the kitchen will get completely crushed at 10 AM. This leads to slow service, angry customers walking away, and lost morning money that should be easy to catch."

-- question 20 
-- Find customers whose total spending is above average customer spending.																									
SELECT COUNT(*) AS total_vip_customers
FROM (
    SELECT c.customer_id
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY c.customer_id
    HAVING SUM(oi.quantity * p.price) > (
        SELECT AVG(customer_totals.total_spent)
        FROM (
            SELECT SUM(oi2.quantity * p2.price) AS total_spent
            FROM orders o2
            JOIN order_items oi2 ON o2.order_id = oi2.order_id
            JOIN products p2 ON oi2.product_id = p2.product_id
            GROUP BY o2.customer_id
        ) AS customer_totals
    )
) AS vip_list;
-- business problem : the business was curious about the customers which are spending more than the average order value 
-- business impact:out of 400 customers 185 are spending more than the average order value we need to make combos and offers for the other customers to spend more than they do this will reduce customer acqusition costs to bring new customers and we can make our current customers satisfied

-- question 21:
-- Find waiter who handled highest revenue.	
SELECT 
    w.waiter_name,
    COUNT(DISTINCT o.order_id) AS total_orders_handled,
    SUM(oi.quantity * p.price) AS total_revenue_handled
FROM 
    waiters w
JOIN 
    orders o ON w.waiter_id = o.waiter_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    w.waiter_id, w.waiter_name
ORDER BY 
    total_revenue_handled DESC;			
    
-- The Business Problem
-- "There is a massive gap in upselling skills among the waiting staff. Star waiters like Kyle are making high-value sales with fewer tables, while waiters like Paul are working much harder but bringing in lower-value bills because they aren't pushing add-ons."
-- The Business Impact
-- "Because staff performance is so unbalanced, the restaurant is losing thousands in easy profits. If underperforming waiters like Paul and Tiffany were trained to copy Kyle’s upselling techniques, the restaurant could unlock an extra 150,000 to 200,000 in monthly revenue without needing a single new customer walking through the door."

-- question 22 
-- Find customers who ordered again within 7 days.
SELECT DISTINCT
    c.customer_id,
    c.customer_name,
    c.city
FROM 
    orders o1
JOIN 
    orders o2 ON o1.customer_id = o2.customer_id 
    AND o1.order_id <> o2.order_id
JOIN 
    customers c ON o1.customer_id = c.customer_id
WHERE 
    o2.order_date >= o1.order_date
    AND o2.order_date <= o1.order_date + INTERVAL 7 DAY;
-- business problem:"The restaurant has zero 7-day customer loyalty. Every single person who buys our burgers treats us like a one-time stop—they eat here once and then completely disappear for weeks or months, never coming back within a week."
-- business impact:
-- "Because customer retention is at 0%, the restaurant is trapped on a dangerous financial treadmill. We have to spend massive amounts of energy and marketing efforts constantly hunting for brand-new customers just to survive, instead of making easy, automated money from happy, repeating regulars."
-- we can make Receipt coupons for customers and make them to bring within next 7 days and get a super deal these ideas can attract current customers

-- question 23 
-- which are Top 20% Products Generating Revenue (Pareto Analysis)
SELECT 
    product_name,
    total_revenue,
    ROUND(product_rank * 100, 2) AS top_percentage_rank
FROM (
    SELECT 
        p.product_name,
        SUM(oi.quantity * p.price) AS total_revenue,
        CUME_DIST() OVER (ORDER BY SUM(oi.quantity * p.price) DESC) AS product_rank
    FROM 
        order_items oi
    JOIN 
        products p ON oi.product_id = p.product_id
    GROUP BY 
        p.product_id, p.product_name
) AS ranked_products
WHERE 
    product_rank <= 0.20;
-- The Business Problem:The restaurant is a two-trick pony; its entire financial survival completely depends on just two beef items, meaning the rest of the chicken, fish, or veggie menu is basically dead weight."
-- The Business Impact:If the restruant's kitchen runs out of beef patties or your meat supplier fails for even a single day, your restaurant's daily revenue will be badly crash the action that business can take  is making such combo deals that encourages to buy drinks and other items because they give easy profits to the business
    
-- question 24 
-- Find Customers With No Activity in Last 30 Days	
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    MAX(o.order_date) AS last_order_date
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.customer_name, c.city
HAVING 
    last_order_date < NOW() - INTERVAL 30 DAY;
-- The Business Problem:"There is no immediate churn problem to fix, which means the database does not contain any historical, long-term dead accounts from past months to analyze."
-- The Business Impact:"Your restaurant currently enjoys a 100% active 30-day user base, meaning you don't need to waste any money on 'We Miss You' discount campaigns because nobody has actually left yet!"
    
-- question 25
-- Find Average time difference between first and last order of customers
SELECT 
    ROUND(AVG(DATEDIFF(last_date, first_date)), 1) AS avg_days_between_first_and_last
FROM (
    SELECT 
        customer_id,
        MIN(order_date) AS first_date,
        MAX(order_date) AS last_date
    FROM 
        orders
    GROUP BY 
        customer_id
) AS customer_lifespans;
-- The Business Problem:"While customers stay loyal for a solid 8-month window, a gap this wide suggests they might only be visiting on special occasions or months apart, rather than making us a weekly habit."
-- The Business Impact:Our customers do love our food and they do return to us over a long 8-month period (249.6 days). However, they are not returning quickly (0% 7-day retention). They treat our burgers like a monthly treat or a payday reward rather than a regular weekly meal.

-- question 26:
-- What is the Revenue Drop Analysis Month Over Month	
SELECT 
    order_year,
    order_month,
    current_month_revenue,
    previous_month_revenue,
    ROUND(current_month_revenue - previous_month_revenue, 2) AS revenue_drop_or_gain,
    ROUND(((current_month_revenue - previous_month_revenue) / previous_month_revenue) * 100, 2) AS percentage_change
FROM (
    SELECT 
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        SUM(quantity * price) AS current_month_revenue,
        LAG(SUM(quantity * price), 1) OVER (ORDER BY YEAR(order_date), MONTH(order_date)) AS previous_month_revenue
    FROM 
        order_items oi
    JOIN 
        orders o ON oi.order_id = o.order_id
    JOIN 
        products p ON oi.product_id = p.product_id
    GROUP BY 
        YEAR(order_date), MONTH(order_date)
) AS monthly_revenue_sheet;			
-- business problem:"Our restaurant’s income goes up and down like a roller coaster depending on the month, but our real-world bills (like shop rent, electricity, and staff salaries) stay exactly the same every single month. This means we have a seasonal business that struggles to keep steady cash coming in during the early summer and winter."
-- business impact:	"Because our monthly cash flow is unpredictable, a sharp drop like the December crash (-4.86%) can instantly trap the business in a dangerous cash crunch. If we treat the big money months like pure profit and spend it all immediately, we won't have a backup shield to pay our suppliers or shop rent on time when the quiet months like June arrive."

-- question 29:
-- What is Product Popularity by Time of Day	
SELECT 
    order_hour,
    product_name,
    total_quantity_sold,
    hourly_rank
FROM (
    SELECT 
        HOUR(o.order_date) AS order_hour,
        p.product_name,
        SUM(oi.quantity) AS total_quantity_sold,
        DENSE_RANK() OVER (
            PARTITION BY HOUR(o.order_date) 
            ORDER BY SUM(oi.quantity) DESC
        ) AS hourly_rank
    FROM 
        order_items oi
    JOIN 
        orders o ON oi.order_id = o.order_id
    JOIN 
        products p ON oi.product_id = p.product_id
    GROUP BY 
        HOUR(o.order_date), p.product_id, p.product_name
) AS ranked_hourly_products
WHERE 
    hourly_rank = 1;
-- business problem"The menu demands of the kitchen constantly shift every few hours, meaning staff cannot use a single, unchanging prep routine for the whole day without causing major order delays during peak transitions."
-- business impact:"If the kitchen fails to pre-cook fries before 4 PM, or fails to fry Zinger patties right before the massive 9 PM night rush, customers will face long wait times, leading to cold food, driver delays, and lost revenue during our busiest hours."

-- business question 30:
-- find products that are often ordered together 
SELECT 
    item_A.product_id AS product_id_1,
    p1.product_name AS product_name_1,
    item_B.product_id AS product_id_2,
    p2.product_name AS product_name_2,
    COUNT(*) AS times_bought_together
FROM 
    order_items item_A
JOIN 
    order_items item_B ON item_A.order_id = item_B.order_id
JOIN 
    products p1 ON item_A.product_id = p1.product_id
JOIN 
    products p2 ON item_B.product_id = p2.product_id
WHERE 
    item_A.product_id < item_B.product_id
GROUP BY 
    item_A.product_id, p1.product_name, 
    item_B.product_id, p2.product_name
ORDER BY 
    times_bought_together DESC
LIMIT 10;
-- business problem:"The data shows a massive, unexploited consumer behavior pattern where specific standalone menu items are repeatedly paired together—specifically Zinger Burger + Loaded Fries (127 times) and Cheese Burger + Loaded Fries (112 times). Currently, these items only exist as disconnected, individual choices on the menu card. This means the restaurant’s menu design completely ignores its top cross-selling combinations, failing to present them as official, single-click combo meals."
-- business impact:"The data shows a massive, unexploited consumer behavior pattern where specific standalone menu items are repeatedly paired together—specifically Zinger Burger + Loaded Fries (127 times) and Cheese Burger + Loaded Fries (112 times). Currently, these items only exist as disconnected, individual choices on the menu card. This means the restaurant’s menu design completely ignores its top cross-selling combinations, failing to present them as official, single-click combo meals."