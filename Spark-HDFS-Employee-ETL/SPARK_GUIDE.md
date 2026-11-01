# Apache Spark Documentation — Ubuntu + Hadoop

## Objectives
Understand Spark architecture, installation, deployment modes, dashboards, troubleshooting and HDFS integration.

## Spark concepts
- Driver: orchestrates computation.
- Executors: execute distributed tasks and cache results.
- Cluster manager: Spark Standalone Master/Workers or Hadoop YARN.
- DataFrames: structured distributed data; transformations are lazy until an action.
- Jobs, stages and tasks: scheduling hierarchy.

## Deployment modes
| Mode | Argument | Requirements |
|---|---|---|
| Local | `--master 'local[*]'` | Spark installed |
| Standalone | `--master spark://MASTER_HOST:7077` | Master and at least one Worker |
| YARN | `--master yarn` | Hadoop ResourceManager and NodeManager |

## Installation on Ubuntu
Check versions and paths:
```bash
java -version
python3 --version
which spark-submit || true
echo "$SPARK_HOME"
```
Get a Hadoop-3-compatible Spark 3.5.x release from https://spark.apache.org/downloads/. For an already downloaded `spark-3.5.7-bin-hadoop3.tgz` archive:
```bash
cd /home/hadoop
tar -xzf spark-3.5.7-bin-hadoop3.tgz
mv spark-3.5.7-bin-hadoop3 spark
```
Append to `~/.bashrc` (adjust paths):
```bash
export SPARK_HOME=/home/hadoop/spark
export HADOOP_CONF_DIR=/home/hadoop/hadoop/etc/hadoop
export PATH="$SPARK_HOME/bin:$PATH"
```
```bash
source ~/.bashrc
spark-submit --version
```

## Start Spark Standalone
```bash
$SPARK_HOME/sbin/start-master.sh
# Obtain exact master URL from Master UI
$SPARK_HOME/sbin/start-worker.sh spark://MASTER_HOST:7077
jps -l
```
Master can be ALIVE with zero workers; in that case start the Worker and inspect logs under `$SPARK_HOME/logs`. Spark does not have to appear in `jps` when local-mode apps are stopped.

## Dashboards
| Component | Port | Availability |
|---|---|---|
| Spark Master | 8080 | Master running |
| Spark Worker | 8081 | Worker running |
| Spark application | 4040 (sometimes 4041+) | Application running |
| Spark History | 18080 | History Server running |
| HDFS NameNode | 9870 | NameNode running |
| YARN ResourceManager | 8088 | ResourceManager running |

The 4040 UI disappears after a short application finishes. To examine it interactively:
```bash
pyspark --master 'local[*]'
```
Inside PySpark:
```python
spark.range(1000000).groupByExpr("id % 10").count().show()
```
Keep the shell open and visit port 4040.

For a remote Azure server, avoid opening Spark UI/RPC ports publicly. SSH tunnel:
```bash
ssh -L 4040:localhost:4040 -L 8080:localhost:8080 -L 18080:localhost:18080 USER@PUBLIC_VM_IP
```

## History Server
```bash
hdfs dfs -mkdir -p /spark-events
hdfs dfs -chmod 1777 /spark-events
```
In `$SPARK_HOME/conf/spark-defaults.conf`:
```properties
spark.eventLog.enabled true
spark.eventLog.dir hdfs:///spark-events
spark.history.fs.logDirectory hdfs:///spark-events
```
Then run `$SPARK_HOME/sbin/start-history-server.sh`. New applications log events and completed runs appear on port 18080.

## Troubleshooting
- `spark-submit: command not found`: verify installation and PATH.
- Master displays `Workers (0)`: connect Worker to exact Master RPC URL and check logs.
- 4040 unavailable: ensure application is active; check `ss -ltnp | grep 4040`.
- HDFS error: set `HADOOP_CONF_DIR`, confirm `fs.defaultFS` and HDFS availability.
- YARN failure: check `yarn node -list` and resource allocation.

References: https://spark.apache.org/docs/3.5.7/ and https://hadoop.apache.org/docs/.
