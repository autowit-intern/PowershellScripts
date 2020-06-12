# This script will list names of all .exe files within your C:\ drive

get-childitem C:\ -Recurse | where {$_.extension -eq ".exe"}