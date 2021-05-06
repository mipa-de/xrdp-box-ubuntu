FROM ubuntu:xenial
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y 
RUN apt-get install -y software-properties-common
RUN apt-add-repository -y ppa:ubuntu-mate-dev/xenial-mate
RUN apt-get update -y
RUN apt full-upgrade -y
RUN apt-get dist-upgrade -y
RUN apt-get install -y mate-core
RUN apt-get install -y mate-desktop-environment
RUN apt-get install -y mate-notification-daemon

RUN apt-get install -y supervisor
RUN apt-get install -y xrdp
RUN apt-get install -y vim
RUN apt-get install -y firefox

ADD xrdp.conf /etc/supervisor/conf.d/xrdp.conf

EXPOSE 3389

# Allow all users to connect via RDP.
RUN sed -i '/TerminalServerUsers/d' /etc/xrdp/sesman.ini && \
    sed -i '/TerminalServerAdmins/d' /etc/xrdp/sesman.ini
RUN xrdp-keygen xrdp auto

RUN apt-get autoclean && apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

CMD ["/usr/bin/supervisord", "-n"]

# Set the locale
RUN locale-gen de_DE.UTF-8
ENV LANG de_DE.UTF-8
ENV LANGUAGE de_DE:de
ENV LC_ALL de_DE.UTF-8
RUN update-locale LANG=de_DE.UTF-8
RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime && dpkg-reconfigure -f noninteractive tzdata
