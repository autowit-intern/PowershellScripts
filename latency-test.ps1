# The goal of this script is to check latency of the current machine from the closest ICMP server to it
# by picking the closest server to you depending on your timezone

# ***** Requirements *******
# Must install azSpeedTest module to perform the latency test against different Azure datacenters

install-module -name AzSpeedTest

Import-Module AzSpeedTest

# Tests the latency of 4 different azure regions datacenters 
Test-AzRegionLatency -Region westus, ukwest, canadaeast, westindia -Iterations 50

