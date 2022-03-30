FROM developenv/devenv-base-bootstrap-dind-kind-istio:latest

USER root

#ENV ISTIO_PROFILE=minimal

RUN rm -rf /home/developer/src

COPY src /home/developer/src

RUN chown -R developer: /home/developer

RUN apk add linux-headers libffi-dev nano

RUN pip3 install -r /home/developer/src/requirements.txt

RUN wget -q https://github.com/derailed/k9s/releases/download/v0.25.18/k9s_Linux_x86_64.tar.gz -O - | tar -xzO k9s > /usr/local/bin/k9s && chmod +x /usr/local/bin/k9s

RUN wget -q https://github.com/k3d-io/k3d/releases/download/v5.3.0/k3d-linux-amd64 -O /usr/local/bin/k3d && chmod +x /usr/local/bin/k3d

COPY tools /home/developer/tools

COPY devenv/devenv-init.sh /home/developer/bin/devenv-init.sh

# Install SMM
COPY bin /home/developer/bin-rel
RUN tar zxvfO /home/developer/bin-rel/smm/smm_1.9.0_linux_amd64.tar.gz smm > /usr/local/bin/smm && chmod +x /usr/local/bin/smm

