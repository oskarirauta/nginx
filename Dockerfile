FROM alpine:latest

#ENV \
#	MEMORY_LIMIT=256M \
#	MAX_EXECUTION_TIME=60 \
#	UPLOAD_MAX_FILESIZE=64M \
#	MAX_FILE_UPLOADS=20 \
#	POST_MAX_SIZE=64M \
#	MAX_INPUT_VARS=4000 \
#	DATE_TIMEZONE=Europe/Helsinki \
#	PM_MAX_CHILDREN=6 \
#	PM_START_SERVERS=4 \
#	PM_MIN_SPARE_SERVERS=2 \
#	PM_MAX_SPARE_SERVERS=6

RUN \
	apk --no-cache update && \
	apk --no-cache upgrade && \
  apk --no-cache add nginx nginx-mod-http-xslt-filter nginx-mod-http-geoip nginx-mod-stream-geoip \
  nginx-mod-http-image-filter nginx-mod-http-js nginx-mod-stream-js nginx-mod-http-headers-more \
  nginx-mod-http-upload-progress nginx-mod-http-dav-ext nginx-mod-http-fancyindex nginx-mod-http-nchan

RUN \
	addgroup -g 82 -S www-data && \
	adduser -u 82 -D -S -G www-data -g www www && \
	mkdir -p /var/www && \
	chown -R www:www-data /var/www
	
#RUN \
#	mkdir -p /scripts /scripts/entrypoint.d /etc/php7/templates /etc/php7/templates/php-fpm.d && \
#	mv /etc/php7/php-fpm.conf /etc/php7/templates/ && \
#	mv /etc/php7/php-fpm.d/www.conf /etc/php7/templates/php-fpm.d/ && \
#	mv /etc/php7/php.ini /etc/php7/templates/

RUN 	rm -f /var/cache/apk/*

COPY entrypoint.sh /scripts/entrypoint.sh

VOLUME ["/var/www"]
VOLUME ["/scripts/entrypoint.d"]

EXPOSE 80 443

ENTRYPOINT ["/scripts/entrypoint.sh"]
#CMD ["/usr/sbin/php-fpm7"]
