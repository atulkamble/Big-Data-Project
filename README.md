# Basic Big Data Project

## Project: Website Log Analysis using Hadoop & Python

## 1. Project Overview

This project analyzes **large website log files** to identify:

* Most visited pages
* Top IP addresses
* Error rates (404, 500)
* Traffic patterns

This demonstrates **how Big Data tools process large datasets efficiently**.

---

# 2. Architecture

```
Users
   │
Website / Application Logs
   │
   ▼
HDFS (Hadoop Distributed File System)
   │
   ▼
MapReduce / Spark Processing
   │
   ▼
Data Analysis
   │
   ▼
Visualization (Python / Grafana / PowerBI)
```

---

# 3. Tools Used

| Tool              | Purpose                  |
| ----------------- | ------------------------ |
| Hadoop            | Distributed data storage |
| HDFS              | Store large log files    |
| MapReduce / Spark | Process large datasets   |
| Python            | Data analysis            |
| Linux             | Big data environment     |
| Grafana / PowerBI | Visualization            |

---

# 4. Dataset Example

Sample **web server log**

```
192.168.1.10 - - [10/Mar/2026:10:00:23] "GET /index.html HTTP/1.1" 200
192.168.1.15 - - [10/Mar/2026:10:01:10] "GET /login.html HTTP/1.1" 200
192.168.1.22 - - [10/Mar/2026:10:01:45] "GET /dashboard HTTP/1.1" 404
192.168.1.10 - - [10/Mar/2026:10:02:00] "GET /index.html HTTP/1.1" 200
```

---

# 5. Setup Environment

## Install Java

```
sudo apt update
sudo apt install openjdk-11-jdk -y
java -version
```

---

## Install Hadoop

Download Hadoop

```
wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
tar -xvf hadoop-3.3.6.tar.gz
```

Move to directory

```
cd hadoop-3.3.6
```

---

# 6. Start Hadoop

Format NameNode

```
bin/hdfs namenode -format
```

Start services

```
sbin/start-dfs.sh
sbin/start-yarn.sh
```

Check running services

```
jps
```

Expected output

```
NameNode
DataNode
ResourceManager
NodeManager
```

---

# 7. Upload Data to HDFS

Create directory

```
hdfs dfs -mkdir /logs
```

Upload log file

```
hdfs dfs -put weblog.txt /logs
```

Verify

```
hdfs dfs -ls /logs
```

---

# 8. Python Analysis Script

```
import pandas as pd

data = open("weblog.txt").readlines()

ips = []

for line in data:
    parts = line.split()
    ips.append(parts[0])

df = pd.DataFrame(ips, columns=["IP"])

print(df["IP"].value_counts())
```

Output example

```
192.168.1.10    2
192.168.1.15    1
192.168.1.22    1
```

---

# 9. Sample Analysis Questions

Students can analyze:

1️⃣ Top visited pages
2️⃣ Most active users
3️⃣ Error rate percentage
4️⃣ Peak traffic time
5️⃣ Most requested APIs

---

# 10. Project Output Example

```
Top Pages

/index.html     12000
/login.html     8500
/dashboard      6200

Top IP Addresses

192.168.1.10    5400
192.168.1.25    3200
```

---

# 11. Optional Visualization

Using **Python Matplotlib**

```
import matplotlib.pyplot as plt

pages = ["index","login","dashboard"]
visits = [12000,8500,6200]

plt.bar(pages, visits)
plt.title("Most Visited Pages")
plt.show()
```

---

# 12. Real Industry Use Cases

Big Data log analysis is used in:

* Netflix traffic analysis
* Amazon product analytics
* Cybersecurity threat detection
* Website performance monitoring
* Fraud detection

---

# 13. Cloud Version (Modern Approach)

Instead of Hadoop cluster locally:

| Cloud | Service                            |
| ----- | ---------------------------------- |
| AWS   | S3 + EMR + Athena                  |
| Azure | Data Lake + Data Factory + Synapse |
| GCP   | BigQuery + Dataproc                |

---

# 14. Resume Project Description

You can write:

> Designed a Big Data log analytics pipeline using Hadoop HDFS and Python to analyze large-scale web server logs and identify traffic patterns, error rates, and top user activity.

---
