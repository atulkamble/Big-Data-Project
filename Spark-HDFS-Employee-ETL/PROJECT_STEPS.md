# Project Guide — Hadoop HDFS to Spark Employee ETL

## Goal
Create sample employee data, upload to HDFS, process with PySpark, filter/aggregate/transform and write CSV + Parquet back to HDFS.

## Prerequisites
Ubuntu with running NameNode/DataNode, Spark 3.5.x, compatible Java/Python, and Hadoop configuration available. Standalone requires a registered Worker, but local mode does not.

## 1. Get project
```bash
git clone https://github.com/atulkamble/Big-Data-Project.git
cd Big-Data-Project/Spark-HDFS-Employee-ETL
ls
```

## 2. Inspect input
```bash
head employees.csv
wc -l employees.csv    # 13 lines including header
```

## 3. Upload to HDFS
```bash
jps
hdfs dfsadmin -report
hdfs dfs -mkdir -p /user/hadoop/input
hdfs dfs -put -f employees.csv /user/hadoop/input/
hdfs dfs -ls /user/hadoop/input/
hdfs dfs -cat /user/hadoop/input/employees.csv
```

## 4. Configure environment
```bash
export SPARK_HOME=/home/hadoop/spark
export HADOOP_CONF_DIR=/home/hadoop/hadoop/etc/hadoop
export PATH="$SPARK_HOME/bin:$PATH"
spark-submit --version
```

## 5. Submit job (choose one)
Local:
```bash
spark-submit --master 'local[*]' employee_transform.py
```
Spark Standalone (Worker required):
```bash
spark-submit --master spark://MASTER_HOST:7077 --deploy-mode client employee_transform.py
```
Hadoop YARN:
```bash
spark-submit --master yarn --deploy-mode client employee_transform.py
```
Optional after script name: `--input hdfs:///path.csv --output hdfs:///path/output`. Script intentionally does not hard-code `.master()`.

## 6. ETL operations
1. Parse with explicit schema.
2. Drop missing required values; deduplicate employee IDs.
3. Calculate 10% salary bonus.
4. Calculate total salary.
5. Salary tiers: High >=80000, Medium >=50000, otherwise Low.
6. Show filtered employees with salary >60000.
7. Compute employee counts and average salary per department.
8. Write transformed CSV and Parquet and department summary CSV.

## 7. Verify outputs
```bash
hdfs dfs -ls -R /user/hadoop/output/employee-etl
hdfs dfs -cat /user/hadoop/output/employee-etl/employees_csv/part-*.csv
hdfs dfs -cat /user/hadoop/output/employee-etl/department_summary/part-*.csv
hdfs dfs -du -h /user/hadoop/output/employee-etl/employees_csv
hdfs dfs -du -h /user/hadoop/output/employee-etl/employees_parquet
```
Parquet is binary: use Spark to read it rather than `hdfs dfs -cat`.

## Expected department aggregates
| Department | Employees | Average salary |
|---|---:|---:|
| Finance | 3 | 71000 |
| HR | 2 | 46500 |
| IT | 5 | 74400 |
| Sales | 2 | 46000 |

Example: Rahul salary 65000, bonus 6500, total 71500, category Medium.

## Dashboards
- NameNode `:9870`
- Spark Master `:8080`
- Spark application `:4040` while application active
- Spark History `:18080` if configured
- YARN `:8088`

Use SSH tunneling for remote Azure access.

## Troubleshooting
- Zero Standalone Workers: start Worker with exact Master URL.
- 4040 empty: job completed; use History Server for finished jobs.
- HDFS failures: verify Hadoop config and NameNode services.
- HDFS permission errors: confirm write rights under output parent.

## Cleanup (optional)
```bash
hdfs dfs -rm -r /user/hadoop/output/employee-etl
```

## Exercises
Increase IT salaries by 15%; group by city; find min/max salaries; filter experience >5; partition Parquet by department.
