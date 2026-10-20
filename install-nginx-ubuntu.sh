#!/usr/bin/env bash
set -euo pipefail

# Example for Ubuntu EC2 instances.
sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl enable --now nginx
sudo systemctl --no-pager --full status nginx
