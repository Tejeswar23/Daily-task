select * from dbo.train
-- Task 1: High-Value Order Identification
--Write a query to fetch all orders where sales are greater than the overall average sales.
Select Order_id,Sales
FROM dbo.train
where Sales > (
      SELECT AVG(Sales) from dbo.train
);

-- Task 2: City-Level Revenue Concentration
-- Write a query to retrieve the top 5 cities by total sales, ordered from highest to lowest.
SELECT TOP 5 City,SUM(sales) AS total_sales
FROM dbo.train
GROUP BY City
order by total_sales desc

-- Task 3: Customer Purchase Behavior
-- Write a query to find customers who have placed more than 5 orders, along with their total sales.
SELECT Customer_Name,count(*) as number_of_orders
FROM dbo.train
group by Customer_Name
Having count(*) > 5;

-- Task 4: Segment Performance Analysis
-- Write a query to calculate total sales and total number of orders for each segment, sorted by total sales.
SELECT segment,sum(sales) as total_sales,
       count(*) as total_orders
       FROM dbo.train
       GROUP BY Segment
       order by total_sales 

-- Task 5: Shipping Delay Detection
-- Write a query to identify orders where the shipping duration exceeds 4 days
select order_id
       from dbo.train
       where datediff(day,order_date,ship_date) > 4;

-- Task 6: Ship Mode Utilization
-- Write a query to calculate the percentage contribution of each ship mode based on the total number of orders.
SELECT
    Ship_Mode,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    CAST(
        COUNT(DISTINCT Order_ID) * 100.0 /
        SUM(COUNT(DISTINCT Order_ID)) OVER ()
        AS DECIMAL(5,2)
    ) AS Percentage_Contribution
FROM dbo.train
GROUP BY Ship_Mode;
-- Task 7: City-Level Sales Ranking
-- Write a query to rank cities within each country based on total sales using a window function.
WITH CitySales AS (
    SELECT
        country,
        city,
        SUM(sales) AS total_sales
    FROM dbo.train
    GROUP BY country, city
)
SELECT
    country,
    city,
    total_sales,
    DENSE_RANK() OVER (
        PARTITION BY country
        ORDER BY total_sales DESC
    ) AS city_rank
FROM CitySales
ORDER BY country, city_rank;
-- Task 8: Monthly Order Trend
-- Write a query to calculate the number of orders per month, grouped by year and month using Order_Date.
SELECT
    YEAR(Order_Date)  AS order_year,
    MONTH(Order_Date) AS order_month,
    COUNT(DISTINCT Order_ID) AS total_orders
FROM dbo.train
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY
    order_year,
    order_month;
-- task 9
-- Write a query to identify orders where the ship date is earlier than the order date.
SELECT *
FROM dbo.train
WHERE Ship_Date < Order_Date;




