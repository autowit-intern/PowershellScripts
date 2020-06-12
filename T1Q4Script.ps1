# This script will show the NIC info of your current computer and output it to
# a text file and will also show the current global variables on your computer
# and append it to the text file.

ipconfig > PCinfo.txt



get-variable -scope global >> PCinfo.txt

 