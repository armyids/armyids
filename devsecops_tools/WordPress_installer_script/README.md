# WordPress Installation Script

This script automates the process of installing WordPress on a Ubuntu 20.04 server. It handles the following tasks:
1. Creates a directory to store the database credentials and WordPress dependency files.
2. Downloads and extracts the latest version of WordPress.
3. Copies the WordPress files to the web root directory.
4. Installs all necessary applications, including Nginx, PHP-FPM, MariaDB, and Certbot.
5. Secures the MariaDB installation.
6. Creates a new MySQL database and user for the WordPress installation.
7. Configures Nginx for the WordPress installation.
8. Generates an SSL certificate for the domain using Certbot.
9. Redirects all traffic to the HTTPS version of the site.

## Prerequisites
- A fresh Ubuntu 20.04 server installation.
- A domain name that points to the server's IP address.

## Usage
1. Log in to your server as the root user.
2. Download the script:
   ```
   wget https://raw.githubusercontent.com/armyids/armyids/main/devsecops_tools/WordPress_installer_script/wordpress_install.sh
   ```
4. Make the script executable:
   ```
   chmod +x wordpress_install.sh
   ```
6. Run the script:
   ```
   ./wordpress_install.sh
   ```
8. Fill in the prompted information, including the domain name, web root directory, and WordPress version.
9. Wait for the script to complete. The installation process may take several minutes.

## Variables
The following variables can be modified in the script to change the behavior of the installation:
- `WORDPRESS_VERSION`: The version of WordPress to install.
- `DB_NAME`: The name of the MySQL database to create for the WordPress installation.
- `DB_USER`: The username for the MySQL user that will be created for the WordPress installation.
- `DB_PASS`: The password for the MySQL user that will be created for the WordPress installation.
- `DOMAIN_NAME`: The domain name for the WordPress installation.
- `WEB_ROOT`: The web root directory for the WordPress installation.

## Post-installation
After the script has completed, you can complete the WordPress installation by visiting your domain name in a web browser. You will be prompted to enter the database credentials, which can be found in the `/home/admin/database_credentials/wp_credentials.txt` file.

Please note that you will need to configure your DNS settings to point to your server's IP address for the domain name you have used for the installation.

## Additional Information
This script is designed for Ubuntu 20.04 and may not work on other versions or distributions.

The script does not include any error handling and assumes that all necessary dependencies are installed.

Make sure to review the script before running it to ensure that it meets your specific needs.

## Disclaimer
This script is provided as-is and should be used at your own risk. It is recommended that you thoroughly review and test the script before using it in a production environment.
