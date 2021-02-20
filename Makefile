.DEFAULT_GOAL := help
.PHONY: help \
	build \
	clean \
	clean-all \
	dockle \
	dockle-all \
	trivy \
	trivy-all \
	check \
	act \
	build-local \
	clean-local

IMAGE_NAME=docker-sample-alpine
IMAGE_NAMES=docker-sample-ubuntu docker-sample-centos docker-sample-alpine
SERVICE_NAMES=ubuntu centos alpine

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build docker-compose
	docker-compose up --build -d

clean: ## Clean docker-compose images
	-@docker-compose down
	-@docker volume prune -f

clean-all: ## Clean all docker images
	-@docker stop $(shell docker ps -a -q)
	-@docker rm $(shell docker ps -a -q)
	-@docker rmi $(shell docker images -q)
	-@docker volume prune -f
	-@docker network prune -f

dockle: build ## Run Dockle
	$(eval VERSION := $(shell curl --silent \
	"https://api.github.com/repos/goodwithtech/dockle/releases/latest" | \
	\grep '"tag_name":' | \
	sed -E 's/.*"v([^"]+)".*/\1/' \
	))
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
		goodwithtech/dockle:v$(VERSION) $(IMAGE_NAME)

dockle-all: build ## Run Dockle all images
	$(eval VERSION := $(shell curl --silent \
	"https://api.github.com/repos/goodwithtech/dockle/releases/latest" | \
	\grep '"tag_name":' | \
	sed -E 's/.*"v([^"]+)".*/\1/' \
	))
	@for image in $(IMAGE_NAMES); do\
		docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
			goodwithtech/dockle:v$(VERSION) $$image || exit 1; \
	done

trivy: build ## Run Trivy
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
		-v $(HOME)/.cache:/root/.cache/ aquasec/trivy $(IMAGE_NAME)

trivy-all: build ## Run Trivy all images
	@for image in $(IMAGE_NAMES); do\
		docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
			-v $(HOME)/.cache:/root/.cache/ aquasec/trivy $$image || exit 1; \
	done

check: ## Run check
	@for service in $(SERVICE_NAMES); do\
		echo $$service;\
		docker-compose -f $$service/docker-compose.test.yml up || exit 1; \
	done

act: build-local ## Run act
	docker-compose -f local/docker-compose.yml exec \
		-w /docker act act -P ubuntu-latest=docker-sample-actions

build-local: ## Build docker-compose local
	docker-compose -f local/docker-compose.yml up --build -d

clean-local: ## Clean docker-compose local images
	-@docker-compose -f local/docker-compose.yml down
	-@docker volume prune -f
