install passenger 
https://www.phusionpassenger.com/docs/advanced_guides/install_and_upgrade/nginx/install/oss/focal.html

install nginx 
install certbot
create nginx virtual host
install rvm 
    https://github.com/rvm/ubuntu_rvm
install rails 
    gem install rails -v 6.1.4
install postgresql gem dependencies
    sudo apt-get -y install libpq-dev
register ssh keys on github
    ssh-keygen
    cat id_rsa.pub
clone lesli core into /var/www/app.domain.com
install app dependencies
    bundle install


sym link to enable nginx website
sudo ln -s /etc/nginx/sites-available/app.mitwerken.de.conf /etc/nginx/sites-enabled/
