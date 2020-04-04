config:
	jsonnet -S -c -m . config.jsonnet

fmt:
	jsonnetfmt -i config.jsonnet firebase.libsonnet

deploy: config
	firebase deploy
