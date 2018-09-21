#!/bin/sh
set -e

user="toybox"
if [ -n "${TOYBOX_UID}" ] && ! cat /etc/passwd | awk 'BEGIN{ FS= ":" }{ print $3 }' | grep ${TOYBOX_UID} > /dev/null 2>&1; then
    usermod -u ${TOYBOX_UID} ${user}
    echo "UID of ${user} has been changed."
fi

[ "${JAPANESE_SUPPORT}" = "yes" ] && {
    echo "Japanese support enabled."

    # locale
    localedef -f UTF-8 -i /usr/share/i18n/locales/ja_JP ja_JP.UTF-8
    sed -i -e "s/LANG=\"en_US.UTF-8\"/LANG=\"ja_JP.UTF-8\"/" /etc/sysconfig/i18n
    echo "SUPPORTED=\"en_US.UTF-8:en_US:en:ja_JP.UTF-8:ja_JP:ja\"" >> /etc/sysconfig/i18n

    # Timezone
    yes | cp /usr/share/zoneinfo/Japan /etc/localtime
    sed -i -e "s:ZONE=\"Etc/UTC\":ZONE=\"Asia/Tokyo\":" /etc/sysconfig/clock

    # enable DBUS for IME
    dbus-uuidgen > /var/lib/dbus/machine-id

    # enable IME & IME settings
    ln -sf /etc/X11/xinit/xinput.d/ibus.conf /root/.xinputrc \
    && ln -sf /etc/X11/xinit/xinput.d/ibus.conf /home/toybox/.xinputrc

    # IME settings
    gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
     	--type bool --set /desktop/gnome/interface/show_input_method_menu true \
    && gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
     	--type list --list-type string --set /desktop/ibus/general/preload_engines ["anthy"] \
    && gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
     	--type bool --set /desktop/ibus/general/use_global_engine true \
    && gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
     	--type bool --set /desktop/ibus/panel/show_im_name true \
    && gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
        --type bool --set /desktop/ibus/panel/use_custom_font true \
    && gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory \
    	    --type string --set /desktop/ibus/panel/custom_font "IPAPGothic 12"

    # Folder settings( xdg-user-dirs )
    sed -i -e "/### END INIT INFO/a\sudo -u toybox LC_ALL=en_US xdg-user-dirs-update --force" /etc/init.d/vncserver
    sed -i -e "/### END INIT INFO/a\LC_ALL=en_US xdg-user-dirs-update --force" /etc/init.d/vncserver
    sed -i -e "/### END INIT INFO/a\sed -i -e \"s\/enabled=False\/enabled=True\/\" \/etc\/xdg\/user-dirs.conf" /etc/init.d/vncserver
}

# application installer

mkdir -p /installer
apps=(
    LibreOffice
    dropbox
    eclipse
    evolution
    firefox
    general_purpose_desktop
    gimp
    git
    gthumb
    nano
    nautilus-open-terminal
    netbeans-ide-8.2
    network_utilities
    rhythmbox
    samba_client
    sublime_text_3
    system_utilities
    totem
    utilities
    vim
)

for app in ${apps[@]}; do
    printf "create installer of the ${app} at /installer/${app}.sh ..."

    yum="yum update -y && yum install -y"
    yum_group="yum update -y && yum groupinstall -y"
    yum_clean="yum clean all && rm -rf /tmp/*"
    func=""

    if [ "${app}" = "LibreOffice" ]; then
        func="${yum} libreoffice"
        [ "${JAPANESE_SUPPORT}" = "yes" ] && {
            func="${func} libreoffice-langpack-ja"
        }

    elif [ "${app}" = "eclipse" ]; then
    func=$(cat << 'EOF'
    tools=(wget unzip)
    for tool in ${tools[@]}; do
        if ! which ${tool}; then
            yum update -y && yum install -y ${tool}
        fi
    done
    
    yum install -y eclipse && yum clean all && rm -rf /tmp/*
    
    [ ${LANG} = "ja_JP.UTF-8" ] && {
        libdir=/usr/lib64/eclipse
        name=pleiades
        mkdir -p /tmp/${name}
        wget https://ja.osdn.net/projects/mergedoc/downloads/66003/pleiades_1.7.0.zip/ -O /tmp/${name}/${name}.zip
        unzip /tmp/${name}/${name}.zip -d /tmp/${name}
        cp -r /tmp/${name}/features/jp.sourceforge.mergedoc.pleiades ${libdir}/features
        cp -r /tmp/${name}/plugins/jp.sourceforge.mergedoc.pleiades ${libdir}/plugins
        rm -rf /tmp${name}
        echo "-javaagent:${libdir}/plugins/jp.sourceforge.mergedoc.pleiades/${name}.jar" >> /etc/eclipse.ini
    }
EOF
)
    elif [ "${app}" = "dropbox" ]; then
        func=$(cat << 'EOF'
if ! which wget; then
        yum update -y && yum install -y wget && yum clean all && rm -rf /tmp/*
    fi
    cd ${HOME}
    wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
    ${HOME}/.dropbox-dist/dropboxd &
    mkdir -p ${HOME}/bin
    wget "https://www.dropbox.com/download?dl=packages/dropbox.py" -O /usr/local/bin/dropbox
    chmod 755 /usr/local/bin/dropbox
EOF
)
    elif [ "${app}" = "general_purpose_desktop" ]; then
        func="${yum_group} 'General Purpose Desktop' && ${yum_clean}"

    elif [ "${app}" = "netbeans-ide-8.2" ]; then
        func=$(cat << EOF
# Java SE Development Kit 8u111
    echo "You must accept the Oracle Binary Code License Agreement for Java SE to download this software."
    echo "(http://www.oracle.com/technetwork/java/javase/terms/license/index.html)"

    while true; do
      read -p "Do you agree with the licences? (Y/N): " yn
      case \$yn in
        [Yy]* ) 
            if ! which wget; then
                yum update -y && yum install -y wget && yum clean all && rm -rf /tmp/*
            fi
            wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.rpm -O /tmp/jdk.rpm
            rpm -ivh /tmp/jdk.rpm
            wget http://download.netbeans.org/netbeans/8.2/final/bundles/netbeans-8.2-linux.sh -O ${HOME}/netbeans-ide-8.2_installer.sh
            chmod 755 ${HOME}/netbeans-ide-8.2_installer.sh
            sh ${HOME}/netbeans-ide-8.2_installer.sh
            break
            ;;

        [Nn]* ) break;;
        * ) echo "Please answer yes or no."; exit 1;;
      esac
    done
EOF
)
    elif [ "${app}" = "network_utilities" ]; then
        func="${yum} curl wget && ${yum_clean}"

    elif [ "${app}" = "samba_client" ]; then
        func="${yum} samba-client samba-common && ${yum_clean}"

    elif [ "${app}" = "sublime_text_3" ]; then
        func=$(cat << 'EOF'
if ! which wget; then
        yum update -y && yum install -y wget && yum clean all && rm -rf /tmp/*
    fi
    wget https://download.sublimetext.com/sublime_text_3_build_3126_x64.tar.bz2 -O ~/Downloads/sublime.tar.bz2
    tar jxvf ~/Downloads/sublime.tar.bz2 -C /opt
    rm -rf ~/Downloads/sublime.tar.bz2
    ln -sf /opt/sublime_text_3/sublime_text.desktop /usr/share/applications/
    sed -i \
        -e 's:Icon=sublime-text:Icon=/opt/sublime_text_3/Icon/48x48/sublime-text.png:' \
        -e 's:/opt/sublime_text/:/opt/sublime_text_3/:g' \
        /opt/sublime_text_3/sublime_text.desktop
EOF
)
    elif [ "${app}" = "system_utilities" ]; then
        func="${yum} htop dstat gnome-utils gnome-system-monitor system-config-language gconf-editor && ${yum_clean}"

    elif [ "${app}" = "utilities" ]; then
        func="${yum} file-roller unzip && ${yum_clean}"

    else
        func="${yum} ${app} && ${yum_clean}"
    fi
    cat << EOF > /installer/${app}.sh
#!/bin/bash
set -e

_install() {
    ${func}
    echo "complete!"
}

_install

exit 0
EOF
    chmod 755 /installer/${app}.sh
    echo "done."
done

# temp
echo "alias la='ls -la'" >> /root/.bashrc
echo "alias la='ls -la'" >> /home/toybox/.bashrc

exec $@
