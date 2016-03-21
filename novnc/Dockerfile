FROM ubuntu

# Setup environment variables
ENV HOME=/root \
	DEBIAN_FRONTEND=noninteractive \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8 \
	DISPLAY=:0.0

# Install git, supervisor, VNC, & X11 packages
RUN apt-get update && apt-get install -y \ 
	git \
	supervisor \
	xvfb \
	x11-apps \
	x11vnc \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*

# Clone noVNC from github
RUN git clone https://github.com/kanaka/noVNC.git /root/noVNC \
	&& git clone https://github.com/kanaka/websockify /root/noVNC/utils/websockify

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

CMD ["/usr/bin/supervisord"]
