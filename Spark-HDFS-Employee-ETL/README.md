# Hadoop HDFS → Apache Spark Employee ETL Project

End-to-end lab for Spark 3.5.x, Hadoop HDFS and optionally YARN or Spark Standalone. Reads 12 employee CSV records, cleans data, calculates bonuses and total compensation, categorizes salary, filters high earners, summarizes departments, and writes CSV and Parquet to HDFS.

## Architecture
Local CSV → HDFS /user/hadoop/input → PySpark transformations → HDFS /user/hadoop/output/employee-etl

## Project files
- [Spark documentation](SPARK_GUIDE.md)
- [Complete project steps](PROJECT_STEPS.md)
- [Python ETL application](employee_transform.py)
- [Sample input](employees.csv)

## Quick start
```bash
export HADOOP_CONF_DIR=/home/hadoop/hadoop/etc/hadoop
hdfs dfs -mkdir -p /user/hadoop/input
hdfs dfs -put -f employees.csv /user/hadoop/input/
spark-submit --master 'local[*]' employee_transform.py
hdfs dfs -ls -R /user/hadoop/output/employee-etl
hdfs dfs -cat /user/hadoop/output/employee-etl/department_summary/part-*.csv
```

Standalone: `spark-submit --master spark://MASTER_HOST:7077 employee_transform.py` (requires connected Worker).
YARN: `spark-submit --master yarn --deploy-mode client employee_transform.py`.

Security: SSH-tunnel Spark dashboards; do not expose Spark RPC/UI ports publicly.
