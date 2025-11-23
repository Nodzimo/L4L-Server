#!/bin/bash

screen -dmS l4l1 ./servers/l4l1/srcds_run -game left4dead2 +map c1m2_streets -port 27031 +hostname '"L4L2 #1 Vanillin++"'
screen -dmS l4l2 ./servers/l4l1/srcds_run -game left4dead2 +map c1m2_streets -port 27032 +hostname '"L4L2 #2 Vanillin++"'
screen -dmS l4l3 ./servers/l4l1/srcds_run -game left4dead2 +map c1m2_streets -port 27033 +hostname '"L4L2 #3 Vanillin++"'

echo "All L4L servers are up and running, GL & HF!"
