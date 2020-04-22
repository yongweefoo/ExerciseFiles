-- 3_1 Working With Map Data in Hive

-- show installation of hive example tables through hue

-- find billing city in the addresses map field in hue

-- first look at what the data looks like raw

select addresses
from default.customers
limit 10

-- let's look at all the billing maps

select addresses['billing'].city as billing_addresses
from default.customers
limit 10

-- now let's pull out the city from billings_addresses struct

select addresses['billing'].city as billing_addresses
from default.customers
limit 10
