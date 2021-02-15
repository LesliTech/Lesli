# NGINX

## Configuration example:

```nginx
server {

    root /var/www/lesli/public;

    client_max_body_size 120M;

    index index.html index.htm index.nginx-debian.html;

    server_name dev.lesli.cloud;

    passenger_enabled on;
    passenger_ruby /home/ubuntu/.rvm/gems/ruby-2.7.2/wrappers/ruby;

    location ~ ^/(assets)/  {
        root /var/www/lesli/public;
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
