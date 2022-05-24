FROM developenv/devenv-pyats-base:latest

USER root

RUN apk upgrade --update --available

# > VPN Setup
RUN set -xe \
    && apk add --no-cache \
               --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
               automake \
               autoconf \
               build-base \
               libevent-dev \
               linux-headers \
               libevent \
               openconnect \
               openssh \
               libproxy \
               libproxy-dev

COPY config/startvpn.sh /usr/local/bin/startvpn.sh
RUN chmod u+x /usr/local/bin/startvpn.sh

ARG USER=developer
ENV HOME /home/$USER
RUN apk add --update sudo
RUN echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER && chmod 0440 /etc/sudoers.d/$USER
# < VPN Setup

RUN chown -R $USER: /var/log/* && chown -R $USER: /home/$USER
USER $USER
WORKDIR $HOME/src
