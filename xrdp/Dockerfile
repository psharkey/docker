FROM centos:centos6
MAINTAINER Nuts Project, LLC <dev@nutsproject.jp>

ENV ROOT_PASSWD=centos \
    USER_PASSWD=password

# Install base( except "X Window System" "fonts" )
RUN yum update -y && yum groupinstall -y \
        "Desktop" \
        "Japanese Support" \
    && yum install -y \
        epel-release \
        sudo \
        gedit \
        python-setuptools \
    && yum clean all && rm -rf /tmp/* \
    && echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel \
    && chmod 0440 /etc/sudoers.d/wheel

# Supervisor
RUN easy_install supervisor \
	&& mkdir -p /var/log/supervisor \
	&& mkdir -p /etc/supervisord.d \
    && { \
        echo '[supervisord]'; \
        echo 'nodaemon=true'; \
        echo 'logfile=/var/log/supervisor/supervisord.log'; \
        echo 'logfile_maxbytes=1MB'; \
        echo 'logfile_backups=1'; \
        echo 'loglevel=warn'; \
        echo 'pidfile=/var/run/supervisord.pid'; \
        echo '[include]'; \
        echo 'files = /etc/supervisord.d/*.conf'; \
    } > /etc/supervisord.conf

# VNC & XRDP Servers & Autostart services
# tigervnc, tigervnc-server, tigervnc-server-module, xrdp, xinitd
RUN yum update -y \
	&& yum install -y \
        tigervnc-server \
        xrdp \
        xinetd \
	&& yum clean all && rm -rf /tmp/* \
	&& chkconfig vncserver on 3456 \
    && { \
        echo 'VNCSERVERS="0:root 1:toybox"'; \
        echo 'VNCSERVERARGS[0]="-geometry 1280x960"'; \
        echo 'VNCSERVERARGS[1]="-geometry 1280x960"'; \
    } >> /etc/sysconfig/vncservers \
	&& chkconfig xrdp on 3456 \
	&& chmod -v +x /etc/init.d/xrdp \
	&& chmod -v +x /etc/xrdp/startwm.sh \
	&& echo "gnome-session --session=gnome" > ~/.xsession \
    && { \
        echo '[program:xrdp]'; \
        echo 'command=/etc/init.d/xrdp restart'; \
        echo 'stderr_logfile=/var/log/supervisor/xrdp-error.log'; \
        echo 'stdout_logfile=/var/log/supervisor/xrdp.log'; \
    } > /etc/supervisord.d/xrdp.conf \
    && { \
        echo '[program:vncserver]'; \
        echo 'command=/etc/init.d/vncserver restart'; \
        echo 'stderr_logfile=/var/log/supervisor/vncserver-error.log'; \
        echo 'stdout_logfile=/var/log/supervisor/vncserver.log'; \
    } > /etc/supervisord.d/vnc.conf

# Create User
RUN su root sh -c "yes $ROOT_PASSWD | vncpasswd" \
    && echo "root:$ROOT_PASSWD" | chpasswd \
	&& useradd -g wheel toybox \
	&& su toybox sh -c "yes $USER_PASSWD | vncpasswd" \
    && echo "toybox:$USER_PASSWD" | chpasswd

# GNOME Settings for all users
RUN gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
	    --type bool  --set /apps/nautilus/preferences/always_use_browser true \
	&& gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
	    --type bool --set /apps/gnome-screensaver/idle_activation_enabled false \
	&& gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
	    --type bool --set /apps/gnome-screensaver/lock_enabled false \
	&& gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
	    --type int --set /apps/metacity/general/num_workspaces 1 \
	&& gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
	    --type=string --set /apps/gnome_settings_daemon/keybindings/screensaver ' ' \
	&& gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
	    --type=string --set /apps/gnome_settings_daemon/keybindings/power ' ' \
	&& gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
	    --type bool --set /apps/panel/global/disable_log_out true \
	&& gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
	    --type int --set /apps/gnome-power-manager/timeout/sleep_computer_ac '0' \
	&& gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
	    --type int --set /apps/gnome-power-manager/timeout/sleep_display_ac '0' \
	&& gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
	    --type int --set /apps/gnome-screensaver/power_management_delay '0' \
	&& gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
	    --type bool --set /desktop/gnome/remote_access/enabled true \
	&& gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
	    --type bool --set /desktop/gnome/remote_access/prompt_enabled false

EXPOSE 5900 5901 3389

COPY docker-entrypoint.sh /entrypoint.sh
#COPY /installer/ /installer/

ENTRYPOINT ["/entrypoint.sh"]

CMD ["supervisord"]
