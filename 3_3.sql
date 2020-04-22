-- 3_3 Working with Structs in Hive

-- parse orders struct from customer table using explode()

-- again let's look at the orders array
-- and the customer that have those orders

select name as customer_name, orders
from default.customers
limit 10;

-- now we have an an array of orders per customer
-- but what if we wanted to pivot the data
-- to see each customers orders in separated rows
-- we would use the explode feature()

select name as customer_name, exploded_orders
from customers
LATERAL VIEW explode(orders) o as exploded_orders
order by customer_name asc;

-- now each order has it's own rows

-- you can go another level down by displaying every item
-- that a customer has purchased
-- by doing another lateral explode on the query that you just ran
-- we'll use a CTE for easier readability
-- and everyting that we've learned in the prior videos
-- to parse structs and arrays

with pivoted_orders as
(
select name as customer_name
, exploded_orders
from customers
LATERAL VIEW explode(orders) o as exploded_orders
)

select customer_name
, exploded_orders.order_id as order_id
, exploded_orders.order_date as order_date
, exploded_items
from pivoted_orders
LATERAL VIEW explode(exploded_orders.items) i as exploded_items
order by customer_name
, order_id
, order_date

-- we can do 1 level further and extracta all the item attributes to their own columns
with pivoted_orders as
(
select name as customer_name
, exploded_orders
from customers
LATERAL VIEW explode(orders) o as exploded_orders
)

select customer_name
, exploded_orders.order_id as order_id
, exploded_orders.order_date as order_date
, exploded_items.product_id as item_product_id
, exploded_items.sku as item_sku
, exploded_items.name as item_name
, exploded_items.price as item_price
, exploded_items.qty as item_quantity
from pivoted_orders
LATERAL VIEW explode(exploded_orders.items) i as exploded_items
order by customer_name
, order_id
, order_date

-- we do this because impala doesn't allow complex structures
-- and if you want to be able to join impala objects to these complex structures
-- youre going to have to flatten them out
-- I'd recommend putting these queries into tables so you don't have process them every time

create table default.customer_orders
stored as parquet
tblproperties('parquet.compression'='SNAPPY') as

with pivoted_orders as
(
select name as customer_name
, exploded_orders
from customers
LATERAL VIEW explode(orders) o as exploded_orders
)

select customer_name
, exploded_orders.order_id as order_id
, from_unixtime(UNIX_TIMESTAMP(concat(substr(exploded_orders.order_date,1,10),' ', substr(exploded_orders.order_date,12,8)),'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as order_date -- make a timestamp field in impala
, exploded_items.product_id as item_product_id
, exploded_items.sku as item_sku
, exploded_items.name as item_name
, exploded_items.price as item_price
, exploded_items.qty as item_quantity
from pivoted_orders
LATERAL VIEW explode(exploded_orders.items) i as exploded_items

-- now you have a very clean table to do analysis on that will have great performance
-- and is queryable in impala

-- run this in impala on Hue -> Query Editors -> Impala

-- you gotta invalidate metadata first because you added a new object that impala doesn't know about
invalidate metadata customer_orders;

-- then run the select query
select *
from default.customer_orders
limit 10

-- notice when you try to run a query to find orders on the customer table it breaks in impala
select orders
from default.customers
