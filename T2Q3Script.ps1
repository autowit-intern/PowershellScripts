# Goal for this script is to count the number of hard drives in the system, list space used in KB's and then list available space in MB's

# Counts number of disks in the system

(Get-Disk | Select-Object size).count

# Displays freespace in MB's and used space in KB's

Get-WmiObject win32_logicaldisk | Select-Object deviceid,freespace,size


