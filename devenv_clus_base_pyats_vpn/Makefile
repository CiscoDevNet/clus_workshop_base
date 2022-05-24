IMAGENAME := "developenv/devenv-pyats-base-vpn"
VERSION := "v001"
INSTANCENAME :="devenv-pyats-base-vpn"

build:
	@echo "Building image $(IMAGENAME)"
	docker build -t $(IMAGENAME) .
	docker tag "$(IMAGENAME):latest"  "$(IMAGENAME):$(VERSION)"
push:
	docker push $(IMAGENAME)
	docker push $(IMAGENAME):$(VERSION)
run: stop
	docker run --privileged --cap-add=NET_ADMIN --name $(INSTANCENAME) -d -p 1001:9090 -p 8080:8080 -e "DEVENV_PASSWORD=secret" $(IMAGENAME)
	@echo "http://localhost:1001?arg=secret"
stop: 
	docker stop  $(INSTANCENAME)  | true 
	docker rm  $(INSTANCENAME)  | true 

all: build run