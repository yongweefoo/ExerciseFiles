# 1_4 Removing Files in HDFS



# deleting data from data/clients directory

hadoop fs -rm /data/clients/clients.csv



# check that the directory is now empty

hadoop fs -ls /data/clients



# could have also done the mv command that would copy then delete the existing file
hadoop fs -mv /data/clients/clients.csv /raw/clients



# try and delete the directory first and this will fail because it's not empty

hadoop fs -rmdir /data/sales



# you need to add the -R to the -rm command to delete recursively

hadoop fs -rm -R /data/sales



# to delete an empty folder do -rmdir

hadoop fs -mkdir /tmp_folder



# -rm wont work here without -R attribute

hadoop fs -rm /tmp_folder



# use -rmdir

hadoop fs -rmdir /tmp_folder



# you could also do a wildcard delete with the *

# this will delete all the files int he clients directory that starts with the string clients

hadoop fs -rm /data/clients/clients*