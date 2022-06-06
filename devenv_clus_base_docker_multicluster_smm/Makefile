IMAGENAME := containers.cisco.com/tiswanso/devenv-base-k3d
VERSION := latest
INSTANCENAME := devenv-k3d

build:
	@echo "Building image $(IMAGENAME):$(VERSION)"
	docker build -t $(IMAGENAME):$(VERSION) .
	#docker tag "$(IMAGENAME):latest" "$(IMAGENAME):$(VERSION)"
push:
	#docker push $(IMAGENAME)
	docker push $(IMAGENAME):$(VERSION)
run: stop
	docker run --privileged --name $(INSTANCENAME) -d --rm -p 1001:9090 -p 30880:8080 -e "DEVENV_PASSWORD=secret" -e "DEVENV_PASSWORD=secret" -e "DEVENV_APP_URL=http://localhost:8080" $(IMAGENAME):${VERSION}
	@echo "http://localhost:1001?arg=secret"
stop: 
	docker stop $(INSTANCENAME)  | true
	docker rm  $(INSTANCENAME)  | true 

all: build run

#.PHONY fwd
fwd: 
	kubectl port-forward service/prometheus-operated -n smm-system 9090:9090 --kubeconfig ~/.kube/ds78-kind6.kconf &
	sleep 5
	@echo "yep ... doing something"
	kubectl get pods -n smm-system --kubeconfig ~/.kube/ds78-kind6.kconf
	ps -aef | grep 9090 | head -n 1 | awk '{ print $$2 }'
	kill `ps -aef | grep 9090 | head -n 1 | awk '{ print $$2 }'`
