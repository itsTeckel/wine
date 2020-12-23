FROM i386/ubuntu:18.04

# we need wget, bzip2, wine from winehq, 
# xvfb to fake X11 for winetricks during installation,
# and winbind because wine complains about missing 
RUN apt-get update && \
    apt-get -y install wget gnupg && \
    echo "deb http://dl.winehq.org/wine-builds/debian/ stretch main" >> \
      /etc/apt/sources.list.d/winehq.list && \
    wget http://dl.winehq.org/wine-builds/winehq.key -qO- | apt-key add - && \
    apt-get update && \
    apt-get -y --install-recommends install \
      bzip2 unzip curl \
      winehq-devel \
      winbind \
      xvfb \
      cabextract \
      && \
    apt-get -y clean && \
    rm -rf \
      /var/lib/apt/lists/* \
      /usr/share/doc \
      /usr/share/doc-base \
      /usr/share/man \
      /usr/share/locale \
      /usr/share/zoneinfo \
      && \
    wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
      -O /usr/local/bin/winetricks && chmod +x /usr/local/bin/winetricks

# put C:\pwiz on the Windows search path
ENV WINEARCH win32
ENV WINEDEBUG -all,err+all
ENV WINEPATH "C:\pwiz"
ENV DISPLAY :0

# To be VU friendly, avoid installing anything to /root
RUN mkdir -p /wine
ENV WINEPREFIX /wine

# wineserver needs to shut down properly!!! 
ADD waitonprocess.sh /wine/waitonprocess.sh
RUN chmod +x /wine/waitonprocess.sh

# Install dependencies
RUN winetricks -q win7 && xvfb-run winetricks -q vcrun2015 corefonts && /wine/waitonprocess.sh wineserver