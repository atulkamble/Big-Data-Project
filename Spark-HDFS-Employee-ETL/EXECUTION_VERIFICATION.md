# Verified Execution History — 2026-11-01

## Source and scope
Reviewed the user-provided Ubuntu shell history and Spark runtime logs. This report distinguishes observed execution from commands that were merely typed. The historical script (`/home/hadoop/employee_transform.py`) and the repository's newer `employee_transform.py` are **not identical**: the historical run wrote two CSV directories, whereas the repository version also writes Parquet and uses a different output root. Do not interpret the historical run as a test of the newer repository script.

## Environment confirmed from logs
- Ubuntu/Azure Linux kernel `7.0.0-1017-azure`, architecture `aarch64`.
- Spark `3.5.7`, Scala `2.12.18`, OpenJDK `11.0.32.1`.
- `SPARK_HOME=/home/hadoop/spark`; executable `/home/hadoop/spark/bin/spark-submit`.
- HDFS NameNode, DataNode and SecondaryNameNode; YARN ResourceManager and NodeManager observed in `jps`.
- Spark Master and Worker observed in `jps` (Master PID 8489, Worker PID 8556), but successful registration of the Worker with the Master is **not** demonstrated by `jps` alone.

## Historical command sequence
```bash
start-dfs.sh
start-yarn.sh
jps -l
hdfs dfs -mkdir -p /user/hadoop/input
hdfs dfs -put -f employees.csv /user/hadoop/input/
hdfs dfs -cat /user/hadoop/input/employees.csv
# Spark archive was downloaded, extracted, renamed to /home/hadoop/spark
source ~/.bashrc
spark-submit --version
$SPARK_HOME/sbin/start-master.sh
$SPARK_HOME/sbin/start-worker.sh spark://localhost:7077
jps
spark-submit --master yarn --deploy-mode client employee_transform.py
```

## Observed ETL results
- HDFS input actually read from `hdfs://localhost:9000/user/hadoop/input/employees.csv`.
- All 12 sample employee records displayed.
- High salary (> 60000): Rahul, Amit, Rohit, Vikas, Karan, Meera (6).
- 10% bonus, total salary and salary category displayed for all 12.
- Department aggregation displayed:

| Department | Count | Average salary |
|---|---:|---:|
| Sales | 2 | 46000 |
| HR | 2 | 46500 |
| Finance | 3 | 71000 |
| IT | 5 | 74400 |

- Two CSV write jobs committed to `/user/hadoop/output/employees` and `/user/hadoop/output/department_summary`; SparkContext stopped successfully at 07:09:46 (as recorded in the log).

## Critical deployment-mode qualification
The command used `--master yarn --deploy-mode client`, but the runtime reported `executor driver` and a driver-local executor, rather than clearly showing a YARN application master/executor allocation. The earlier script explicitly configured `.master("local[*]")`, which overrides the CLI selection. **Do not claim this run verified YARN execution.** The repository script intentionally omits a hard-coded master. To test YARN, run:
```bash
spark-submit --master yarn --deploy-mode client employee_transform.py
yarn application -list -appStates ALL
```
Check ResourceManager UI and YARN application logs for the matching application ID. For Standalone, use the exact Master URL displayed in the Master UI and verify Alive Workers >= 1.

## Spark UI investigation
- At 07:09:37 the Spark application UI started on `0.0.0.0:4040`.
- At 07:09:45 it stopped as the batch application completed. This explains why port 4040 was not visible later.
- A subsequent interactive session also started UI on 4040 at 07:11:18, but later shows keyboard interrupts and Py4J errors; do not present this as a successful interactive test.
- The Spark Master UI on 8080 is separate from the per-application UI on 4040. Use Spark History Server on 18080 for completed jobs.

## Additional warnings and checks
- `WARN NativeCodeLoader: Unable to load native-hadoop library` appeared; Spark continued and wrote output, so it was not fatal in this run.
- Logs show `^C` and `ERROR:root:Exception while sending command` during a later interactive test; these are not evidence that the earlier CSV ETL failed.
- The uploaded history does **not** prove the repository's Parquet output has been executed or that its new output directory exists.
- Do not publicly expose Spark 7077, 8080, 4040 or 18080. Prefer SSH tunnels.

## Verification commands for the current repository version
```bash
cd ~/Big-Data-Project/Spark-HDFS-Employee-ETL
export HADOOP_CONF_DIR=/home/hadoop/hadoop/etc/hadoop
hdfs dfs -test -e /user/hadoop/input/employees.csv && echo "HDFS input exists"
python3 -m py_compile employee_transform.py
spark-submit --master 'local[*]' employee_transform.py
hdfs dfs -ls -R /user/hadoop/output/employee-etl
hdfs dfs -cat /user/hadoop/output/employee-etl/department_summary/part-*.csv
```
These commands are **pending execution on the server**, not claimed as already run.
