#!/bin/bash

LOG_FILE="/var/log/rpi-temp-alert.log"
THRESHOLD=61000  # 61°C in millidegrees

while true; do
    TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)

    if [ "$TEMP" -gt "$THRESHOLD" ]; then
        TEMP_C=$(awk "BEGIN {print $TEMP/1000}")
        TIMESTAMP=$(date)

        echo "[WARN] High temperature detected: ${TEMP_C}°C at $TIMESTAMP" >> "$LOG_FILE"

        # Send terminal message to all users
        wall "🔥 $(hostname): High CPU temp detected: ${TEMP_C}°C at $TIMESTAMP"

        # Optional: send email
        echo "Pi CPU Temp: ${TEMP_C}°C at $TIMESTAMP" | mail -s "⚠️ Pi Temp Alert" example@domain.com
    fi

    sleep 30
done

