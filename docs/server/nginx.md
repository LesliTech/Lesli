# NGINX

## Install NGINX

   - `sudo apt-get install nginx`
   - after install go to the nginx installation path `cd /etc/nginx`
   - create your website configuration file in to sites-available
   - `sudo nano /etc/nginx/sites-available/dev.lesli.cloud.conf`
   - Setup your configuration like this:

```nginx
server {

    root /var/www/dev.lesli.cloud/public;

    client_max_body_size 120M;

    index index.html index.htm index.nginx-debian.html;

    server_name dev.lesli.cloud;
    access_log /var/log/nginx/dev.lesli.cloud.access.log;
    error_log /var/log/nginx/dev.lesli.cloud.error.log;

    passenger_enabled on;
    passenger_ruby /home/ubuntu/.rvm/gems/ruby-2.7.2/wrappers/ruby;

    location ~ ^/(assets)/  {
        root /var/www/dev.lesli.cloud/public;
        gzip_static on; # to serve pre-gzipped version
        expires max;
        add_header Cache-Control public;
    }


    # Configuration added automatically by Certbot and Let's encrypt

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/dev.lesli.cloud/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/dev.lesli.cloud/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}


# Configuration added automatically by Certbot and Let's encrypt
server {
    
    if ($host = dev.lesli.cloud) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    server_name dev.lesli.cloud;
    listen 80;
    return 404; # managed by Certbot

}
```

- after setup your website create the symbolic link
- `sudo ln -s /etc/nginx/sites-available/dev.lesli.cloud.conf /etc/nginx/sites-enabled/`
- now test your configuration with the command `sudo nginx -t`
- if all is fine restart nginx service `sudo service nginx restart`
