#!/bin/bash
set -euxo pipefail


# Update & install httpd + git
sudo yum -y update
sudo yum -y install httpd git


# Aktifkan httpd
sudo systemctl enable httpd
sudo systemctl start httpd


# Deploy app dari GitHub
APP_DIR="/var/www/html"
if [ ! -d "$APP_DIR" ]; then
sudo mkdir -p "$APP_DIR"
fi
sudo chown -R ec2-user:ec2-user "$APP_DIR"


# clone pertama kali jika belum ada .git
if [ ! -d "$APP_DIR/.git" ]; then
git clone --branch "${branch}" "${repo_url}" "$APP_DIR"
else
cd "$APP_DIR" && git fetch origin "${branch}" && git checkout "${branch}" && git pull
fi


# Jika app/ ada di repo, copy index.html ke root html
if [ -f "$APP_DIR/app/index.html" ]; then
cp "$APP_DIR/app/index.html" "$APP_DIR/index.html"
fi


sudo systemctl restart httpd


# BONUS: Self-hosted GitHub Runner (opsional)
if [ -n "${github_repo}" ] && [ -n "${github_runner_token}" ]; then
cd /home/ec2-user
RUNNER_DIR="actions-runner"
if [ ! -d "$RUNNER_DIR" ]; then
LATEST_URL=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | grep browser_download_url | grep linux-x64 | cut -d '"' -f4)
curl -L "$LATEST_URL" -o actions-runner-linux-x64.tar.gz
mkdir -p "$RUNNER_DIR"
tar xzf actions-runner-linux-x64.tar.gz -C "$RUNNER_DIR"
rm -f actions-runner-linux-x64.tar.gz
fi
cd "$RUNNER_DIR"


sudo -u ec2-user ./config.sh --url "https://github.com/${github_repo}" --token "${github_runner_token}" --name "ec2-${HOSTNAME}" --runnergroup "Default" --labels ec2,web --work _work --unattended --replace
sudo ./svc.sh install ec2-user
sudo ./svc.sh start
fi