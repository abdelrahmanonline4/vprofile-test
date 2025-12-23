#!/bin/bash

sudo -i 

# Update package lists
echo "Updating package lists..."
apt update

# Install Nginx
echo "Installing Nginx..."
apt install nginx -y

# Create Nginx configuration file for vproapp
echo "Creating Nginx configuration file for vproapp..."
cat <<EOL > /etc/nginx/sites-available/vproapp
upstream vproapp {
    server app01.vprofile:8080;
}
server {
    listen 80;
    location / {
        proxy_pass http://vproapp;
    }
}
EOL

# Remove default Nginx configuration
echo "Removing default Nginx configuration..."
rm -rf /etc/nginx/sites-enabled/default

# Create symlink to activate vproapp site
echo "Creating symlink to activate vproapp site..."
ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp

# Restart Nginx
echo "Restarting Nginx..."
systemctl restart nginx

echo "Nginx setup and configuration is complete."

