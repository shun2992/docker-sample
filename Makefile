.DEFAULT_GOAL := help
.PHONY: help build clean clean-all dockle trivy tests

IMAGE_NAMES=docker-sample_ubuntu docker-sample_centos

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

dockle: ## Run Dockle
	$(eval VERSION := $(shell curl --silent \
	"https://api.github.com/repos/goodwithtech/dockle/releases/latest" | \
	\grep '"tag_name":' | \
	sed -E 's/.*"v([^"]+)".*/\1/' \
	))
	@for image in $(IMAGE_NAMES); do\
		docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
			goodwithtech/dockle:v$(VERSION) $$image || exit 1; \
	done

trivy: ## Run Trivy
	@for image in $(IMAGE_NAMES); do\
		docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
			-v $(HOME)/.cache:/root/.cache/ aquasec/trivy $$image || exit 1; \
	done

tests: build ## Run tests
	docker-compose -f ubuntu/docker-compose.test.yml up --build
	docker-compose -f centos/docker-compose.test.yml up --build
