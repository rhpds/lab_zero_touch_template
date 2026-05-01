#!/bin/bash
# setup-host1.sh — provisioning-time setup script for the 'host1' VM.
#
# This script runs AFTER AgnosticD has already provisioned the VM. For VMs in
# the 'bastions' or 'nodes' AnsibleGroup, AgnosticD has already completed:
#   - Satellite registration (do NOT re-register here)
#   - Common package installation
#   - SSH user and sudo setup
#
# DNF is ready to use — Satellite repos are already configured.
# To install additional packages, use: dnf install -y <package>
#
# Env vars available in this script (injected by the zerotouch platform):
#   BASTION_HOST      — SSH hostname used to connect to this VM
#   BASTION_PORT      — SSH port (high NodePort, not 22)
#   BASTION_USER      — SSH login user (typically 'rhel')
#   BASTION_PASSWORD  — SSH password (same as common_password)
#   GUID              — Unique lab GUID (also available as {guid} in .adoc)
#   common_password   — Lab user password

USER=rhel

echo "Adding $USER to wheel group" > /root/post-run.log
usermod -aG wheel "$USER"

# Example: install packages (Satellite is already registered)
# dnf install -y nc git curl

echo "Setup of host1 complete" >> /root/post-run.log
chmod 666 /root/post-run.log
