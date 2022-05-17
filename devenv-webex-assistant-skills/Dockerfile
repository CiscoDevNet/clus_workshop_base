FROM python:3.7-slim

RUN apt update
RUN apt install build-essential libsqlite3-dev -y --no-install-recommends curl

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

EXPOSE 8080
EXPOSE 8082
EXPOSE 9090

RUN useradd -m developer
RUN echo 'export PS1="\u:\W > "' >> /home/developer/.bashrc
RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> /home/developer/.bashrc

COPY requirements_cache.txt /home/developer
RUN chmod 755 /home/developer/requirements_cache.txt
USER developer
RUN pip install --user -r /home/developer/requirements_cache.txt
RUN rm /home/developer/requirements_cache.txt
RUN mkdir -p /home/developer/code/src
WORKDIR /home/developer/code/src
ENV ROOT_PATH=/home/developer/code
COPY image_version /etc/image_version

CMD ["bash", "-c", "/usr/local/bin/wrapper_script.sh Y"]
