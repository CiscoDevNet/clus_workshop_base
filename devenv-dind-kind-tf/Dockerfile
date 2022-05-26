FROM developenv/devenv-base-bootstrap-dind:v0.0.e170b6c

USER root

COPY /root/home/developer/bin/* /home/developer/bin/

ENV DOCKER_HOST="unix:///var/run/docker.sock"

# K8s
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl
RUN curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.12.0/kind-linux-amd64 && chmod +x ./kind && mv ./kind /usr/local/bin
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

ENV TERRAFORM_VERSION 1.1.9

# Copy over files & change their ownership to developer.
RUN chown -R developer: /home/developer
RUN cd /usr/local/bin && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip 
USER developer