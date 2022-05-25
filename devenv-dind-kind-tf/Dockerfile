FROM developenv/devenv-base-bootstrap-dind-kind:latest

USER root

RUN rm -rf /home/developer/src

COPY src /home/developer/src

RUN chown -R developer: /home/developer

RUN apk add linux-headers libffi-dev nano

RUN pip3 install -r /home/developer/src/requirements.txt

ENV TERRAFORM_VERSION 1.1.9

# Copy over files & change their ownership to developer.
COPY /root/home/developer/bin/* /home/developer/bin/
COPY /root/home/developer/src /home/developer/src
RUN chown -R developer: /home/developer
RUN cd /usr/local/bin && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip 