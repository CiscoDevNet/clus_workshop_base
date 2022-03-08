FROM developenv/devenv-base-bootstrap-dind-vpn:v0.0.24fd4cc

USER root

RUN rm -rf /home/developer/src

COPY src /home/developer/src

RUN chown -R developer: /home/developer

RUN apk add linux-headers libffi-dev nano

RUN pip3 install -r /home/developer/src/requirements.txt

RUN curl -o caddy "https://caddyserver.com/api/download?os=linux&arch=amd64&idempotency=3754473143692" && \
    chmod +x caddy && \
    mv caddy /usr/local/bin/

USER developer
