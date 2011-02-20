# iPad Cheat Sheet

## Email and SSL

### Self-signed certs

Using a self-signed cert will prevent the iPad from connecting, unless
the cert is loaded into the iPad. Solution: Copy the PEM file to a
browser-accessible place, then surf to it: e.g.:

    http://www.example.com/tmp/mycert.pem

The iPad will then allow installation of the certificate. Once it's installed,
Mail should work.
