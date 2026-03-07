# 1️⃣ Create Project Folder

```bash
mkdir hadoop-log-project
cd hadoop-log-project
```

---

# 2️⃣ Create Dataset File

```bash
nano weblog.txt
```

Paste:

```
192.168.1.10 - - [10/Mar/2026:10:00:23] "GET /index.html HTTP/1.1" 200
192.168.1.15 - - [10/Mar/2026:10:01:10] "GET /login.html HTTP/1.1" 200
192.168.1.22 - - [10/Mar/2026:10:01:45] "GET /dashboard HTTP/1.1" 404
192.168.1.10 - - [10/Mar/2026:10:02:00] "GET /index.html HTTP/1.1" 200
```

Save.

---

# 3️⃣ Create Python Analysis Script

```bash
nano analyze_logs.py
```

Paste:

```python
import pandas as pd

data = open("weblog.txt").readlines()

ips = []
pages = []
status = []

for line in data:
    parts = line.split()

    if len(parts) < 8:
        continue

    ips.append(parts[0])
    pages.append(parts[5])
    status.append(parts[7])

df = pd.DataFrame({
    "IP": ips,
    "Page": pages,
    "Status": status
})

print("\nTop IPs")
print(df["IP"].value_counts())

print("\nTop Pages")
print(df["Page"].value_counts())

print("\nError Count")
print(df[df["Status"] != "200"].value_counts())
```

Save.

---

# 4️⃣ Install Python Dependencies

```bash
sudo apt update
sudo apt install python3-pip -y
pip3 install pandas matplotlib
pip3 install pandas matplotlib --break-system-packages
pip3 install pandas
pip3 install pandas --break-system-packages
```

verify installation 
```
python3 -c "import pandas; print(pandas.__version__)"
```
---

# 5️⃣ Upload File to HDFS

Create directory

```bash
hdfs dfs -mkdir /logs
```

Upload log file

```bash
hdfs dfs -put weblog.txt /logs
```

Verify

```bash
hdfs dfs -ls /logs
```

---

# 6️⃣ Run Python Analysis

```bash
python3 analyze_logs.py
```

---

# 7️⃣ Optional: View File from HDFS

```bash
hdfs dfs -cat /logs/weblog.txt
```

---

# 8️⃣ Project Structure

```
hadoop-log-project
│
├── weblog.txt
└── analyze_logs.py
```

---
