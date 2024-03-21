# Set default no argument goal to help
.DEFAULT_GOAL := help

# Ensure that errors don't hide inside pipes
SHELL         = /bin/bash
.SHELLFLAGS   = -o pipefail -c

# Setup variables
PROJECT_NAME?=$(shell cat .env | grep -v ^\# | grep COMPOSE_PROJECT_NAME | sed 's/.*=//')
APP_BASEURL?=$(shell cat .env | grep VIRTUAL_HOST | sed 's/.*=//')
APPS_NETWORK?=$(shell cat .env | grep -v ^\# | grep APPS_NETWORK | sed 's/.*=//')
DNSMASQ_CONFIG?=$(shell docker volume inspect --format '{{ .Mountpoint }}' ${PROJECT_NAME}_dns-gen-config)


# Every command is a PHONY, to avoid file naming confliction -> strengh comes from good habits!

.PHONY: hub-build
hub-build:
	# Network creation if not done yet
	@echo "[INFO] Create ${APPS_NETWORK} network if doesn't already exist"
	docker network inspect ${APPS_NETWORK} >/dev/null 2>&1 || docker network create --subnet=172.24.0.0/16 --driver bridge ${APPS_NETWORK}
	#
	# Build the stack
	@echo "[INFO] Building the stack"
	docker compose -f docker-compose-hub.yml build
	@echo "[INFO] Build OK."

.PHONY: help
help:
	@echo "=================================================================================="
	@echo "        Secure HTTPS reverse proxy based on SWAG, Portainer and Authelia  "
	@echo "       >> https://github.com/elasticlabs/https-nginx-proxy-docker-compose"
	@echo " "
	@echo " Hints for developers:"
	@echo "  make build        # Builds the SDI proxy stack"
	@echo "  make up           # brings the hub to life!"
	@echo "  make set-hosts    # Replaces your hosts file with the generated one"
	@echo "  "
	@echo "  make cleanup      # /!\ Remove images, containers, volumes & data"
	@echo "  make update           # Update the whole stack"
	@echo "=================================================================================="

.PHONY: up
up: build
	@echo "[INFO] Bringing up the Hub"
	docker compose up -d --remove-orphans

.PHONY: set-hosts
set-hosts:
	@echo "[INFO] Updating system hosts file (sudo mode)"
	@echo "172.24.0.3	ensg-sdi.docker	hub.ensg-sdi.docker	api.ensg-sdi.docker	data.ensg-sdi.docker"

.PHONY: build
build:
	# Network creation if not done yet
	@echo "[INFO] Create ${APPS_NETWORK} network if doesn't already exist"
	docker network inspect ${APPS_NETWORK} >/dev/null 2>&1 || docker network create --subnet=172.24.0.0/16 --driver bridge ${APPS_NETWORK}
	#
	# Build the stack
	@echo "[INFO] Building the stack"
	docker compose build
	@echo "[INFO] Build OK."

.PHONY: cleanup
cleanup:
	@echo "[INFO] Bringing down the proxy HUB"
	docker compose down --remove-orphans
	@echo "[INFO] Bringing down the SDI stack"
	docker compose down --remove-orphans
	# Delete all hosted persistent data available in volumes
	@echo "[INFO] Cleaning up containers & images"
	docker system prune -a

.PHONY: hard-cleanup
hard-cleanup: cleanup
	@echo "[INFO] Cleaning up static volumes"
	#docker volume rm -f $(PROJECT_NAME)_ssl-certs
	#docker volume rm -f $(PROJECT_NAME)_portainer-data

.PHONY: pull
pull: 
	docker compose pull
	
.PHONY: update
update: pull up sdi-up wait
	docker image prune

.PHONY: wait
wait: 
	sleep 10
