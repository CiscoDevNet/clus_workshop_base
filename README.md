# clus_workshop_base

Contains content and config for the CLUS workshop hands-on labs.  Docker required to run the images.

## devenv_clus_base_docker_and_vpn

This folder holds the base image that has docker and VPN included.  

- /devenv_clus_base_docker_and_vpn/Dockerfile - commands to  build the docker container
- /devenv_clus_base_docker_and_vpn/Makefile - commands to run the docker container such as "make build", "make run"
- /devenv_clus_base_docker_and_vpn/src/ - folders for each of the code files for each of the labs

## devenv_clus_base_docker_and_k8s

This folder holds the base image that has docker, k8s, Istio included.  

- /devenv_clus_base_docker_and_k8s/Dockerfile - commands to  build the docker container
- /devenv_clus_base_docker_and_k8s/Makefile - commands to run the docker container such as "make build", "make run"
- /devenv_clus_base_docker_and_k8s/src/ - folders for each of the code files for each of the labs

## devenv_clus_base_docker_and_k8s_nonistio

This folder holds the base image that has docker.  

- /devenv_clus_base_docker_and_k8s_nonistio/Dockerfile - commands to  build the docker container
- /devenv_clus_base_docker_and_k8s_nonistio/Makefile - commands to run the docker container such as "make build", "make run"
- /devenv_clus_base_docker_and_k8s_nonistio/src/ - folders for each of the code files for each of the labs

## devenv_clus_base_pyats_vpn

This folder holds the base image that has pyats and vpn.  

- /devenv_clus_base_pyats_vpn/Dockerfile - commands to  build the docker container
- /devenv_clus_base_pyats_vpn/Makefile - commands to run the docker container such as "make build", "make run"
- /devenv_clus_base_pyats_vpn/src/ - folders for each of the code files for each of the labs


## Run the in-browser dev environment locally:

1. cd into the desired image
2. make build (to build it)
3. make run (to run it)
4. Open http://localhost:1001?arg=secret to see the terminal in your browser

# How to edit files in the image

Feel free to use vim, but nano is also installed

# How to use VPN in the image

Set the following environment variables for example

```
export VPN_SERVER=<vpn server address>
export VPN_USERNAME=<user cred name>
export VPN_PASSWORD=<user cred password>
```

Then in the command line:

```
startvpn.sh &
```

Then you should be able to ssh into the necessary IP

# How to use Kubernetes and Istio

Kubernetes and Istio are already installed and launched in the container, but you must check that the are fully up.  To do this run 

```
checkstatus.sh k8s
checkstatus.sh istio
```

# How to run webapps

Included in the image are three sample Flask web apps and a NAT/proxy tool called Caddy.  Port 8080 in the container is exposed for access and will be in the production deployment as well.  To test this out:

```
cd ~/src
caddy run
```

open a new tab to http://localhost:1001/?arg=secret (as if you're opening a new terminal)

```
python app.py 
```

Open your browser to http://localhost:8080/app to see the first app

Open a new tab to http://localhost:1001/?arg=secret (as if you're opening a new terminal)

```
python app2.py 
```

Open your browser to http://localhost:8080/app2 to see the second app

Open a new tab to http://localhost:1001/?arg=secret (as if you're opening a new terminal)

```
python app3.py 
```

Open your browser to http://localhost:8080/app3 to see the third app
