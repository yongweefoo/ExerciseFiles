-- 3_2 Working with Arrays in Hive

-- find the price of the 1st item from the 2nd order in orders array field

-- first let's look and see what it looks like
-- you'll notice that it looks like a list vs a map/dictionary

select orders
from default.customers
limit 10

-- to reference items in that array you must use an index
-- there can be many orders per customer
-- so orders[0] will list the first order (0 index)

select orders[0] as first_order
from default.customers
limit 10

-- this will show all the third orders 
-- but if they don't have one it'll be null

select orders[2] as third_order
from default.customers
limit 10

-- now let's take the items from the first order
-- now we have an array of items

select orders[0].items as first_order_items
from default.customers
limit 10

-- now we want to get the first item from the second orders
-- again if there's no second order there it'll show up as null

select orders[1].items[0] as first_item_from_second_order
from default.customers
limit 10

-- and lastly we want the price of that item
select orders[1].items[0].price as first_item_from_second_order_price
from default.customers
limit 10
