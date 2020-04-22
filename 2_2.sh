# 2_2 Access Hive from Python

# install pip
sudo yum install python-pip

# upgrade pip
sudo pip install --upgrade pip

# install needed libraries (it's gonna take a little bit to install)
sudo yum install gcc gcc-c++ make openssl-devel
sudo yum install python-devel.x86_64
sudo yum install cyrus-sasl-devel.x86_64

#install pyhs2
sudo pip install pyhs2

#install pandas (only available if it's python2.7+)
sudo pip install pandas

#go into python REPL
python
#then type in this and hit enter if there are no errors then it's working
import pyhs2

# to create a connection to hive from python
hive_connection = pyhs2.connect(host='localhost'
                               , port=10000
                               , authMechanism='PLAIN'
                               , user='cloudera'
                               , password='cloudera'
                               , database='default')

# then create a cursor
hive_cursor = hive_connection.cursor()

#run select top 10 records from existing categories table under default db
hive_cursor.execute('select * from default.customers limit 10')

#to fetch values from cursor run fetchall cmd it'll print the rows as a list
vals = hive_cursor.fetchall()

# print values on screen
for row in vals:
    print row


