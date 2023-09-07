if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo."
    exit 1
fi

sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo ufw disable
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql php-curl php-mbstring php-common php-xml php-gd php-zip php-json php-bz2 php-intl php-gmp php-bcmath php-ldap unzip
sudo mysql_secure_installation

while true; do
    # Prompt for MySQL username
    read -p "Create MySQL username: " username

    # Prompt for MySQL password without masking
    read -p "Create MySQL password: " password

    # Check if either the username or password is empty
    if [ -z "$username" ] || [ -z "$password" ]; then
        echo "Username or password cannot be empty."
    else
        # Continue with the installation
        sudo mysql -u root -e "CREATE USER '$username'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '$password'; GRANT ALL PRIVILEGES ON *.* TO '$username'@'localhost'; FLUSH PRIVILEGES;"
        echo "MySQL user '$username' created with the provided password."
        break  # Exit the loop when a valid username and password are provided
    fi
done

echo "Installing phpmyadmin..."

sudo wget -P /var/www/ https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip

sudo unzip -q /var/www/phpMyAdmin-5.2.1-all-languages.zip -d /var/www/

sudo ln -s /var/www/phpMyAdmin-5.2.1-all-languages /var/www/html/phpmyadmin

sudo rm /var/www/phpMyAdmin-5.2.1-all-languages.zip

