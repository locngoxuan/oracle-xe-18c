#!/bin/bash
/etc/init.d/oracle-xe-18c start
echo "Pres CTRL+C to stop..."
for (( ; ; ))
do
   sleep 3600
done
