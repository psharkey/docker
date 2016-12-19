FROM psharkey/toolbox

EXPOSE 22
RUN apt-get update && \
    apt-get -y install openssh-server && \
    mkdir /var/run/sshd && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    apt-get clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

CMD sudo /usr/sbin/sshd -D && \
    tail -f /dev/null
