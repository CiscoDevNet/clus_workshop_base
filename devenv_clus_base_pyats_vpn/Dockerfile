FROM ciscotestautomation/pyats:latest
FROM python:3.10-slim

COPY /config/wrapper_script_Y.sh /pyats/workspace.init
COPY /config/wrapper_script.sh /pyats/workspace.init

# Installing applications needed for runtime.  Cleaning up because the maid don't clean containers
RUN apt update
RUN apt install -y --no-install-recommends \
        bash \
        build-essential \
        libsqlite3-dev \
        curl \
        vim \
        nano \
        git \
        unzip \
        openconnect \
        ca-certificates \
        tcpdump \
        sudo \
        openssh-client && \
        apt clean autoclean && \
        apt autoremove --yes && \
        rm -rf /var/lib/{apt,dpkg,cache,log}/

# Handling certificate issues
RUN  mkdir -p /usr/local/share/ca-certificates/
COPY ./config/ca_aci.crt  /usr/local/share/ca-certificates/aci.crt
RUN update-ca-certificates

# Dragging in the boilerplate Python bits
# We should probably refine this based on current Ansible install needs
RUN pip install --upgrade pip
RUN pip install setuptools
COPY requirements_nocache.txt ./
RUN pip install --no-cache -r requirements_nocache.txt
RUN rm requirements_nocache.txt

RUN curl -L -s  -o /usr/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.5.0/ttyd_linux.x86_64
RUN chmod 755 /usr/bin/ttyd

COPY config/wrapper_script.sh /usr/local/bin/wrapper_script.sh
COPY config/wrapper_script_Y.sh /usr/local/bin/wrapper_script_Y.sh
COPY config/filebrowser /usr/local/bin/filebrowser
COPY config/config.json /usr/local/bin/config.json
COPY config/cors.list /usr/local/bin/cors.list
COPY config/index.html /usr/bin/index.html
ENV CORS_WHITELIST_FILEPATH=/usr/local/bin/cors.list
COPY config/session_start.sh /usr/local/bin/
RUN chmod u+x /usr/local/bin/session_start.sh


# Installing the Caddy server for reverse proxy
RUN curl -o caddy "https://caddyserver.com/api/download?os=linux&arch=amd64&idempotency=3754473143692" && \
    chmod +x caddy && \
    mv caddy /usr/local/bin/

# Setting up the openconnect bits.  I don't like permissions on the log, but it wouldn't work until I went all in
RUN mkdir /var/log/openconnect && touch /var/log/openconnect/openconnect.log && chmod 777 /var/log/openconnect/openconnect.log
COPY config/startvpn.sh /usr/local/bin/startvpn.sh
RUN chmod +x /usr/local/bin/startvpn.sh

# Getting things ready for user space
ARG USER=developer
ENV HOME /home/$USER
RUN echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER && chmod 0440 /etc/sudoers.d/$USER

# Adding user account
RUN useradd -m developer

# Exposing external ports, esp for caddy
EXPOSE 8080
EXPOSE 9090
EXPOSE 9091
EXPOSE 9092

# Setting sane PS1 to prevent container oddities.  Also pathing
RUN echo 'export PS1="\u:\W > "' >> /home/developer/.bashrc
RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> /home/developer/.bashrc

# Tidying things up from a user jail
COPY requirements_cache.txt /home/developer
RUN chmod 755 /home/developer/requirements_cache.txt
COPY src /home/developer/src
RUN chown -R developer:developer /home/developer && chown -R developer /pyats
USER developer
RUN pip install --user -r /home/developer/requirements_cache.txt
RUN rm /home/developer/requirements_cache.txt
WORKDIR /home/developer/src

# Now lets launch this business
CMD ["bash", "-c", "/usr/local/bin/wrapper_script.sh Y"]