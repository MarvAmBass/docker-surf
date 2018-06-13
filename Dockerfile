FROM debian:stretch

ENV WEBKITGTK_VERSION=2.21.3

COPY install.sh /usr/local/bin/install.sh

RUN apt-get -q -y update \
 && apt-get -q -y upgrade \
 && apt-get -q -y install sudo \
                          \
                          wget \
                          unzip \
                          \
                          git \
                          \
                          make \
                          cmake \
                          ruby \
                          debhelper \
                          gawk \
                          gperf \
                          bison \
                          flex \
                          gtk-doc-tools \
 \
 && cd \
 \
 && wget https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-linux.zip \
 && unzip ninja-linux.zip \
 && mv ninja /usr/local/bin/ \
 && rm ninja-linux.zip \
 \
 && wget "https://webkitgtk.org/releases/webkitgtk-$WEBKITGTK_VERSION.tar.xz" \
 && tar xvf webkitgtk-*.tar.xz \
 && cd webkitgtk*/ \
 \
 && chmod a+x /usr/local/bin/install.sh \
 && cp /usr/local/bin/install.sh install.sh \
 \
 && ./install.sh \
 \
 && cp /usr/local/bin/ninja ninja \
 \
 && cmake -DPORT=GTK -DCMAKE_BUILD_TYPE=RelWithDebInfo -GNinja \
 && sh -c 'while ! ./ninja; do sleep 1; done' \
 && sudo ninja install \
 \
 && cd \
 && cd webkitgtk*/ \
 \
 && apt-get install -q -y libgcr-3-dev x11-utils \
 \
 && wget https://dl.suckless.org/tools/dmenu-4.8.tar.gz \
 && tar xvf dmenu*.tar.gz \
 && cd dmenu-*/ \
 && make \
 && sudo make install \
 && cd .. \
 \
 && git clone https://git.suckless.org/surf \
 && cd surf \
 && make \
 && sudo make install \
 \
 && cd \
 ; bash -c "dpkg --list | grep '\-dev' | tr ' ' '\n' | grep '\-dev' | sed 's/^/apt-get purge -y /g' | bash" \
 \
 ; rm -rf /root/* \
 \
 ; apt-get -q -y purge    wget \
                          unzip \
                          \
                          git \
                          \
                          make \
                          cmake \
                          ruby \
                          debhelper \
                          gawk \
                          gperf \
                          bison \
                          flex \
                          gtk-doc-tools \
 \
 ; apt-get -q -y clean \
 ; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
