FROM ubuntu

RUN apt-get update && apt-get install -y sudo vim gcc g++ python2.7 virtualenv git wget binutils locales && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen

RUN useradd -m user && usermod -a -G sudo user && echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ADD start-ide.sh /usr/local/bin/start-cloud9

VOLUME /work
USER user
CMD [ /usr/local/bin/start-cloud9 ]
