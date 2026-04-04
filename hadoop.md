# Install and Configure Latest Hadoop on Ubuntu 24.04
## 📌 VM Details

* OS: Ubuntu (Azure VM)
* Disk: SSD – 128GB
* Access: SSH using `.pem` key

---

## 🔐 Step 1: Connect to Azure VM

```bash
cd ~/Downloads
chmod 400 key.pem

ssh -i key.pem atul@20.63.49.28
```

👉 First time:

```bash
yes
```

---

## 1. Update System

```bash
sudo apt update -y
sudo apt list --upgradable 
sudo apt upgrade -y

```

---

# 2. Install Java (Required for Hadoop)

Hadoop requires **Java 8 or 11**.

Install OpenJDK 11:

```bash
sudo apt install openjdk-11-jdk -y
```

Verify:

```bash
java -version
```

Example output

```
openjdk version "11.0.x"
```

Find Java path:

```bash
readlink -f $(which java)
```

Example:

```
/usr/lib/jvm/java-11-openjdk-amd64/bin/java
```

So **JAVA_HOME**

```
/usr/lib/jvm/java-11-openjdk-amd64
```

---

# 3. Create Hadoop User (Recommended)

```bash
sudo adduser hadoop
```

Add sudo permission

```bash
sudo usermod -aG sudo hadoop
```
Set Password 
```
sudo passwd hadoop
```

Switch user

```bash
su - hadoop
```

---

# 4. Install SSH (Required)

```bash
sudo apt install ssh -y
```

Start service

```bash
sudo systemctl start ssh
sudo systemctl enable ssh
```

---

# 5. Configure Passwordless SSH

Generate key

```bash
ssh-keygen -t rsa
```

Press **Enter** for all prompts.

Add key

```bash
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

Set permissions

```bash
chmod 600 ~/.ssh/authorized_keys
```

Test SSH

```bash
ssh localhost
```

```
exit
```
---

# 6. Download Latest Hadoop (with same hadoop user)

Go to official mirror.

Download Hadoop:

```bash
wget https://downloads.apache.org/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz
```

Extract

```bash
tar -xvzf hadoop-3.4.0.tar.gz
```

Rename

```bash
mv hadoop-3.4.0 hadoop
```

Move to home

```
cd /home/hadoop/hadoop
```

---

# 7. Configure Environment Variables

Edit `.bashrc`

```bash
nano ~/.bashrc
```

Add at bottom paste after fi

```bash
#HADOOP VARIABLES START
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export HADOOP_HOME=/home/hadoop/hadoop
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
#HADOOP VARIABLES END
```

Apply changes

```bash
source ~/.bashrc
```

---

# 8. Configure Hadoop Files

Go to config directory

```bash
cd ~/hadoop/etc/hadoop
pwd
```
It should print >>
```
/home/hadoop/hadoop/etc/hadoop
```
---

# core-site.xml

```bash
sudo nano core-site.xml
```

Add

```xml
<configuration>

<property>
<name>fs.defaultFS</name>
<value>hdfs://localhost:9000</value>
</property>

</configuration>
```

---

# hdfs-site.xml

```bash
sudo nano hdfs-site.xml
```

Add

```xml
<configuration>

<property>
<name>dfs.replication</name>
<value>1</value>
</property>

<property>
<name>dfs.name.dir</name>
<value>file:///home/hadoop/hadoopdata/hdfs/namenode</value>
</property>

<property>
<name>dfs.data.dir</name>
<value>file:///home/hadoop/hadoopdata/hdfs/datanode</value>
</property>

</configuration>
```

---

# mapred-site.xml

```bash
sudo nano mapred-site.xml
```

Add

```xml
<configuration>

<property>
<name>mapreduce.framework.name</name>
<value>yarn</value>
</property>

</configuration>
```

---

# yarn-site.xml

```bash
sudo nano yarn-site.xml
```

Add

```xml
<configuration>

<property>
<name>yarn.nodemanager.aux-services</name>
<value>mapreduce_shuffle</value>
</property>

</configuration>
```

---

# 9. Configure JAVA_HOME in Hadoop

Edit

```bash
sudo nano /home/hadoop/hadoop/etc/hadoop/hadoop-env.sh
```

Set

```bash
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
```

---

# 10. Create HDFS Directories

```bash
mkdir -p ~/hadoopdata/hdfs/namenode
mkdir -p ~/hadoopdata/hdfs/datanode
```

---

# 11. Format NameNode

```bash
hdfs namenode -format
```

Expected output

```
Storage directory has been successfully formatted
```

---

# 12. Start Hadoop

Start HDFS

```bash
start-dfs.sh
```

Start YARN

```bash
start-yarn.sh
```

---

# 13. Verify Hadoop Services

```bash
jps
```

Expected

```
NameNode
SecondaryNameNode
DataNode
Jps
NodeManager
ResourceManager
```

---

# 14. Access Hadoop Web UI

### NameNode UI

```
http://localhost:9870
```
Example: AzureVM 
```
http://52.156.104.215:9870
```

### YARN UI

```
http://localhost:8088
```
Example: AzureVM 
```
http://52.156.104.215:8088
```
---

# 15. Test HDFS

Create directory

```bash
hdfs dfs -mkdir /test
```

List

```bash
hdfs dfs -ls /
```

---

# 16. Stop Hadoop

```bash
stop-yarn.sh
stop-dfs.sh
```

---

# Architecture (Single Node)

```
                +-------------------+
                |     NameNode      |
                +---------+---------+
                          |
          +---------------+---------------+
          |                               |
     +----v----+                    +-----v-----+
     | DataNode |                    | DataNode |
     +----------+                    +----------+

                YARN

     +----------------------+
     |   ResourceManager    |
     +----------+-----------+
                |
        +-------v-------+
        |  NodeManager  |
        +---------------+
```

---

# Important Hadoop Commands

| Command                | Description      |
| ---------------------- | ---------------- |
| `hdfs dfs -ls /`       | list HDFS files  |
| `hdfs dfs -mkdir /dir` | create directory |
| `hdfs dfs -put file /` | upload file      |
| `hdfs dfs -cat file`   | view file        |
| `hdfs dfs -rm file`    | delete file      |

---

# Common Issues

### JAVA_HOME Error

Fix

```bash
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
```

---

### SSH Permission Denied

Fix

```bash
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

---
