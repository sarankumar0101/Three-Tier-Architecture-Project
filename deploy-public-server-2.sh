#!/usr/bin/env bash
set -euo pipefail

# Run this script on the intended Ubuntu EC2 instance after cloning/copying the repository.
REPO_DIR="${REPO_DIR:-$HOME/aws-3-tier-architecture}"
SOURCE="$REPO_DIR/website/public-server-2/index.html"

if [[ ! -f "$SOURCE" ]]; then
  echo "Cannot find $SOURCE. Set REPO_DIR to the repository directory." >&2
  exit 1
fi

sudo apt-get update
sudo apt-get install -y nginx
sudo install -m 0644 "$SOURCE" /var/www/html/index.html
sudo systemctl enable --now nginx
curl -I http://localhost
