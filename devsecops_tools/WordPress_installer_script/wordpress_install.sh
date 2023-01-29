#!/bin/bash

# Set variables
WORDPRESS_VERSION=6.1.1
DB_NAME=wp_services
DB_USER=`openssl rand -base64 16`
DB_PASS=`openssl rand -base64 32`
DOMAIN_NAME=services.armyids.com
WEB_ROOT=/var/www/services

# Create a directory to store the database credentials && wordpress dependency files
mkdir -p /home/admin/database_credentials && mkdir -p /var/www/services
touch /home/admin/database_credentials/wp_credentials.txt
chmod 700 /home/admin/database_credentials/wp_credentials.txt

# Store the database credentials in a file
echo "DB_USER=$DB_USER" >> /home/admin/database_credentials/wp_credentials.txt
echo "DB_PASS=$DB_PASS" >> /home/admin/database_credentials/wp_credentials.txt

# Download and extract WordPress
curl -O https://wordpress.org/latest.tar.gz && tar xzvf latest.tar.gz

# Copy WordPress files to web root directory
cp -r wordpress/* $WEB_ROOT && rm -r latest.tar.gz wordpress

# Set correct permissions for web root directory
chown -R www-data:www-data $WEB_ROOT

# Install all necessary applications
apt-get update && apt-get install -y nginx php7.4-fpm php-mysql mariadb-server software-properties-common certbot python3-certbot-nginx

# Secure MariaDB installation
mysql_secure_installation

# Create a new MySQL database and user

# Check if the database already exists
RESULT=$(mysql -u root -p -e "SHOW DATABASES LIKE '$DB_NAME';")

if [[ "$RESULT" == *"$DB_NAME"* ]]; then
  echo "The database '$DB_NAME' already exists. Deleting it now..."
  mysql -u root -p -e "DROP DATABASE $DB_NAME;"
fi

# Create the new database
mysql -u root -p -e "CREATE DATABASE $DB_NAME;"

# Create the new user and grant privileges
mysql -u root -p -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
mysql -u root -p -e "FLUSH PRIVILEGES;"

# Configure Nginx
mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
touch /etc/nginx/sites-available/default

# Create a new Nginx server block
cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80;
    listen [::]:80;

    root $WEB_ROOT;
    index index.php index.html index.htm index.nginx-debian.html;

    server_name $DOMAIN_NAME;

    location / {
        try_files \$uri \$uri/ /index.php?q=\$uri&\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

# Test Nginx configuration and restart Nginx
nginx -t && systemctl restart nginx

# Edit PHP-FPM configuration file
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.4/fpm/php.ini

# Restart PHP-FPM service
systemctl restart php7.4-fpm

# Allow incoming traffic on ports 80 and 443 and then reload the firewall settings
ufw allow 80 && ufw allow 443 && ufw reload
iptables -A INPUT -m tcp -p tcp --dport 443 -j ACCEPT && iptables -A INPUT -m tcp -p tcp --dport 80 -j ACCEPT && iptables-save > iptables-save > /etc/iptables.conf 

# Generate SSL certificate
add-apt-repository ppa:certbot/certbot -y
certbot certonly --nginx -d $DOMAIN_NAME

# Configure Nginx to redirect to https
sed -i "s/#return 301 https://$server_name$request_uri;/return 301 https://$server_name$request_uri;/" /etc/nginx/sites-available/default

# Test Nginx configuration and restart Nginx
nginx -t && systemctl restart nginx

# Set up auto-renewal for SSL certificate
echo "0 0,12 * * * root python3 -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew --quiet" | sudo tee -a /etc/crontab > /dev/null

# Test everything from the backend side
php $WEB_ROOT/wp-admin/install.php --url=https://$DOMAIN_NAME --title=services --admin_user=$DB_USER --admin_password=$DB_PASS --admin_email=admin@$DOMAIN_NAME --skip-email

Error handling
if [ $? -ne 0 ]; then
echo "An error occurred, stopping the script!"
exit 1
fi

# Print the status of installing WordPress
echo "WordPress has been successfully installed!"
