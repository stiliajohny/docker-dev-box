#------------------------------------------#
#        Standard Makefile Vars            #
#------------------------------------------#

SHELL		= /bin/sh
RM			= rm -f
BOLD		= $(shell tput bold)
RED			= $(shell tput setaf 1)
GREEN		= $(shell tput setaf 2)
YELLOW		= $(shell tput setaf 3)
RESET		= $(shell tput sgr0)

DOCKER		=$(shell which docker)
PACKER		=$(shell which packer)
TRIVY		=$(shell which trivy)
GIT_ROOT	=$(shell git rev-parse --show-toplevel)


DOCKERFILE	=Dockerfile
VERSION 	=18.04
TAG_ID		=dev
IMAGE_NAME	=docker-dev-box
VNC_PORT	=6080

all: help ## Default: will run help to show options.

debug: ## Standard: output variable values to assist with debugging.
	@echo "$(BOLD)$(GREEN)Variables$(RESET)"
	@echo "$(BOLD)$(GREEN)----------------------$(RESET)"
	@echo "$(BOLD)$(GREEN)DOCKER		= $(YELLOW)$(shell which docker)"
	@echo "$(BOLD)$(GREEN)PYTHON39	= $(YELLOW)$(shell which python3.9)"
	@echo "$(BOLD)$(GREEN)TRIVY		= $(YELLOW)$(shell which trivy)"
	@echo "$(BOLD)$(GREEN)GIT_ROOT	= $(YELLOW)$(GIT_ROOT)"
	@echo "$(BOLD)$(GREEN)DOCKERFILE	= $(YELLOW)$(DOCKERFILE)$(RESET)"
	@echo "$(BOLD)$(GREEN)TAG_ID		= $(YELLOW)$(TAG_ID)$(RESET)"
	@echo "$(BOLD)$(GREEN)VERSION		= $(YELLOW)$(VERSION)$(RESET)"
	@echo "$(BOLD)$(GREEN)IMAGE_NAME	= $(YELLOW)$(IMAGE_NAME)$(RESET)"


help: ## Standard: helper function, listing all targets and descriptions.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

check-all: check-docker ## Check: Validate
	@echo "$(BOLD)$(GREEN)Checking Done......$(RESET)"

check-docker: ## Check: Confirm Docker dependencies
	@if [ -z $(DOCKER) ]; then \
		echo "$(BOLD)$(RED)Error: Couldn't find binary 'docker'$(RESET)"; \
		exit 1; \
	elif [ $(DOCKER) ]; then \
		echo "$(BOLD)$(GREEN)Found Docker on $(DOCKER)$(RESET)"; \
	fi

check-trivy: ## Check: Confirm Trivy dependencies
	@if [ -z $(TRIVY) ]; then \
		echo "$(BOLD)$(RED)Error: Couldn't find binary 'trivy'$(RESET)"; \
		exit 1; \
	elif [ $(PACKER) ]; then \
		echo "$(BOLD)$(GREEN)Found Poetry on $(TRIVY)$(RESET)"; \
	fi

build-docker-ubuntu: check-all ## Standard: Docker build Ubuntu images
	@echo "$(YELLOW)TAG_ID = $(TAG_ID)$(RESET)"
	@echo "$(YELLOW)VERSION = $(VERSION)$(RESET)"
	@$(DOCKER) build -f $(DOCKERFILE).ubuntu --build-arg VERSION=${VERSION} -t $(IMAGE_NAME)-ubuntu:xfce-18.04-$(TAG_ID) .

build-docker-archlinux: check-all ## Standard: Docker build Archlinux images
	@echo "$(YELLOW)TAG_ID = $(TAG_ID)$(RESET)"
	@echo "$(YELLOW)VERSION = $(VERSION)$(RESET)"
	@$(DOCKER) build --no-cache -f $(DOCKERFILE).archlinux -t $(IMAGE_NAME)-archlinux:$(TAG_ID) .

run-docker-ubuntu: check-all  ## Standard: Run the docker image with given arguments
	@echo "$(BOLD)$(GREEN)Starting container...$(RESET)"
	@docker run -d -p 5900:5900 -p $(VNC_PORT):6080 --name="$(IMAGE_NAME)-ubuntu" -h "docker-dev-box"  -e VNC_PASSWD=password $(IMAGE_NAME)-ubuntu:xfce-18.04-$(TAG_ID)

run-docker-archlinux: check-all  ## Standard: Run the docker image with given arguments
	@docker run -d -p 5900:5900 -p $(VNC_PORT):6080 --name="$(IMAGE_NAME)-archlinux" -h "docker-dev-box"  -e VNC_PASSWD=password $(IMAGE_NAME)-archlinux:$(TAG_ID)

stop-docker-ubuntu: ## Stop the the running containers
	@echo "$(BOLD)$(GREEN)Stoping Ubuntu container...$(RESET)"
	@docker rm -f "$(IMAGE_NAME)-ubuntu"

stop-docker-archlinux: ## Stop the the running containers
	@echo "$(BOLD)$(GREEN)Stoping Archlinux container...$(RESET)"
	@docker rm -f "$(IMAGE_NAME)-archlinux"

push-docker: check-all ## Standard: Push docker images on GitHub
	@echo "$(YELLOW)TAG_ID = $(TAG_ID)$(RESET)"
	@if [ "$(shell  docker system info | grep  Registry |  awk -F':' {'print$$2$$NF'})" = " https//index.docker.io/v1/" ]; \
	then \
	echo "$(GREEN)You are logged-in: $(YELLOW)$(shell  docker system info | grep  Registry |  awk -F':' {'print$$2$$NF'}) $(RESET)";\
	else \
	echo "$(RED)Issue with docker registry access$(RESET)"; \
	fi
	@if [ "$(shell  docker system info | grep  Registry |  awk -F':' {'print$$2$$NF'})" = " https//index.docker.io/v1/" ]; \
	then \
	docker push ghcr.io/stiliajohny/docker-dev-top/$(IMAGE_TAG);\
	else \
	echo fail; \
	fi

