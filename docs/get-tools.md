# get-tools

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
