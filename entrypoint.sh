#!/usr/bin/env bash

echo "Starting cups ..."
/etc/init.d/cups start

echo "Starting Papercut event monitor ..."
/etc/init.d/papercut-event-monitor start

echo "Starting Papercut service in console ..."
/etc/init.d/papercut console
