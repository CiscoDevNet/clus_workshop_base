FROM developenv/devenv-base-bootstrap-dind-vpn:latest

USER root

RUN rm -rf /home/developer/src

COPY src /home/developer/src

RUN chown -R developer: /home/developer

RUN apk add linux-headers libffi-dev nano

RUN pip3 install -r /home/developer/src/requirements.txt

USER developer