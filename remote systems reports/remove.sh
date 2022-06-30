#!/bin/bash
username=$1
ip_address=$2

rm -f /home/$username/$ip_address-system_report_$(date +\%d_%B_%Y)
