import os
import argparse
import shutil
from datetime import date
	
# construct the argument parse and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-n", "--name", type=str,required=True,
	help="name of the project")
ap.add_argument("-v", "--number", type=str,
	help="number of the project")
ap.add_argument("-ax", "--xdc", type=str, default="./00-standard_example_dir/nexys4DDR.xdc",
	help="to set what is to copy the xdc file")
ap.add_argument("-an", "--author", type=str, default="João Amorim",
	help="to set author name")
ap.add_argument("-ae", "--author-email", type=str, default="joao-amorim@uergs.edu.br",
	help="to set author email")
ap.add_argument("-abs", "--abstract", type=str, default="This project is to do...",
	help="to set the project abstract")
ap.add_argument("-ar", "--add-readme", type=bool, default=True,
	help="to set is to create the readme files")
args = vars(ap.parse_args())

print()
# creating the dirs 
if args['number'] != None:
    dirName = args['number'] + "-" + args['name']
else:
    dirName = args['name']

dirNameSimu         = dirName +  "/simulation/"
dirNameSou          = dirName + "/sources/"
dirNameProject      = dirName + "/vivado_" + args['name']

try:
    # Create target Directory
    os.mkdir(dirName)
    print(f"Directory {dirName} Created ") 
except FileExistsError:
    print(f"Directory {dirName} already exists")

try:
    # Create target Directory
    os.mkdir(dirNameSimu)
    print(f"Directory {dirNameSimu} Created ") 
except FileExistsError:
    print(f"Directory {dirNameSimu} already exists")

try:
    # Create target Directory
    os.mkdir(dirNameSou)
    print(f"Directory {dirNameSou} Created ") 
except FileExistsError:
    print(f"Directory {dirNameSou} already exists")

try:
    # Create target Directory
    os.mkdir(dirNameProject)
    print(f"Directory {dirNameProject} Created ") 
except FileExistsError:
    print(f"Directory {dirNameProject} already exists")


# copy the xdc
try:
    shutil.copy2(args['xdc'], dirName)
    print(f"xdc file {args['xdc']} copied. ") 
except IOError as err:
    print(f"Unable to copy file. {err}")

# create a README
today = date.today()
try:
    f=open(dirName+"/README.md",'w+', encoding="utf-8")
    print("readme opened")

    # write the readme
    f.write(f"# {args['name']}\n")
    f.write(f"Author: {args['author']}\n\n")
    f.write(f"Author email: {args['author_email']}\n\n")
    # Month abbreviation, day and year	
    f.write(f"Date: {str(today.strftime('%b-%d-%Y'))}\n\n")
    f.write(f"**Abstract**\n\n {args['abstract']}\n")
    f.close()             #wrong variable name on this line
    print("readme closed")
except IOError as err:
    print(f"Unable to create readme file. {err}")