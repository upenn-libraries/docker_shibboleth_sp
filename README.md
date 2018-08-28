# Shibboleth Docker Image

## Overview
This is a Docker image for deploying a Shibboleth service provider.

* Based on Ubuntu Xenial
* Uses Apache as front end
* Uses Supervisor to manage Shibboleth daemon and Apache service

Currently there are several configuration files that must be mounted into the container as Docker configs / secrets or volumes:

1. /etc/shibboleth/shibboleth2.xml - public-facing URL
(e.g. https://example.edu/shibboleth) must be provided as the
value for entityID attribute, which is in the <SSO></SSO> element.
2. /etc/apache2/sites-available/shib2.conf - ServerName must correspond to the
public-facing hostname that's identified in shibboleth2.xml
3. /etc/shibboleth/metadata.xml - metadata file for your IDP must be provided.
4. If generating the SP's crt & key via shib-keygen in the Dockerfile, be sure to specify the hostname, otherwise the random hostname assigned to the container will be used. Also keep in mind that the metadata generated will be valid only for as long as the image remains the same.

## Files
* apache2/shib2.conf - Configuration for default VirtualHosts running on ports 80 and 443. Non-SSL VirtualHost simply redirects to SSL.
* shibboleth/shibboleth2.xml - Sample Shibboleth configuration file with example SP / IDP URLs and common defaults.
* supervisor/apache2.conf - Run Apache (has to be invoked in such as way as to foreground process in container)
* supervisor/shibd.conf - Run shibd using the stock init.d script from the apt package
* supervisor/supervisord.conf - Launch supervisord in non-daemon mode

See additional notes in Dockerfile and the various configuration files
associated with the image.

## Build & run

Build docker image:
docker build -t shibboleth .

Run container:
docker run -d -p 443:443 -p 80:80 shib

Open browser & check that shib is running:
https://example.edu/secure

Generate metadata for the service provider (this will have to be added to your identity provider)
https://example.edu/Shibboleth.sso/Metadata
