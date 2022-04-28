FROM python:alpine3.14

RUN apk add --update git curl vim tar tree 
RUN apk add --no-cache bash openssl-dev build-base python3-dev libffi-dev

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/* && mkdir -p /usr/local/share/ca-certificates/
COPY ./config/ca_aci.crt  /usr/local/share/ca-certificates/aci.crt
RUN update-ca-certificates
COPY requirements.txt requirements.txt
RUN pip install --upgrade pip
RUN apk add --no-cache \
        --virtual .build-deps gcc \
        libressl-dev \
        musl-dev \
        libffi-dev && \
    pip install -r requirements.txt && \
    apk del \
        libressl-dev \
        musl-dev \
        libffi-dev \
        .build-deps

RUN curl -L -s  -o /usr/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.5.0/ttyd_linux.x86_64
RUN chmod 755 /usr/bin/ttyd

WORKDIR /home/developer
RUN echo 'export PS1="\u:\W > "' >> /home/developer/.bash_profile

COPY config/wrapper_script.sh /usr/local/bin/wrapper_script.sh
COPY config/filebrowser /usr/local/bin/filebrowser
COPY config/config.json /usr/local/bin/config.json
COPY config/cors.list /usr/local/bin/cors.list
COPY config/index.html /usr/bin/index.html
ENV CORS_WHITELIST_FILEPATH=/usr/local/bin/cors.list
COPY config/session_start.sh /usr/local/bin/
RUN chmod u+x /usr/local/bin/session_start.sh

EXPOSE 8080
EXPOSE 9090

RUN addgroup -S developer && adduser -S developer -G developer
RUN mkdir src
WORKDIR /home/developer/src
RUN chown -R developer /home/developer
USER developer

CMD ["bash", "-c", "/usr/local/bin/wrapper_script.sh Y"]
