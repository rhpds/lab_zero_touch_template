#!/bin/sh
# validation-host1.sh — runs when you click Next on module-05.
# A non-zero exit code BLOCKS you from advancing to the next module.
if [ -f /tmp/lab-complete ]; then
  echo "Validation passed" >> /tmp/progress.log
  exit 0
else
  echo "Validation failed: /tmp/lab-complete not found" >> /tmp/progress.log
  exit 1
fi
