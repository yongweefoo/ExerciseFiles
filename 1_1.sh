# 1_1 Organizing Files in HDFS



#copy exercise files to local dir instead of shared folder

mkdir hadoop_for_ds

cp -rf /media/sf_Exercise_Files/* hadoop_for_ds/

cd hadoop_for_ds/



#move to proper directory to see files that you set up using cd

cd /home/cloudera/hadoop_for_ds



#let's take a look at what files are in this directory

ls -l



#take a look a file using cat

cat data/clients.csv



#if you only wanna look at the first 15 lines of a file you use head

head -15 data/clients.csv



#if you wanna look at the last 15 lines of a file you use tail

tail -15 data/clients.csv



#create some directories to store our data

hadoop fs -mkdir /data

hadoop fs -mkdir /data/sales

hadoop fs -mkdir /data/clients



#to see the folders

hadoop fs -ls /data
