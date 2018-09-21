#!/bin/bash

# Install Dropbox - https://www.dropbox.com/ja/install?os=linux
_install() {
    cd ${HOME} \
        && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - \
        && ${HOME}/.dropbox-dist/dropboxd \
        && mkdir -p ~/bin \
        && cd ~/bin && wget "https://www.dropbox.com/download?dl=packages/dropbox.py" \
        && chmod 755 ~/bin/dropbox.py
}

_install $@

exit 0
