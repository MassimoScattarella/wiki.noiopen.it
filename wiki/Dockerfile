FROM mediawiki:1.35.0

ADD extensions/OpenIDConnect-REL1_35-05d76c0.tar.gz /var/www/html/extensions/
ADD extensions/PluggableAuth-REL1_35-2a465ae.tar.gz /var/www/html/extensions/
COPY composer.local.json /var/www/html/composer.local.json
COPY logo.png /var/www/html/logo.png

# Install composer dependencies
RUN apt-get update && \
apt-get install -y unzip

# Install composer and run composer update
ADD https://getcomposer.org/composer-1.phar /var/www/html/composer-1.phar
RUN cd /var/www/html && \
php composer-1.phar update

ARG CURRENT_UID
RUN useradd -u $CURRENT_UID --home /var/www/data current
ENV APACHE_RUN_USER=current
RUN chown -R current:current /var/www/html
