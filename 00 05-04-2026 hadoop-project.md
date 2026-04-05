# 🚀 Hadoop Project: Log Analysis using HDFS + MapReduce

---

## 🎯 Project Objective

Build a Hadoop-based system to:

* Store logs in HDFS
* Process logs using MapReduce
* Analyze:

  * Request count
  * Frequent IPs
  * Error logs (404, 500)

---

## 🏗️ Architecture Overview

![Image](https://dezyre.gumlet.io/images/blog/hadoop-architecture-explained-what-it-is-and-why-it-matters/image_580020975231762189993829.png?dpr=2.6\&w=376)

![Image](https://hadoop.apache.org/docs/r3.2.3/hadoop-project-dist/hadoop-hdfs/images/hdfsarchitecture.png)

![Image](https://www.researchgate.net/publication/353478860/figure/fig1/AS%3A1050027459887105%401627357463922/The-three-phases-of-the-MapReduce-model-map-shuffle-reduce.ppm)

![Image](https://www.todaysoftmag.com/images/articles/tsm33/large/a11.png)

### 🔄 Flow

```
Logs → HDFS → MapReduce → Output → Analysis
```

---

# 📚 THEORY SECTION (IMPORTANT)

---

## 🧠 What is Hadoop?

👉 Hadoop is an open-source framework for:

* **Distributed Storage → HDFS**
* **Distributed Processing → MapReduce**
* **Resource Management → YARN**

---

## 📌 Core Components

| Component | Description                |
| --------- | -------------------------- |
| HDFS      | Distributed storage system |
| NameNode  | Metadata manager (master)  |
| DataNode  | Stores actual data         |
| YARN      | Resource manager           |
| MapReduce | Processing engine          |

---

## ⚙️ HDFS Concepts

![Image](https://hadoop.apache.org/docs/r1.2.1/images/hdfsdatanodes.gif)

![Image](https://hadoop.apache.org/docs/r3.2.3/hadoop-project-dist/hadoop-hdfs/images/hdfsarchitecture.png)

![Image](https://i.sstatic.net/7yiEs.gif)

![Image](https://miro.medium.com/v2/resize%3Afit%3A1200/1%2ABo-7PxWyKQJMJYHDmf_cZg.png)

### Key Points

* Block size → **128 MB (default)**
* Replication → **3 copies**
* Fault tolerant system
* Write once, read many

---

## 🔄 MapReduce Working

![Image](https://www.researchgate.net/publication/353478860/figure/fig1/AS%3A1050027459887105%401627357463922/The-three-phases-of-the-MapReduce-model-map-shuffle-reduce.ppm)

![Image](https://miro.medium.com/1%2AV1dMlCNmvrgImGZKeqrVeA.png)

![Image](https://www.researchgate.net/publication/310036684/figure/fig3/AS%3A427911489560578%401479033457143/The-Hadoop-MapReduce-Pipeline.png)

![Image](https://www.researchgate.net/publication/330659087/figure/fig1/AS%3A719498785062924%401548553286925/Hadoop-MapReduce-Job-execution-flow.jpg)

### Steps

1. Input Split
2. Map
3. Shuffle & Sort
4. Reduce

---

## 🚀 Significance of Hadoop

### Why Hadoop?

* Handles **Big Data (TB → PB)**
* Distributed → Faster processing
* Scalable → Add nodes anytime
* Fault tolerant → Replication
* Cost-effective → Commodity hardware

---

## 🏢 Real Use Cases

* Log analysis ✔️
* Fraud detection
* Social media analytics
* IoT processing
* Recommendation engines

---

## ⚠️ Limitations

* Not real-time (batch system)
* High latency
* Complex setup
* Not ideal for small data

---

# 💻 PRACTICAL IMPLEMENTATION

---

## 📂 Step 1: Create Sample Data

```bash
nano access.log
```

```
192.168.1.1 - - [10/Apr/2026] "GET /index.html" 200
192.168.1.2 - - [10/Apr/2026] "GET /about.html" 404
192.168.1.1 - - [10/Apr/2026] "POST /login" 500
192.168.1.3 - - [10/Apr/2026] "GET /home" 200
```

---

## ⚙️ Step 2: Start Hadoop

```bash
start-dfs.sh
start-yarn.sh
jps
```

---

## 📁 Step 3: Upload to HDFS

```bash
hdfs dfs -mkdir /logs
hdfs dfs -put access.log /logs/
hdfs dfs -ls /logs
```

---

## 💻 Step 4: Run MapReduce (Word Count)

```bash
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar wordcount /logs /output
```

---

## 📤 Step 5: View Output

```bash
hdfs dfs -cat /output/part-r-00000
```

### Output Example

```
192.168.1.1  2
192.168.1.2  1
192.168.1.3  1
```

---

## 🔍 Step 6: Filter Error Logs

```bash
hdfs dfs -cat /logs/access.log | grep "404\|500"
```

---

## 🧠 Step 7: Hadoop Streaming (Advanced)

### mapper.py

```python
#!/usr/bin/env python3
import sys
for line in sys.stdin:
    ip = line.split()[0]
    print(f"{ip}\t1")
```

### reducer.py

```python
#!/usr/bin/env python3
import sys

current_ip = None
count = 0

for line in sys.stdin:
    ip, value = line.strip().split("\t")
    value = int(value)

    if current_ip == ip:
        count += value
    else:
        if current_ip:
            print(f"{current_ip}\t{count}")
        current_ip = ip
        count = value

if current_ip:
    print(f"{current_ip}\t{count}")
```

---

## ▶️ Run Streaming Job

```bash
chmod +x mapper.py reducer.py

hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming*.jar \
-input /logs \
-output /stream_output \
-mapper mapper.py \
-reducer reducer.py
```

---

## 📊 Output

```bash
hdfs dfs -cat /stream_output/part-00000
```

---

# 📊 VALIDATION

* NameNode UI → `http://<VM-IP>:9870`
* ResourceManager → `http://<VM-IP>:8088`

---

# 📌 THEORY + EXAM POINTS (VERY IMPORTANT)

---

## 🔥 One-Line Revision

* Hadoop = Storage + Processing
* HDFS = Distributed storage
* MapReduce = Batch processing
* YARN = Resource manager

---

## 🎯 Frequently Asked Questions

* Default replication factor? → **3**
* Who manages metadata? → **NameNode**
* Who stores data? → **DataNode**
* Processing model? → **MapReduce**

---

## 🧠 Key Terms

* Block
* Cluster
* Rack Awareness
* Heartbeat
* Replication

---

# ⭐ PROJECT SIGNIFICANCE

---

## 💼 What You Achieved

* Built distributed storage pipeline
* Processed large-scale logs
* Implemented parallel computing
* Simulated real-world analytics

---

## 🎯 Resume Line

> Implemented a Hadoop-based log analysis pipeline using HDFS and MapReduce for distributed data processing and analytics.

---

# 🚀 FUTURE ENHANCEMENTS

* Use **Apache Hive** → SQL queries
* Use **Apache Spark** → Faster processing
* Use **Apache Kafka** → Streaming
* Build dashboards with Grafana

---

# 📦 GITHUB STRUCTURE

```
hadoop-log-analysis/
│── data/
│── mapper.py
│── reducer.py
│── commands.sh
│── README.md
```

---

# ⚠️ FINAL POINTS TO REMEMBER

* Hadoop = Batch system
* Not real-time
* High scalability
* Fault tolerant
* Data locality concept

---
