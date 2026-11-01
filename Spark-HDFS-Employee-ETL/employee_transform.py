"""HDFS employee ETL: Spark 3.5.x."""
import argparse
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, IntegerType, StringType

schema = StructType([
    StructField("emp_id", IntegerType()),
    StructField("name", StringType()),
    StructField("department", StringType()),
    StructField("salary", IntegerType()),
    StructField("city", StringType()),
    StructField("experience", IntegerType()),
])

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", default="hdfs:///user/hadoop/input/employees.csv")
    parser.add_argument("--output", default="hdfs:///user/hadoop/output/employee-etl")
    args = parser.parse_args()
    spark = SparkSession.builder.appName("HDFS-Employee-ETL").getOrCreate()
    try:
        df = spark.read.option("header", True).schema(schema).csv(args.input)
        clean = df.dropna(subset=["emp_id", "name", "department", "salary"]).dropDuplicates(["emp_id"])
        transformed = (clean
            .withColumn("bonus", F.round(F.col("salary") * F.lit(0.10), 2))
            .withColumn("total_salary", F.round(F.col("salary") + F.col("bonus"), 2))
            .withColumn("salary_category", F.when(F.col("salary") >= 80000, "High")
                .when(F.col("salary") >= 50000, "Medium").otherwise("Low")))
        department_summary = (clean.groupBy("department")
            .agg(F.count("*").alias("employee_count"), F.round(F.avg("salary"), 2).alias("average_salary")))
        high_salary = clean.filter(F.col("salary") > 60000)
        transformed.show(truncate=False)
        department_summary.orderBy("department").show(truncate=False)
        high_salary.show(truncate=False)
        transformed.write.mode("overwrite").option("header", True).csv(f"{args.output}/employees_csv")
        transformed.write.mode("overwrite").parquet(f"{args.output}/employees_parquet")
        department_summary.write.mode("overwrite").option("header", True).csv(f"{args.output}/department_summary")
    finally:
        spark.stop()

if __name__ == "__main__":
    main()
