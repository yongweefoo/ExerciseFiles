-- 2_4 Select Partitioning in Hive

-- create partitioned version of sales table partitioned by company name

create table back_office.sales_all_years_partitioned(
	RowID smallint,
	OrderID int,
	OrderDate date,
	OrderMonthYear date,
	Quantity int,
	Quote float,
	DiscountPct float,
	Rate float,
	SaleAmount float,
	CustomerName string,
	CompanyName string,
	Sector string,
	Industry string,
	City string,
	ZipCode string,
	State string,
	Region string,
	ProjectCompleteDate date,
	DaystoComplete int,
	ProductKey string,
	ProductCategory string,
	ProductSubCategory string,
	Consultant string,
	Manager string,
	HourlyWage float,
	RowCount int,
	WageMargin float)
	partitioned by(companyname_partition string)
    stored as textfile;

-- need to set dynamic partition mode to nonstrict
-- this dynamically creates partitions when you insert records
SET hive.exec.dynamic.partition.mode=nonstrict;

-- insert records from sales_staging to sales_all_years_partitioned
insert into table back_office.sales_all_years_partitioned partition (companyname_partition)
	select *
	, CompanyName
	from back_office.stage_sales;

-- now look at the folder structure in hdfs and see that it partitioned all the files into companyname folders
hadoop fs -ls /user/hive/warehouse/back_office.db/sales_all_years_partitioned

-- and each one of those folders only has data related to that company
-- this should only show you rows that have DIRECTV as the company name
hadoop fs -cat /user/hive/warehouse/back_office.db/sales_all_years_partitioned/companyname_partition=DIRECTV/*

-- when you run your query in the where clause use the partition name to query using partitions*/
select * 
from back_office.sales_all_years_partitioned
where companyname_partition = 'DIRECTV' 

-- it's going to be a lot faster than querying it by companyname
-- because it doesn't have to search all the folders 
-- because it knows exactly where the data lives
-- notice how much slower this query is
select *
from back_office.sales_all_years_partitioned
where companyname = 'DIRECTV'

-- now run explain plans on both queries
-- you'll notice the partition query has less things to do because there's less rows in the explain plan
-- it also knows the exact number of rows it should find 82 and just does a table scan and fetch
-- in the query that doesn't use the partition there's more rows (8399) that it has to go through
-- it has to do an extra mapreduce job which will take a lot of time, a filter operator, and a file output operator
   explain select * 
from back_office.sales_all_years_partitioned
where companyname_partition = 'DIRECTV' 

   explain select * 
from back_office.sales_all_years_partitioned
where companyname_partition = 'DIRECTV'
