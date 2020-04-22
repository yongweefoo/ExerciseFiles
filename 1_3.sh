# 1_3 Moving Files in HDFS



# create a new directory called raw

hadoop fs -mkdir /raw



# make new directories under raw for sales and clients

hadoop fs -mkdir /raw/sales /raw/clients



# make a new directory for temp Files

hadoop fs -mkdir /tmp



# move old sales and clients data into new raw directories

hadoop fs -cp /data/clients/clients.csv /raw/clients

hadoop fs -cp /data/sales/CogsleyServices-SalesData-2009.csv /raw/sales



# check if the files got copied

hadoop fs -ls /raw/clients /raw/sales