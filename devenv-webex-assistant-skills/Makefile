IMAGENAME := "developenv/devenv-webex-assistant-skills"
VERSION := $(file < image_version)
INSTANCENAME :="devenv-webex-assistant-skills"

build:
	@echo "Building image $(IMAGENAME)"
	$(file > image_version,$(VERSION))
	docker build -t $(IMAGENAME) .
	docker tag "$(IMAGENAME):latest"  "$(IMAGENAME):$(VERSION)"
push:
	docker push $(IMAGENAME)
	docker push $(IMAGENAME):$(VERSION)
run: stop
	docker run --name $(INSTANCENAME) -d -p 1001:9090 -p 1002:9091 -e "DEVENV_PASSWORD=secret" $(IMAGENAME)
	@echo "http://localhost:1001?arg=secret"
stop:
	docker stop  $(INSTANCENAME)  | true
	docker rm  $(INSTANCENAME)  | true

all: build run
