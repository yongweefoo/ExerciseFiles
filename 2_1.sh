# 2_1 Exploring Hive through Beeline



# Launch beeline

$ beeline



# Login to Hive

beeline> !connect jdbc:hive2://

scan complete in 2ms

Connecting to jdbc:hive2://

Enter username for jdbc:hive2://:

Enter password for jdbc:hive2://:

...
Connected to: Apache Hive (version 0.13.0-SNAPSHOT)

Driver: Hive JDBC (version 0.13.0-SNAPSHOT)

Transaction isolation: TRANSACTION_REPEATABLE_READ

0: jdbc:hive2://>


# show databases

0: jdbc:hive2://> show schemas;



# choose the default schema

0: jdbc:hive2://> use default;



# show tables inside the schema

0: jdbc:hive2://> show tables;



# describe a table

0: jdbc:hive2://> describe customers;



# query a table

0: jdbc:hive2://> select * from customers limit 10;

