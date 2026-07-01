/*
===============================================
           SQL PROJECT
      Retail Store Management System
===============================================

Database : ecommerce_db

Project Objective:
To analyze an e-commerce retail database using SQL by performing
data retrieval, filtering, aggregations, joins, subqueries, and
set operations to answer real-world business questions.

===============================================
*/

USE ecommerce_db;

-- Level 1: Basics

-- 1. Retrieve customer names and emails for email marketing
select  name as customer_name, email
from customers;

-- 2. View complete product catalog with all available details
select *
from product_reviews;

-- 3. List all unique product categories
select distinct category 
from products;

-- 4. Show all products priced above ₹1,000
select * from products
where price > 1000;

-- 5. Display products within a mid-range price bracket (₹2,000 to ₹5,000)
select * from products
where price between 2000 and 5000;

-- 6. Fetch data for specific customer IDs (e.g., from loyalty program list)
select * from customers 
where customer_id in (1,3,5,8);

-- 7. Identify customers whose names start with the letter ‘A
select * from customers
where name like 'A%';

-- 8. List electronics products priced under ₹3,000
select * from products
where category = 'electronics' and price < 3000;

-- 9. Display product names and prices in descending order of price
select name as product_names, price 
from products
order by price desc;

-- 10. Display product names and prices, sorted by price and then by name
select name as product_names, price 
from products
order by price, product_names;


-- Level 2: Filtering and Formatting

-- 1. Retrieve orders where customer information is missing (possibly due to data migration ordeletion)
select * from orders
where customer_id is null;

-- 2. Display customer names and emails using column aliases for frontend readability
select name as customer_name, email as email_address
from customers;

-- 3. Calculate total value per item ordered by multiplying quantity and item price
select order_item_id, product_id, sum(quantity * item_price) as total_value
from order_items
group by order_item_id, product_id;

-- 4. Combine customer name and phone number in a single column
select concat(name,'-', phone) as customer_name_contact
from customers;

-- 5. Extract only the date part from order timestamps for date-wise reporting
select order_id, date(order_date) as date
from orders;

-- 6. List products that do not have any stock left
select product_id, stock_quantity
from products
where stock_quantity = 0;

-- Level 3: Aggregations

-- 1. Count the total number of orders placed
select count(status) as order_placed
from orders;

-- 2. Calculate the total revenue collected from all orders
select sum(total_amount) as total_revenue
from orders;

-- 3. Calculate the average order value
select avg(total_amount) as avg_order_value
from orders;

-- 4. Count the number of customers who have placed at least one order
select count(distinct customer_id)
from orders;

-- 5. Find the number of orders placed by each customer
select customer_id, count(order_id) as total_orders
from orders
group by customer_id;

-- 6. Find total sales amount made by each customer
select customer_id, sum(total_amount) as total_sales
from orders
group by customer_id;

-- 7. List the number of products sold per category
select p.category, sum(oi.quantity)
from products as p 
inner join order_items oi
on p.product_id = oi.product_id
group by category;

-- 8. Find the average item price per category
select category, avg(price) as avg_price
from products
group by category;

-- 9. Show number of orders placed per day
select date(order_date) as day, count(*) as orders
from orders
group by day;

-- 10. List total payments received per payment method
select method, sum(amount_paid) as total_payments
from payments
group by method;


-- Level 4: Multi-Table Queries (JOINS)

-- 1. Retrieve order details along with the customer name
select o.order_id, c.customer_id,name, o.order_date, o.total_amount
from orders as o
inner join customers as c
on c.customer_id = o.customer_id;

-- 2. Get list of products that have been sold (INNER JOIN with order_items)
select distinct p.product_id, p.name
from products as p
inner join order_items as oi
on oi.product_id = p.product_id;

-- 3. List all orders with their payment method (INNER JOIN)
select o.order_id, p.method, p.amount_paid 
from orders as o
inner join payments as p
on o.order_id = p.order_id;

-- 4. Get list of customers and their orders (LEFT JOIN)
select c.name, o.order_id, o.order_date, o.status, o.total_amount
from customers as c
inner join orders as o
on c.customer_id = o.customer_id;

-- 5. List all products along with order item quantity (LEFT JOIN)
select p.name, oi.quantity
from products as p
left join order_items as oi
on oi.product_id = p.product_id;

-- 6. List all payments including those with no matching orders (RIGHT JOIN)
select o.order_id, p.payment_id, p.amount_paid
from payments as p
right join orders as o
on p.order_id = o.order_id;

-- 7. Combine data from three tables: customer, order, and payment
select *
from customers as c
inner join orders as o
on c.customer_id = o.customer_id
inner join payments as p
on p.order_id = o.order_id;


-- Level 5: Subqueries (Inner Queries)

-- 1. List all products priced above the average product price
select * 
from products
where price > (select avg(price) from products);

-- 2. Find customers who have placed at least one order
select c.customer_id, c.name, c.email
from customers as c
where exists (select order_id 
from orders as o
where o.customer_id = c.customer_id);

-- 3. Show orders whose total amount is above the average for that customer
select *
from orders
where total_amount > (select avg(total_amount) as total_amount 
from orders as o
where customer_id = o.customer_id);

-- 4. Display customers who haven’t placed any orders
select * 
from customers
where customer_id not in (select customer_id 
from orders);

-- 5. Show products that were never ordered
select * 
from products
where product_id not in (select product_id 
from order_items);

-- 6. Show highest value order per customer
select * 
from orders
where total_amount = (select max(total_amount) 
from orders as o
where customer_id = o.customer_id);

-- 7. Highest Order Per Customer (Including Names)
select c.name, o.order_id, o.total_amount
from orders as o
inner join customers as c
on c.customer_id = o.customer_id
where total_amount = (select max(total_amount)
from orders
where customer_id = o.customer_id);


-- Level 6: Set Operations

-- 1. List all customers who have either placed an order or written a product review
select customer_id, name, email
from customers
where customer_id in (select customer_id
from orders
union
select customer_id
from product_reviews);

-- 2. List all customers who have placed an order as well as reviewed a product [intersect notsupported]
select name
from customers
where customer_id in (select customer_id
from orders
where customer_id in (select customer_id
from product_reviews));

