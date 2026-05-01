#!/bin/sh
# validation-host1.sh — runs when the user clicks Next on module-02.
# A non-zero exit code BLOCKS the user from advancing to the next module.
# Use this script to verify that the module's lab tasks have been completed.
echo "Validated module called module-02" >> /tmp/progress.log
