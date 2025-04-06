#!/usr/bin/env bash

echo "Starting cups ..."
/etc/init.d/cups start

echo "Starting ssh server ..."
/etc/init.d/ssh start

echo "Starting Papercut event monitor ..."
/etc/init.d/papercut-event-monitor start

echo "Starting Papercut web print ..."
/etc/init.d/papercut-web-print start

echo "Starting Papercut service in console ..."
/etc/init.d/papercut console
