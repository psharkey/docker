FROM    ubuntu

RUN     apt-get update && apt-get install -y \
       build-essential \
       libxext-dev libxrender-dev libxtst-dev \
       wget \
       --no-install-recommends \
       && rm -rf /var/lib/apt/lists/*

ARG     VMPLAYER_URL=https://download3.vmware.com/software/player/file/VMware-Player-12.1.1-3770994.x86_64.bundle

RUN     wget --progress=bar:force $VMPLAYER_URL -O vmplayer.bundle --no-check-certificate \
       && chmod +x vmplayer.bundle; sleep 1

# Manual steps due to EULA
#RUN    ./vmplayer.bundle \
#       && rm vmplayer.bundle

CMD     ["vmplayer"]
