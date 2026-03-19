#!/bin/bash

# =============================================================================
# setup.sh - Environment Setup Script for Node.js/Express Application
# Course: 502094 - Software Deployment, Operations and Maintenance
# Description: This script installs all required dependencies and prepares
#              the runtime environment on a fresh Ubuntu server.
# =============================================================================

set -e  # Exit immediately if any command fails

echo "============================================="
echo " Starting environment setup..."
echo "============================================="

# -----------------------------------------------------------------------------
# STEP 1: Update system packages
# -----------------------------------------------------------------------------
echo "[1/6] Updating system package list..."
sudo apt-get update -y
echo "✓ System packages updated."

# -----------------------------------------------------------------------------
# STEP 2: Install essential OS packages
# -----------------------------------------------------------------------------
echo "[2/6] Installing essential OS packages..."
sudo apt-get install -y curl wget git build-essential
echo "✓ Essential packages installed."

# -----------------------------------------------------------------------------
# STEP 3: Install Node.js 20.x (LTS)
# -----------------------------------------------------------------------------
echo "[3/6] Installing Node.js 20.x..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
echo "✓ Node.js $(node --version) installed."
echo "✓ npm $(npm --version) installed."

# -----------------------------------------------------------------------------
# STEP 4: Install MongoDB 7.0
# -----------------------------------------------------------------------------
echo "[4/6] Installing MongoDB 7.0..."
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
    sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] \
    https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | \
    sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt-get update -y
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
echo "✓ MongoDB $(mongod --version | head -1) installed and started."

# -----------------------------------------------------------------------------
# STEP 5: Install PM2 (Process Manager)
# -----------------------------------------------------------------------------
echo "[5/6] Installing PM2 process manager..."
sudo npm install -g pm2
echo "✓ PM2 $(pm2 --version) installed."

# -----------------------------------------------------------------------------
# STEP 6: Create required application directories
# -----------------------------------------------------------------------------
echo "[6/6] Creating application directories..."
mkdir -p ~/app/public/uploads
mkdir -p ~/app/logs
echo "✓ Directories created."

# -----------------------------------------------------------------------------
# DONE
# -----------------------------------------------------------------------------
echo ""
echo "============================================="
echo " Setup completed successfully!"
echo "============================================="
echo " Node.js : $(node --version)"
echo " npm     : $(npm --version)"
echo " PM2     : $(pm2 --version)"
echo " MongoDB : $(mongod --version | head -1)"
echo "============================================="
echo " Next steps:"
echo "  1. Clone your repository to ~/app"
echo "  2. Copy .env file with your configuration"
echo "  3. Run: npm install"
echo "  4. Run: pm2 start main.js --name myapp"
echo "============================================="