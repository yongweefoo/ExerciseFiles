-- 3_5 Deconstructing Impala Queries

-- do basic query from table we built

select *
from default.customer_orders
limit 100;

-- now let's do an explain plan

explain select *
from default.customer_orders
limit 100;

-- it's missing statistics
-- to fix that we run compute stats command

compute stats default.customer_orders;

-- try it again

explain select *
from default.customer_orders
limit 100;

-- pretty basic it estimates 48MB of memory to be used
-- it shows it's unpartitioned
-- limit of 100 rows
-- and it reads only 1 file
-- and it's only using 1 core (we're using a virtual machine)

-- now let's do something with a simple where clause

select *
from default.customer_orders
where customer_name = 'Melvin Garcia'

-- now let's do an explain plan on that
explain
select *
from default.customer_orders
where customer_name = 'Melvin Garcia'

-- same thing just added a predicate of where customer_name = 'Melvin Garcia'
select customer_name
, month(order_date) as order_month
, year(order_date) as order_year
, sum(item_price) as total_sales_amount
, sum(item_price)/sum(item_quantity) as average_price_per_item
from default.customer_orders
group by customer_name
, order_month
, order_year

-- now put an explain plan on it
explain
select customer_name
, month(order_date) as order_month
, year(order_date) as order_year
, sum(item_price) as total_sales_amount
, sum(item_price)/sum(item_quantity) as average_price_per_item
from default.customer_orders
group by customer_name
, order_month
, order_year

-- so you read it from the bottom to the top
-- first thing is it scans hdfs for the files it needs
-- then it does it's aggregations (sums) it needs
-- it merges it via the hash of the things that you grouped it by
-- and returns the finalized aggregations
-- you see this takes up more memory than the previous query

-- now put an explain plan with a join
explain
select c.id
, month(order_date) as order_month
, year(order_date) as order_year
, sum(item_price) as total_sales_amount
, sum(item_price)/sum(item_quantity) as average_price_per_item
from default.customer_orders o
left join default.customers c
on o.customer_name = c.name
group by c.id
, order_month
, order_year

-- ignore the warnings
-- it's complaining about default.customers not having statistics
-- it scans both objects in parallel
-- and broadcasts the data to the impala daemons
-- it does hash joins the data with the where clause that we used
-- and does the aggregates the data and groups it by the hash like before
-- and returns the finalized aggregations

-- it can get a LOT more complicated especially when you do more/joins and complex logic but these are the basics
