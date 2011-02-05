# Nginx Cheat Sheet

## Simulating Apache's `UserDir`, with nginx.

    # Apache userdir simulation.
    location ~ ^/~([^/]+)(/.*)?$ {
        alias /home/$1/public_html$2;
        autoindex on;
        ssi on;
    }

