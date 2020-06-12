# This script will present you the first five global variables and enter it into a text file called globalvariables.txt
get-variable -scope global | Select-Object -first 5 > globalvariables.txt