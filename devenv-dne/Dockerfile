FROM developenv/devenv-base:v0.0.60a2dcb

USER root

COPY src /home/developer/src

RUN chown -R developer: /home/developer

RUN apk add linux-headers libffi-dev

USER developer
