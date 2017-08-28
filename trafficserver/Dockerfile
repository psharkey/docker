FROM ubuntu:17.04

RUN apt-get update && apt-get install -y trafficserver \
	&& mkdir -p /var/run/trafficserver \
	&& chown trafficserver:trafficserver /var/run/trafficserver \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/*

EXPOSE 8080

USER trafficserver

# Enable unrestricted forward proxy
RUN sed -i -- "s|CONFIG proxy.config.url_remap.remap_required INT.*|CONFIG proxy.config.url_remap.remap_required INT 0|g" /etc/trafficserver/records.config

CMD ["traffic_manager"]
