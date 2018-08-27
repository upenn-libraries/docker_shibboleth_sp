FROM ubuntu:xenial
RUN apt-get update && \
    apt-get -y install apt-utils apache2 libapache2-mod-shib2 supervisor && \
    apt-get -y clean
#
# Set up Shibboleth SP
#
# NOTES:
# Some examples of deploying shibd via docker/supervisor include creation
# of the /var/run/shibboleth dir, which may be necessary if not using the
# stock init.d script that gets installed by apt. But assuming that script
# serves as the one used to start shibd, there's no need to create that
# path here.
# Ubuntu doesn't automatically generate SP key & cert. The key & cert can be
# generated for the test environment by running:
# `shib-keygen -h example.edu -u _shibd`
# The /etc/shibboleth/shibboleth2.xml metadata file that's installed
# from repo assumes files sp-key.pem, sp-cert.pem existing in
# the same directory. While not required, any deviations from that will
# have to be reflected in that file.

COPY shibboleth/shibboleth2.xml /etc/shibboleth/shibboleth2.xml

#
# Set up Apache
#

COPY apache2/shib2.conf /etc/apache2/sites-available/shib2.conf
RUN a2enmod ssl rewrite proxy_http headers
RUN a2ensite shib2
RUN a2dissite 000-default.conf

# Configure supervisor
COPY supervisor/*.conf /etc/supervisor/conf.d/

EXPOSE 443 80
CMD ["supervisord", "-n"]
