FROM alpine:latest

RUN \
	apk --no-cache update && \
	apk --no-cache upgrade

RUN \
	addgroup -g 82 -S www-data && \
	adduser -u 82 -D -s /bin/ash -h /var/htdocs -G www-data -g www www

RUN \
  	apk --no-cache add nginx nginx-mod-http-xslt-filter nginx-mod-http-geoip nginx-mod-stream-geoip \
  			nginx-mod-http-image-filter nginx-mod-http-js nginx-mod-stream-js nginx-mod-http-headers-more \
  			nginx-mod-http-upload-progress nginx-mod-http-dav-ext nginx-mod-http-fancyindex nginx-mod-http-nchan \
			tzdata curl ca-certificates
  
RUN \
	adduser -u 82 -D -S -G www-data -g www www && \
	mkdir -p /var/htdocs /run/nginx /etc/nginx/ssl && \
	chown -R www:www-data /var/htdocs /run/nginx
	
RUN \
	mkdir -p /scripts /scripts/entrypoint.d

RUN \
	rm -f /etc/periodic/monthly/geoip && \
	rm -f /var/cache/apk/*

COPY nginx.conf /etc/nginx/
COPY options-ssl-nginx.conf /etc/nginx/ssl/
COPY geoip /etc/periodic/monthly/
COPY entrypoint.sh /scripts/entrypoint.sh

VOLUME ["/var/htdocs"]
VOLUME ["/etc/nginx"]
VOLUME ["/scripts/entrypoint.d"]

EXPOSE 80 443

STOPSIGNAL SIGTERM

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
