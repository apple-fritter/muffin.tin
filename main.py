import os

# Get the path from the user
print("Please enter the path to search for the prefs.js file.")
print("If you want to search recursively from the root directory of a drive, enter the drive letter (e.g., 'C:')")
path = input("Path or drive letter: ")

# Check if it's a valid drive letter and prompt to search recursively
if os.path.isdir(path):
    recursive_search = input("Do you want to search recursively from the root directory? (y/n) ")
    if recursive_search.lower() == 'y':
        path = path + '\\'
else:
    print("Invalid path or drive letter. Exiting program.")
    quit()

# Prompt for CSV filename and open file
csv_filename = input("Please enter the filename for the CSV list of preferences to remove: ")
try:
    with open(csv_filename, 'r') as f:
        prefs_list = f.read().splitlines()
except FileNotFoundError:
    print("File not found. Exiting program.")
    quit()

# Find the prefs.js file in the directory
prefs_path = None
for root, dirs, files in os.walk(path):
    if 'prefs.js' in files:
        prefs_path = os.path.join(root, 'prefs.js')
        break

if prefs_path:
    # Remove the preferences from the file
    with open(prefs_path, 'r+') as f:
        lines = f.readlines()
        f.seek(0)
        for line in lines:
            for pref in prefs_list:
                if pref in line:
                    break
            else:
                f.write(line)
        f.truncate()

    print("Preferences removed successfully.")
else:
    print("prefs.js file not found in directory. Exiting program.")
