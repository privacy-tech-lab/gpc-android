import csv
import os

def csv_to_txt(csv_file, txt_file):
    with open(csv_file, 'r') as file:
        csv_reader = csv.reader(file)
        next(csv_reader)  # Skip the first row
        lines = [row[0] for row in csv_reader]

    with open(txt_file, 'w') as file:
        for line in lines:
            file.write(line + '\n')

directory = "/Users/nishantaggarwal/Documents/Apps/GAME_ACTION"


for filename in os.listdir(directory):
    if filename.endswith('.csv'):
        csv_file_path = os.path.join(directory, filename)
        base_filename = os.path.splitext(filename)[0]
        txt_file_path = os.path.join(directory, base_filename + '.txt')
        csv_to_txt(csv_file_path, txt_file_path)
