#!/bin/bash

# Change to the home directory
cd ~

# Prompt the user for the path to the places file
read -p "Enter the path to the places file, or press enter to search for it automatically: " PLACES_PATH

# If the user didn't enter a path, search for the places file in the default Firefox profile directory
if [ -z "$PLACES_PATH" ]; then
  FIREFOX_PROFILE=$(find ~/.mozilla/firefox -maxdepth 1 -type d -name "*.default*" | head -n 1)
  PLACES_PATH="$FIREFOX_PROFILE/places.sqlite"
fi

# Get a list of all the tables in the database
TABLES=$(sqlite3 "$PLACES_PATH" ".tables")

# Set the output mode to XML
echo ".mode xml"

# Loop over each table and output its contents to an XML file
for table in $TABLES; do
  echo ".output ${table}.xml"
  echo "SELECT * FROM ${table};"
done | sqlite3 "$PLACES_PATH"
