#!/bin/bash

# Update apt
echo "Updating apt..."
sudo apt update

# Install unzip package
echo "Installing unzip package..."
sudo apt install -y unzip

# Install apache2
echo "Installing apache2..."
sudo apt install -y apache2

# Install PHP and required modules
echo "Installing PHP and required modules..."
sudo apt install -y php libapache2-mod-php php-dev php-bcmath php-intl php-soap php-zip php-curl php-mbstring php-mysql php-gd php-xml

# Define variables
JOOMLA_ZIP="Joomla_3.7.0-Stable-Full_Package.zip"
INSTALL_DIR="/var/www/html"

# Check if Joomla zip file exists
if [ ! -f "$JOOMLA_ZIP" ]; then
    echo "Error: Joomla zip file '$JOOMLA_ZIP' not found."
    exit 1
fi

# Remove current index.html file in /var/www/html
echo "Removing current index.html file in /var/www/html..."
sudo rm -f "$INSTALL_DIR"/index.html

# Unzip Joomla
echo "Unzipping Joomla..."
unzip "$JOOMLA_ZIP" -d /var/www/html

# Set proper permissions
echo "Setting permissions..."
sudo chown -R www-data:www-data "$INSTALL_DIR"
sudo chmod -R 755 "$INSTALL_DIR"

# Enable and restart apache2
echo "Enabling and restarting Apache2..."
sudo systemctl enable apache2
sudo systemctl restart apache2

# Install MySQL Server
echo "Installing MySQL Server..."
sudo apt-get install mysql-server -y

# Set up MySQL with root user and password 'password'
echo "Setting up MySQL..."
sudo mysql <<MYSQL_SCRIPT
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

# Create a database named 'joomla'
echo "Creating Joomla database..."
sudo mysql -u root -p'password' -e "CREATE DATABASE IF NOT EXISTS joomla;"

echo "Joomla installation completed successfully."
