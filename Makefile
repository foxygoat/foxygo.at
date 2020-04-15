# --- Configure and deploy ---
config:
	jsonnet -S -c -m . config.jsonnet

fmt:
	jsonnetfmt -i config.jsonnet firebase.libsonnet

deploy: config
	firebase deploy

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

get-firebase:  ## Install/update firebase CLI to $(fbinstall)
	@if [ "$(fbcurrent)" != "$(fblatest)" ]; then \
		curl -L -o '$(fbinstall)' '$(fburl)'; \
		chmod 755 '$(fbinstall)'; \
	else \
		echo 'Firebase CLI is already at the latest version'; \
	fi

jsonnet = github.com/google/go-jsonnet
# go get is safe because we are not in a go module.
get-jsonnet:  ## Install/update jsonnet CLI tools
	go get $(jsonnet)/cmd/jsonnet $(jsonnet)/cmd/jsonnetfmt
