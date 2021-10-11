# NGINX

## Install NGINX

   - `sudo apt-get install nginx`
   - install header more filter to remove server info from response headers
   - `sudo apt-get install libnginx-mod-http-headers-more-filter`
   - after install go to the nginx installation path `cd /etc/nginx`
   - create your virtual host file in to sites-available folder
   - `sudo nano /etc/nginx/sites-available/dev.lesli.cloud.conf`
   - Setup your configuration like this:

```nginx
server {

    server_name dev.lesli.cloud;

    root /var/www/dev.lesli.cloud/public;

    # Write log in packages instead of every event
    access_log /var/log/nginx/dev.lesli.cloud.access.log combined buffer=16k;
    error_log  /var/log/nginx/dev.lesli.cloud.error.log;

    client_max_body_size 10M;

    index index.html index.htm index.nginx-debian.html;

    passenger_enabled on;
    passenger_ruby /home/ubuntu/.rvm/gems/ruby-2.7.2/wrappers/ruby;  

    # Disable header with server info
    server_tokens off;
    more_clear_headers Server;
    more_clear_headers 'X-Powered-By';

    # Block invalid requests (mostly from scanning tools)
    location ~ (\.jsp$|\.asp$|\.py$|\.perl$|\.php$|\.env$) {
        return 404;
    }

    # rails assets
    location ~ ^/(assets)/  {

        root /var/www/dev.lesli.cloud/public;

        # to serve pre-gzipped version
        gzip_static on; 

        # cache everything
        expires max;
        add_header Cache-Control public;

        # do not log asset requests
        access_log off;
    }

    location / {

        # Always upgrade to HTTP/1.1
        proxy_http_version 1.1; 

        # Enable keepalives
        proxy_set_header Connection ""; 

        # Optimize encoding
        proxy_set_header Accept-Encoding ""; 

    }

}

```

- after setup your website create the symbolic link to enable the site
- `sudo ln -s /etc/nginx/sites-available/dev.lesli.cloud.conf /etc/nginx/sites-enabled/`
- now test your configuration with the command `sudo nginx -t`
- if all is fine restart nginx service `sudo service nginx restart`
