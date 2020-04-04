# Firebase hosting of https://foxygo.at

The `foxygo.at` domain is used to name Go modules. However it does not
host those modules, but instead redirects to the code on github.com.
Firebase is used to do this redirection as it does it easily, cheaply
(free!) and with TLS.

## Requirements

* GNU make
* jsonnet and jsonnetfmt
* Firebase CLI

GNU make should be installed by default on most systems. If not, install
it.

Jsonnet and Firebase can be installed by running:

    make get-tools

This will try to install `firebase` in `/usr/local/bin`. If you do not
have permission to do that, instead run the following commands:

    sudo make get-firebase
    make get-jsonnet

The first command will prompt for your password for root access. Do not
run the `get-jsonnet` target under sudo.

If you don't have sudo access, run:

    mkdir -p $HOME/bin
    make fbinstall=$HOME/bin get-tools

and add `$HOME/bin` to your `PATH`.

## Configuration

Configuration of the redirections (and the entire firebase project) is
generated from the jsonnet. The main config file is `config.jsonnet`
which contains the Firebase hosting config and the redirections to set
up.

To generate the config and deployment files from the source config, run:

    make config

If you edit the jsonnet config files, make sure you format them (if your
editor does not do it automatically) with:

    make fmt

## Deployment

Any changes to the Firebase configuration needs to be deployed. This can
be done by running:

    make deploy

This runs `firebase deploy`. You may need to first run `firebase login`
if you have not yet logged in.
