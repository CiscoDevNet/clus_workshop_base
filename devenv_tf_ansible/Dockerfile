FROM python:3.10-slim

# Installing applications needed for runtime.  Cleaning up because the maid don't clean containers
RUN apt update
RUN apt install -y --no-install-recommends \
        bash \
        jq \
        build-essential \
        libsqlite3-dev \
        curl \
        vim \
        nano \
        git \
        unzip \
        openconnect \
        ca-certificates \
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
COPY config/filebrowser /usr/local/bin/filebrowser
COPY config/config.json /usr/local/bin/config.json
COPY config/cors.list /usr/local/bin/cors.list
COPY config/index.html /usr/bin/index.html
ENV CORS_WHITELIST_FILEPATH=/usr/local/bin/cors.list
COPY config/session_start.sh /usr/local/bin/
RUN chmod u+x /usr/local/bin/session_start.sh

#Handling the HashiCorp utils
RUN curl -L -s -o terraform.zip https://releases.hashicorp.com/terraform/1.1.9/terraform_1.1.9_linux_386.zip && \
    unzip terraform.zip -d /usr/bin/ && chmod 755 /usr/bin/terraform && rm -rf terraform.zip

RUN curl -L -s -o consul.zip https://releases.hashicorp.com/consul/1.12.0/consul_1.12.0_linux_386.zip && \
    unzip consul.zip -d /usr/bin/ && chmod 755 /usr/bin/consul && rm -rf consul.zip

RUN curl -L -s -o cts.zip https://releases.hashicorp.com/consul-terraform-sync/0.5.2/consul-terraform-sync_0.5.2_linux_386.zip && \
    unzip cts.zip -d /usr/bin/ && chmod 755 /usr/bin/consul-terraform-sync && rm -rf cts.zip

RUN curl -L -s -o sentinel.zip https://releases.hashicorp.com/sentinel/0.18.9/sentinel_0.18.9_linux_386.zip && \
    unzip sentinel.zip -d /usr/bin/ && chmod 755 /usr/bin/sentinel && rm -rf sentinel.zip

# Installing the Caddy server for reverse proxy
#RUN curl -o caddy "https://caddyserver.com/api/download?os=linux&arch=amd64&idempotency=3754473143692" && \
#    chmod +x caddy && \
#    mv caddy /usr/local/bin/

RUN apt install -y debian-keyring debian-archive-keyring apt-transport-https
RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
RUN apt update
RUN apt install caddy

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
RUN chown -R developer:developer /home/developer
USER developer
RUN pip install --user -r /home/developer/requirements_cache.txt
RUN rm /home/developer/requirements_cache.txt
WORKDIR /home/developer/src

# Now lets launch this business
CMD ["bash", "-c", "/usr/local/bin/wrapper_script.sh Y"]