-- 2_2 Creating Aggregates in Hive

-- move the sales files to the /user/cloudera/raw/sales folder in hdfs
cd ~/hadoop_for_ds
hadoop fs -put data/sales-yearly/* /raw/sales

-- put csv-serde file into hdfs directory /user/cloudera/
hadoop fs -put setup/csv-serde-1.1.2-0.11.0-all.jar /user/cloudera

-- switch to hue and run this in hive to install csv serde
add jar hdfs:///user/cloudera/csv-serde-1.1.2-0.11.0-all.jar;
 
-- setup back_office database
create database back_office;
use back_office;
 
create external table stage_sales (
    RowID string,
    OrderID string,
    OrderDate string,
    OrderMonthYear string,
    Quantity string,
    Quote string,
    DiscountPct string,
    Rate string,
    SaleAmount string,
    CustomerName string,
    CompanyName string,
    Sector string,
    Industry string,
    City string,
    ZipCode string,
    State string,
    Region string,
    ProjectCompleteDate string,
    DaystoComplete string,
    ProductKey string,
    ProductCategory string,
    ProductSubCategory string,
    Consultant string,
    Manager string,
    HourlyWage string,
    RowCount string,
    WageMargin string)
row format serde 'com.bizo.hive.serde.csv.CSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar"     = '"',
  "escapeChar"    = "\\"
)
LOCATION '/raw/sales/';

-- query table to see data
select * from back_office.stage_sales;

-- create monthly sales aggregated table
create table back_office.monthly_sales_totals 
stored as parquet
tblproperties('parquet.compression'='SNAPPY') as
select companyname
, ordermonthyear
, sum(saleamount) as sale_total
from stage_sales
group by companyname
,ordermonthyear

-- view results of the table
select *
from back_office.monthly_sales_totals
