# --- Configure and deploy ---

config: fmt ## Generate firebase-hosted files in 'public' folder
	jsonnet -S -c -m . config.jsonnet

fmt: ## Format jsonnet files
	jsonnetfmt -i config.jsonnet firebase.libsonnet

deploy: config  ## Deploy 'public' folder to firebase
	firebase deploy --only hosting --project foxygoat-ab0f2

# --- Install software ----

get-tools: get-firebase get-jsonnet  ## Install/update tools needed by this Makefile

fbos = $(fbos_$(shell uname))
fbos_Linux = linux
fbos_Darwin = macos
fburl = https://github.com/firebase/firebase-tools/releases/latest/download/firebase-tools-$(fbos)
fbinstall = /usr/local/bin/firebase
fblatest = $(shell curl -s -o /dev/null -D - '$(fburl)' | awk -F/ '/^location:/ {print $$8}')
# firebase emits an escape sequence before the version. split on ascii 007 to extract
# `firebase --version | hexdump -C` to demonstrate
fbcurrent = v$(or $(shell firebase --version 2> /dev/null | cut -d '' -f 2),0.0.0)

get-firebase:  ## Install/update firebase CLI to /usr/local/bin
	@if [ "$(fbcurrent)" != "$(fblatest)" ]; then \
		curl -L -o '$(fbinstall)' '$(fburl)'; \
		chmod 755 '$(fbinstall)'; \
	else \
		echo 'Firebase CLI is already at the latest version'; \
	fi

jsonnet = github.com/google/go-jsonnet
# go get is safe because we are not in a go module.
get-jsonnet:  ## Install/update jsonnet CLI tools to $GOPATH/bin
	go get $(jsonnet)/cmd/jsonnet $(jsonnet)/cmd/jsonnetfmt

# --- Builder image for CI ---

builder: ## Create builder image for Google Cloud Build
	docker build -f build/builder.Dockerfile -t foxygoat/firebase-tools .

push-builder: ## Push builder image to docker hub
	docker push foxygoat/firebase-tools

FIREBASE_TOKEN_HELP = $(COLOUR_RED)FIREBASE_TOKEN not set, run\n  firebase login:ci\n  export FIREBASE_TOKEN='<token>'\n$(COLOUR_NORMAL)

run-builder: config ## Run builder image locally
	@[ -n "$${FIREBASE_TOKEN}" ] || { printf "$(FIREBASE_TOKEN_HELP)"; exit 1; }
	docker run --rm \
		--volume $(PWD):/workspace \
		--workdir /workspace \
		--env FIREBASE_TOKEN \
		foxygoat/firebase-tools deploy \
		--only hosting --project foxygoat-ab0f2

# --- Utilities ----

COLOUR_NORMAL = $(shell tput sgr0 2>/dev/null)
COLOUR_RED    = $(shell tput setaf 1 2>/dev/null)
COLOUR_GREEN  = $(shell tput setaf 2 2>/dev/null)
COLOUR_WHITE  = $(shell tput setaf 7 2>/dev/null)

help:
	@awk -F ':.*## ' 'NF == 2 && $$1 ~ /^[A-Za-z0-9_-]+$$/ { printf "$(COLOUR_WHITE)%-30s$(COLOUR_NORMAL)%s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

.PHONY: help
