import os
import sys

DATABASE_HOST = os.getenv("DATABASE_HOST")
DATABASE_USER = os.getenv("DATABASE_USER")
DATABASE_PASS = os.getenv("DATABASE_PASS")

print('ENV_TEST-----------------')

if len(sys.argv) > 1:
    parameter = sys.argv[1]
    print("The command-line parameter is:", parameter)
else:
    print("No command-line parameter provided.")

print("ENV_TEST.PY: printing database creds")
print(DATABASE_USER, DATABASE_PASS, DATABASE_HOST)

print("ENV_TEST.PY: printing all environment variables")

# Iterating over all environment variables and their values
for key, value in os.environ.items():
    print(f"{key}: {value}")
