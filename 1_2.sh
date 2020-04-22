# 1_2 Uploading files to HDFS




#upload single file to clients folder

hadoop fs -put ~/hadoop_for_ds/data/clients.csv /data/clients



#to see file in hdfs

hadoop fs -ls /data/clients



#upload single file to sales folder

hadoop fs -put ~/hadoop_for_ds/data/sales-yearly/CogsleyServices-SalesData-2009.csv /data/sales



#to see file in hdfs

hadoop fs -ls /data/sales



#download zip file and load into folder

cd ~/hadoop_for_ds
wget "https://s3.amazonaws.com/data.openaddresses.io/runs/152829/us/ca/san_diego.zip"

unzip san_diego.zip



#read the file to see what's in it

head -15 us/ca/san_diego.csv 



#make addresses folder in hdfs

hadoop fs -mkdir /data/addresses



#move csv from local to hdfs folder

hadoop fs -put ~/hadoop_for_ds/us/ca/san_diego.csv /data/addresses



#to see file in hdfs

hadoop fs -ls /data/addresses


