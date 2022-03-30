IMAGENAME := "containers.cisco.com/tiswanso/devenv-base-k3d"
VERSION := "latest"
INSTANCENAME :="devenv-k3d"

build:
	@echo "Building image $(IMAGENAME)"
	docker build -t $(IMAGENAME) .
	docker tag "$(IMAGENAME):latest" "$(IMAGENAME):$(VERSION)"
push:
	docker push $(IMAGENAME)
	docker push $(IMAGENAME):$(VERSION)
run: stop
	docker run --privileged --name $(INSTANCENAME) -d -p 1001:9090 -p 8080:8080 -e "DEVENV_PASSWORD=secret" -e "DEVENV_PASSWORD=secret" -e "DEVENV_APP_URL=http://localhost:8080" $(IMAGENAME)
	@echo "http://localhost:1001?arg=secret"
stop: 
	docker stop $(INSTANCENAME)  | true
	docker rm  $(INSTANCENAME)  | true 

all: build run
