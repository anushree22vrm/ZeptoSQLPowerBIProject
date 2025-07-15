create database Project
create table zepto 
( sku_id int identity(1,1) PRIMARY KEY,
  category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp decimal(8,2),
  discountPercent decimal(5,2),
  availableQuantity int,
  discountedSellingPrice decimal(8,2),
  weightinGms int,
  outOfStock bit,
  quantity int
);

INSERT INTO zepto (category, name, mrp, discountPercent, availableQuantity, discountedSellingPrice, weightinGms, outOfStock, quantity)
SELECT category, name, mrp, discountPercent, availableQuantity, discountedSellingPrice, weightinGms, outOfStock, quantity
FROM ZeptoData;

select * from zepto

-- Data Exploration

-- Count of rows
select count(*) from zepto

-- Sample Data
select top 10 * from zepto

-- Null Values
select * from zepto
where category is null
or
name is null
or
mrp is null
or
discountPercent is null
or
availableQuantity is null
or
discountedSellingPrice is null
or
weightinGms is null
or
outOfStock is null
or
quantity is null

-- Different Product Categories
select distinct category 
from zepto
order by category

-- Products in stock vs OutofStock
select outOfStock, count(sku_id) as count_of_items
from zepto
group by outOfStock

-- Product names present multiple times
select name, count(sku_id) as no_of_skus
from zepto
group by name
having count(sku_id) > 1
order by no_of_skus desc

-- DATA CLEANING

--Products with price = 0
select * from zepto
where mrp = 0 or discountedSellingPrice = 0

--> Since we cannot have a prodect with 0 mrp, we will delete this row
delete from zepto
where mrp = 0

-- Converting paise to ruppee
update zepto 
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0

select mrp,discountedSellingPrice
from zepto

-- Q1 Find the top 10 best-value products based on the discount percentage
select distinct top 10 name,mrp,discountPercent
from zepto
order by discountPercent desc

-- Q2 What are the products with high MRP but out of stock
select * from zepto
where outOfStock = 1 and mrp > 300
order by mrp desc

-- Q3 Calculate the estimated revenue for each category
select category,sum(discountedSellingPrice * availableQuantity) as total_revenue
from zepto
group by category
order by total_revenue

-- Q4 Find all products where MRP is greater than 500 and discount less than 10%
select distinct name,mrp,discountPercent
from zepto
where mrp > 500 and discountPercent < 10
order by mrp desc ,discountPercent desc

-- Q5 Identify the top 5 category offering the highest avg discount percentage
select top 5 category,round(avg(discountPercent),2) as avg_disc_per
from zepto
group by category
order by avg_disc_per desc

-- Q6 Find the price per gram for products above 100gm and sort by best value
select distinct name,weightinGms,discountedSellingPrice,round((discountedSellingPrice/weightinGms),2) as price_per_gm
from zepto
where weightinGms >=100
order by price_per_gm

-- Q7 Group all the products into categories like Low,Medium,Bulk
select distinct name,weightinGms,
case when weightinGms < 1000 then 'Low' 
     when weightinGms < 5000 then 'Medium'
     else 'Bulk'
     end as weight_category
from zepto

-- Q8 What is the total inventory weight per category
select category, sum(weightinGms * availableQuantity) as total_weight
from zepto
group by category
order by total_weight










