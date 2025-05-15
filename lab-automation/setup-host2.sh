#!/bin/bash
USER=rhel

echo "Adding wheel" > /root/post-run.log
usermod -aG wheel rhel

echo "Setup vm host2" > /tmp/progress.log

chmod 666 /tmp/progress.log 

#dnf install -y nc

