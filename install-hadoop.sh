#!/bin/bash

echo "========================================="
echo " Hadoop 3.4.x Automated Installation"
echo " Ubuntu 24.04 Single Node Setup"
echo "========================================="

sleep 3

# -----------------------------
# Update System
# -----------------------------

echo "Updating system..."

sudo apt update -y
sudo apt upgrade -y

# -----------------------------
# Install Java
# -----------------------------

echo "Installing Java..."

sudo apt install openjdk-11-jdk -y

JAVA_HOME_PATH="/usr/lib/jvm/java-11-openjdk-amd64"

# -----------------------------
# Install SSH
# -----------------------------

echo "Installing SSH..."

sudo apt install ssh -y

sudo systemctl enable ssh
sudo systemctl start ssh

# -----------------------------
# Setup Passwordless SSH
# -----------------------------

echo "Configuring SSH..."

ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa

cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

ssh -o StrictHostKeyChecking=no localhost exit

# -----------------------------
# Download Hadoop
# -----------------------------

echo "Downloading Hadoop..."

cd ~

wget https://downloads.apache.org/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz

tar -xzf hadoop-3.4.0.tar.gz

mv hadoop-3.4.0 hadoop

# -----------------------------
# Environment Variables
# -----------------------------

echo "Setting environment variables..."

cat <<EOF >> ~/.bashrc

#HADOOP VARIABLES START
export JAVA_HOME=$JAVA_HOME_PATH
export HADOOP_HOME=\$HOME/hadoop
export HADOOP_INSTALL=\$HADOOP_HOME
export HADOOP_MAPRED_HOME=\$HADOOP_HOME
export HADOOP_COMMON_HOME=\$HADOOP_HOME
export HADOOP_HDFS_HOME=\$HADOOP_HOME
export YARN_HOME=\$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native
export PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin
#HADOOP VARIABLES END

EOF

source ~/.bashrc

# -----------------------------
# Configure Hadoop
# -----------------------------

cd ~/hadoop/etc/hadoop

echo "Configuring Hadoop..."

# core-site.xml

cat <<EOF > core-site.xml
<configuration>
 <property>
  <name>fs.defaultFS</name>
  <value>hdfs://localhost:9000</value>
 </property>
</configuration>
EOF


# hdfs-site.xml

cat <<EOF > hdfs-site.xml
<configuration>

 <property>
  <name>dfs.replication</name>
  <value>1</value>
 </property>

 <property>
  <name>dfs.name.dir</name>
  <value>file://$HOME/hadoopdata/hdfs/namenode</value>
 </property>

 <property>
  <name>dfs.data.dir</name>
  <value>file://$HOME/hadoopdata/hdfs/datanode</value>
 </property>

</configuration>
EOF


# mapred-site.xml

cp mapred-site.xml.template mapred-site.xml

cat <<EOF > mapred-site.xml
<configuration>
 <property>
  <name>mapreduce.framework.name</name>
  <value>yarn</value>
 </property>
</configuration>
EOF


# yarn-site.xml

cat <<EOF > yarn-site.xml
<configuration>

 <property>
  <name>yarn.nodemanager.aux-services</name>
  <value>mapreduce_shuffle</value>
 </property>

</configuration>
EOF


# -----------------------------
# Configure JAVA_HOME
# -----------------------------

sed -i "s|export JAVA_HOME=.*|export JAVA_HOME=$JAVA_HOME_PATH|" ~/hadoop/etc/hadoop/hadoop-env.sh

# -----------------------------
# Create HDFS directories
# -----------------------------

mkdir -p ~/hadoopdata/hdfs/namenode
mkdir -p ~/hadoopdata/hdfs/datanode

# -----------------------------
# Format NameNode
# -----------------------------

echo "Formatting NameNode..."

hdfs namenode -format

# -----------------------------
# Start Hadoop
# -----------------------------

echo "Starting Hadoop..."

start-dfs.sh
start-yarn.sh

sleep 5

echo ""
echo "========================================="
echo " Hadoop Installed Successfully"
echo "========================================="
echo ""

jps

echo ""
echo "NameNode UI:"
echo "http://localhost:9870"
echo ""

echo "YARN UI:"
echo "http://localhost:8088"
echo ""

echo "Test HDFS:"
echo "hdfs dfs -ls /"
echo ""
