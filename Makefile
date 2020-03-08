.ONESHELL:
.PHONY:	check build tagandpushecs localdev shell
SHELL = /bin/bash
ORG := kazin
PROJECT := home-container
REPOSITORY := home.thirteenjunes.com
VERSION ?=latest
TAG := $(REPOSITORY)/$(ORG)/$(PROJECT):$(VERSION)
MAKEFILE_HOME := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

build:
	docker build $(DOCKER_BUILD_ARGS) -t $(TAG) $(MAKEFILE_HOME)
#
# Both shell and runlocal map script_home to be the current directory so that you can test the
# scripts/what not
#
shell: build
	docker run --rm -it \
		-v "$(realpath $(HOME))":"/home/kazin/home" \
		--entrypoint /bin/bash \
		$(TAG)

save: build
	docker save -o home-container.tgz $(TAG)

check:
	find . -name "*.sh" | grep -v build_context | xargs shellcheck -s bash

