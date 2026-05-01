#!/bin/sh
# setup-host1.sh — runs when the student ENTERS module-05 or clicks Next (after validation passes).
# Resets state so the demo is repeatable on re-entry.
rm -f /tmp/lab-complete
echo "module-05 ready" >> /tmp/progress.log
