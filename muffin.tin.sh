#!/bin/bash

# Replace 'places.sqlite' with your database file path
db_file="places.sqlite"

# Check if the database file exists
if [ ! -f "$db_file" ]; then
  echo "Error: Database file '$db_file' not found."
  exit 1
fi

# Step 1: Extract table names using sqlite3
table_names=$(sqlite3 "$db_file" ".tables")

# Check if any tables are found in the database
if [ -z "$table_names" ]; then
  echo "No tables found in the database."
  exit 1
fi

# Set the table names as an environment variable
export TABLE_NAMES="$table_names"

# Create a new folder in the user's home directory with the specified subdirectory name
timestamp=$(date +"%Y%m%d%H%M%S")
output_folder="$HOME/places_tables_$timestamp"
mkdir -p "$output_folder"

# Step 2: Python code to export tables to XML files in the new folder
python3 << END_PYTHON_SCRIPT
import os
import sqlite3
import pandas as pd

db_file = "$db_file"
table_names = os.environ.get("TABLE_NAMES")
tables = table_names.split()

connection = sqlite3.connect(db_file)

for table in tables:
    query = f"SELECT * FROM {table}"
    df = pd.read_sql_query(query, connection)
    xml_filename = os.path.join("$output_folder", f"{table}.xml")
    df.to_xml(xml_filename, index=False)

connection.close()
END_PYTHON_SCRIPT
