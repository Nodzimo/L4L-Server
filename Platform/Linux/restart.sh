#!/bin/bash

./shutdown.sh

sleep 5

./servers.sh

echo "All L4L servers have been restarted!"
