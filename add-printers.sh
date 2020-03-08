#!/usr/bin/env bash
set -euo pipefail; [[ "${TRACE-}" ]] && set -x

wait-for-it.sh 127.0.0.1:631 -- echo 'CUPS is running'

PRINTERS="$(lpstat -p 2>/dev/null || true)"

if ! grep "printer Label_QL-500" > /dev/null <<< "$PRINTERS"; then
  echo 'Adding Label_QL-500'
  lpadmin -p Label_QL-500 -E \
          -v usb://Brother/QL-500?serial=F4Z731565 \
          -m ptouch:0/ppd/ptouch-driver/Brother-QL-500-ptouch.ppd \
          -o 'RollFedMedia=Roll' \
          -o 'PageSize=FloppyTape'
else
  echo "Label_QL-500 is already configured"
fi

if ! grep "printer Laser_HL-2030" > /dev/null <<< "$PRINTERS"; then
  echo 'Adding Laser_HL-2030'
  lpadmin -p Laser_HL-2030 -E \
          -v socket://192.168.0.1 \
          -m drv:///brlaser.drv/br2030.ppd
else
  echo "Laser_HL-2030 is already configured"
fi

echo 'Done'
