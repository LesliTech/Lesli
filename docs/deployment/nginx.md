

```nginx
upstream puma {
    server 0.0.0.0:3000; # port number in which your puma server starts
}

server {

    server_name demo.lesli.dev;

    root /var/www/demo.lesli.dev/public;

    # Write log in packages instead of every event
    access_log /var/log/nginx/access.demo.lesli.dev.log combined buffer=16k;
    error_log  /var/log/nginx/error.demo.lesli.dev.log;

    client_max_body_size 10M;

    # Disable header with server info
    server_tokens off;
    more_clear_headers Server;
    more_clear_headers 'X-Powered-By';

    # Block not valid requests (mostly from scanning tools)
    location ~ (\.jsp$|\.asp$|\.py$|\.perl$|\.php$|\.env$) {
        return 404;
    }

    # Custom robots.txt for public websites
    #location /robots.txt {
    #    alias /var/www/demo.lesli.dev/public/robots-allow.txt;
    #}

    # rails assets
    location ~ ^/(assets)/  {

        root /var/www/demo.lesli.dev/public;

        # to serve pre-gzipped version
        gzip_static on;

        # cache everything
        expires max;
        add_header Cache-Control public;

        # do not log asset requests
        access_log off;

        break;
    }

    location / {

	    try_files $uri/index.html $uri @app;

        # Always upgrade to HTTP/1.1
        proxy_http_version 1.1;

        # Enable keepalives
        proxy_set_header Connection "";

        # Optimize encoding
        proxy_set_header Accept-Encoding "";

    }

    location @app {
        proxy_pass http://puma;

        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $http_host;
        proxy_redirect off;
    }
}
```
