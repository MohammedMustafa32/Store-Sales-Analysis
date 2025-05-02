------------------------------------------------------------------------------------------------
---------------------------------------[ Data Cleaning ]----------------------------------------
------------------------------------------------------------------------------------------------

-- Postal code is NULL ,IF City = Burlington ,And  State = Vermont     (11 rows)
-- Search for Postal_Code (google) => 05401  ==>>> will be ( 5401 )
select * from SuperStore_Sales where Postal_Code is null
select * from SuperStore_Sales where City = 'Burlington'
select * from SuperStore_Sales where City = 'Burlington' and State='Vermont'

update SuperStore_Sales
set Postal_Code = 5401
where City = 'Burlington' and State='Vermont'


-- =========================
/* 
Ship Mode -> Standard Class, Second Class, First Class, Same Day

Segment -> Consumer, Home Office, Corporate

Region -> Central, East, South, West

Category -> Furniture, Office Supplies, Technology

*/



--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-----------------------------------[ SuperStore Sales Project ]-----------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
select * from SuperStore_Sales

-- No. Customers
select count(distinct Customer_ID) as [No. Customers]
from SuperStore_Sales

-- No. Orders
select count(distinct Order_ID) as [No. Orders]
from SuperStore_Sales

-- Avg Shipping Days
select avg( datediff(day, Order_Date, Ship_Date) ) as [Avg Shipping Days]
from SuperStore_Sales

-- Total Sales
select round(sum(Sales), 0) as [Total Sales]
from SuperStore_Sales

-- VIP Customers ( Sum of Sales for each customer ) - ( Which is the most customers that bought Products ? )
select top 10 Customer_ID, Customer_Name, round(sum(Sales), 0) as Sales
from SuperStore_Sales
group by Customer_ID, Customer_Name
order by Sales desc

-- Frequent Customers ( No. Orders for each customer ) - ( Which is the most Frequent customers that make an orders ? )
select Top 10 Customer_ID, Customer_Name, count(distinct Order_ID) as [No. Orders]
from SuperStore_Sales
group by Customer_ID, Customer_Name
order by [No. Orders] desc



-- ****************
select * from SuperStore_Sales

-- Top 10 cities generated the highest Sales
select top 10 City, round(sum(Sales), 0) as [Sales of City]
from SuperStore_Sales
group by City
order by [Sales of City] desc

-- Top 10 states generated the highest Sales
select top 10 State
             ,count(distinct Order_ID) as [No. Orders]
			 ,round(sum(Sales), 0) as [Sales of State]
from SuperStore_Sales
group by State
order by [Sales of State] desc

-- Sales by each category
select Category, round(sum(Sales), 0) as [Sales of Category]
from SuperStore_Sales
group by Category
order by [Sales of Category] desc

-- Sales by each sub-category
select Sub_Category, round(sum(Sales), 0) as [Sales of Sub_Category]
from SuperStore_Sales
group by Sub_Category
order by [Sales of Sub_Category] desc

-- Sales by Ship Mode
select Ship_Mode, round(sum(Sales), 0) as [Sales of Ship Mode]
from SuperStore_Sales
group by Ship_Mode
order by [Sales of Ship Mode] desc

-- Sales by Segment (Which Segment has the highest Revenue ?)
select Segment, round(sum(Sales), 0) as Total_Revenue
from SuperStore_Sales
group by Segment
order by Total_Revenue desc

-- Sales by Region (Which Region has the highest Revenue ?)
select Region, round(sum(Sales), 0) as Total_Revenue
from SuperStore_Sales
group by Region
order by Total_Revenue desc

-- Sales by Month
select format(Order_Date, 'yyyy-MM') as YearMonth, round(sum(Sales), 0) as Total_Revenue
from SuperStore_Sales
group by format(Order_Date, 'yyyy-MM')
order by YearMonth

-- Sales by Year
select format(Order_Date, 'yyyy') as Year, round(sum(Sales), 0) as Total_Revenue
from SuperStore_Sales
group by format(Order_Date, 'yyyy')
order by Year


-- No. Customer by month
select format(Order_Date, 'yyyy-MM') as YearMonth, count(distinct Customer_ID) as [No. Customer]
from SuperStore_Sales
group by format(Order_Date, 'yyyy-MM')
order by YearMonth

-- No. Customer by year
select format(Order_Date, 'yyyy') as Year, count(distinct Customer_ID) as [No. Customer]
from SuperStore_Sales
group by format(Order_Date, 'yyyy')
order by Year


-- No. Customer per city - ( Top 10 Citys with the highest No. Customers)
select top 10 City, count(distinct Customer_ID) as [No. Customer]
from SuperStore_Sales
group by City
order by [No. Customer] desc


-- No. Customer per state - ( Top 10 States with the highest No. Customers)
select top 10 State, count(distinct Customer_ID) as [No. Customer]
from SuperStore_Sales
group by State
order by [No. Customer] desc

-- No. Customer per Region
select Region, count(distinct Customer_ID) as [No. Customer]
from SuperStore_Sales
group by Region
order by [No. Customer] desc



---------------- ( Product ) --------------

-- Which products contributed most to the Revenue? - (Top Selling Products)
select top 30 Product_ID, Product_Name, round(sum(Sales), 0) as Total_Revenue
from SuperStore_Sales
group by Product_ID, Product_Name
order by Total_Revenue desc

-- Which products contributed less to the Revenue?
select top 30 Product_ID, Product_Name, round(sum(Sales), 0) as Total_Revenue
from SuperStore_Sales
group by Product_ID, Product_Name
order by Total_Revenue asc


-- 
select top 10 Product_ID, Product_Name, count(distinct Order_ID) as [No. Orders]
from SuperStore_Sales
group by Product_ID, Product_Name
order by [No. Orders] desc


-- get top 3 selling product every year (by Revenue)
select *
from (
		select format(Order_Date, 'yyyy') as Year
			  ,Product_Name
			  ,round(sum(Sales), 0) as [Revenue per Years]
			  ,row_number() over(partition by format(Order_Date, 'yyyy') order by round(sum(Sales), 0) desc) as rnk
		from SuperStore_Sales
		group by format(Order_Date, 'yyyy'), Product_Name
) as tab
where tab.rnk <= 3
order by tab.Year, tab.[Revenue per Years] desc


select * from SuperStore_Sales


-- get top 1 selling product every Segment (by Revenue)
select *
from (
		select Segment
			  ,Product_Name
			  ,count(Order_ID) as [No. Order]
			  ,row_number() over(partition by Segment order by count(Order_ID) desc) as rnk
		from SuperStore_Sales
		group by Segment, Product_Name
) as tab
where tab.rnk <= 1
order by tab.Segment, tab.[No. Order] desc




-- get top 2 product in each Region that make highest No Order
select *
from (
		select Region
			  ,Product_Name
			  ,count(Order_ID) as [No. Order]
			  ,row_number() over(partition by Region order by count(Order_ID) desc) as rnk
		from SuperStore_Sales
		group by Region, Product_Name
) as tab
where tab.rnk <= 3
order by tab.Region, tab.[No. Order] desc

