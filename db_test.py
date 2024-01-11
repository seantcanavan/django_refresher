import os

import psycopg2

DATABASE_HOST = os.getenv("DATABASE_HOST")
DATABASE_USER = os.getenv("DATABASE_USER")
DATABASE_PASS = os.getenv("DATABASE_PASS")

print("DB_TEST.PY: printing database creds")
print(DATABASE_USER, DATABASE_PASS, DATABASE_HOST)

print("DB_TEST.PY: printing all environment variables")

# Iterating over all environment variables and their values
for key, value in os.environ.items():
    print(f"{key}: {value}")

try:
    conn = psycopg2.connect(
        dbname="mydb", user=DATABASE_USER, password=DATABASE_PASS, host=DATABASE_HOST, port=5432
    )
    print("Connection successful")
except Exception as e:
    print(f"Error connecting to the database: {e}")
