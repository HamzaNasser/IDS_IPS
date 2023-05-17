#!/bin/bash

# ANSI color codes
RED="\033[31m"
GREEN="\033[32m"
RESET="\033[0m"

# Print header
printf "%-15s | %-7s | %-7s | %-7s | %-17s | %-15s | %-15s | %-5s | %-5s | %-6s | %-4s | %-6s | %-6s\n" "Time" "Kernel" "IN" "OUT" "MAC" "SRC" "DST" "LEN" "TOS" "PREC" "TTL" "ID" "PROTO"
printf "%s\n" "--------------------------------------------------------------------------------------------------------------------"

# Function to parse and display the log entries
display_logs() {
    awk -v red="$RED" -v green="$GREEN" -v reset="$RESET" '/UFW (BLOCK|ALLOW)/ {
        time = $1 " " $2 " " $3;
        kernel = $4;
        color = (index($0, "UFW BLOCK") > 0) ? red : green;
        for(i = 5; i <= NF; i++) {
            if($i ~ /^IN=/) { in_iface = substr($i, 4) }
            if($i ~ /^OUT=/) { out_iface = substr($i, 5) }
            if($i ~ /^MAC=/) { mac = substr($i, 5) }
            if($i ~ /^SRC=/) { src = substr($i, 5) }
            if($i ~ /^DST=/) { dst = substr($i, 5) }
            if($i ~ /^LEN=/) { len = substr($i, 5) }
            if($i ~ /^TOS=/) { tos = substr($i, 5) }
            if($i ~ /^PREC=/) { prec = substr($i, 6) }
            if($i ~ /^TTL=/) { ttl = substr($i, 5) }
            if($i ~ /^ID=/) { id = substr($i, 4) }
            if($i ~ /^PROTO=/) { proto = substr($i, 7) }
        }
        printf("%s%-15s | %-7s | %-7s | %-7s | %-17s | %-15s | %-15s | %-5s | %-5s | %-6s | %-4s | %-6s | %-6s%s\n", color, time, kernel, in_iface, out_iface, mac, src, dst, len, tos, prec, ttl, id, proto, reset)
    }' /var/log/syslog | tac | head -n 10 | tac
}

# Continuously display logs every 5 seconds
while true; do
    clear
    display_logs
    sleep 5
done
