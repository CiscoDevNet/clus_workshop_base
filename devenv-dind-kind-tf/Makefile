IMAGENAME := "developenv/devenv-base-bootstrap-dind-kind"
VERSION := "v001"
INSTANCENAME :="devenv-base-bootstrap-dind-kind"

build:
	@echo "Building image $(IMAGENAME)"
	docker build -t $(IMAGENAME) .
	docker tag "$(IMAGENAME):latest" "$(IMAGENAME):$(VERSION)"
push:
	docker push $(IMAGENAME)
	docker push $(IMAGENAME):$(VERSION)
run: stop
	docker run --pids-limit 1000 --privileged --name $(INSTANCENAME) -d -p 1001:9090 -p 1002:9091 -p 1003:9080 -p 1004:9081 \
	-e "DEVENV_USER=user" -e "DEVENV_PASSWORD=secret" -e "DEVENV_APP_8080_URL=http://localhost:1003" -e "DEVENV_APP_8081_URL=http://localhost:1004" \
	$(IMAGENAME)
	@echo "http://localhost:1001?arg=secret"
	@echo "http://localhost:1003?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJERVZFTlZfVVNFUiI6InVzZXIifQ.8JRqy3EY0_u7WwVT-ZMhvSKkCglyI6ruPn8r_rF1sXc"
stop: 
	docker stop $(INSTANCENAME)  | true
	docker rm  $(INSTANCENAME)  | true 

all: build run