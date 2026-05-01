#!/bin/sh
# setup-host1.sh — runs when you enter module-05 or click Next (after validation passes).
# Resets state so the demo is repeatable on re-entry.
rm -f /tmp/lab-complete
echo "module-05 ready" >> /tmp/progress.log
