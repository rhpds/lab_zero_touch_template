#!/bin/sh
# solve-host1.sh — runs when the student clicks the Solve button on module-05.
# Creates the file on the student's behalf so they can advance.
touch /tmp/lab-complete
echo "Solved: created /tmp/lab-complete" >> /tmp/progress.log
