import argparse
import csv
import os
import shutil

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--Input", help="Location of directory to separate")
parser.add_argument("-o", "--Output", help="Location of new directory to put")
parser.add_argument("-c", "--Csv", help="Location of csv")
args = parser.parse_args()

os.makedirs(args.Output, exist_ok=True)

with open(args.Csv) as csvfile:
    spamreader = csv.reader(csvfile)
    for row in spamreader:
        ICSD_code = row[1]
        latest = row[6].strip()
        if latest == "False":
            shutil.move(os.path.join(args.Input, str(ICSD_code)), os.path.join(args.Output, str(ICSD_code)))
