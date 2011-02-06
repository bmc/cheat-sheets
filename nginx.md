# Nginx Cheat Sheet

## Simulating Apache's `UserDir`, with nginx.

    # Apache userdir simulation.
    location ~ ^/~([^/]+)(/.*)?$ {
        alias /home/$1/public_html$2;
        autoindex on;
        ssi on;
    }

## Rewrite rules for redirects

They're regex-based. e.g.:

    server {
        # Server-wide redirect

        rewrite ^/software/poll/?.* http://software.clapper.org/poll/ permanent;
        
        # Location-specific redirect
        
        location /bmc/blog/ {
            rewrite /bmc/blog/(.*)$ http://brizzled.clapper.org/$1;
        }

## FastCGI

For instance, for PHP, Python or Ruby.

    location ~ \.php {
        include /etc/nginx/fastcgi_params;
        keepalive_timeout 0;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME /var/www/html/$fastcgi_script_name;
        fastcgi_index index.php;
    }
