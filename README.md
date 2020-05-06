# Firebase hosting of https://foxygo.at

The `foxygo.at` domain is used to serve github.com/foxygoat repositories
as Go modules and raw file content.

It does not host those repositories, but instead redirects to the code
on github.com. Firebase is used to do this redirection as it does it
easily, cheaply (free!) and with TLS.

## Requirements

- GNU make
- jsonnet and jsonnetfmt
- Firebase CLI

GNU make should be installed by default on most systems. If not, install
it.

Jsonnet and Firebase can be installed by running:

    make get-tools

Without appropriate permissions this might fail, see [docs/get-tools.md]
for help.

## Publish a new repo

Edit `config.jsonnet`. If you want to add a new go module add the
repository name to `go_modules`. If you want to add a new raw GitHub
file serving repository add the repository name to `go_modules`.

Run `make config` and commit changes. The changes will be deployed when
merged to `master` by our CI/CD system on [Google Cloud Builds](https://console.cloud.google.com/cloud-build/builds?project=foxygoat-ab0f2).

## Help

Most operations are driven by the `Makefile`, to see them run

    make help

## Manual deployment

Changes are typically deployed by CI / CD pipeline but can be manually
deployed with

    make deploy

This runs `firebase deploy`. You may need to first run `firebase login`
if you have not yet logged in.
