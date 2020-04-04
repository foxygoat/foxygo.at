# Redirection

HTTP and HTML redirection are used to point the `foxygo.at` domain
appropriately for two purposes: Go modules, and file serving from a git
repository. Both redirections point to `github.com/foxygoat` but are
done differently as Go modules require some HTML metadata to be served
properly. That requires HTML redirection so we can attach that metadata
before being redirected. The file serving is a more simple HTTP
redirection to `raw.githubusercontent.com/foxygoat`.

The file [`config.jsonnet`](config.jsonnet) contains a list of both
redirections and is used to generate the firebase config file
(`firebase.json`) which contains the HTTP redirections and the
`index.html` files which contain the HTML Go metadata and redirections.

Generating these files is done through a Makefile, by running:

    make config

`config.jsonnet` also contains the standard firebase config, into which
the HTTP redirections are added.

HTML redirection is used to redirect Go module references from
`foxygo.at/<module>` to `github.com/foxygoat/<module>`. A module
redirection should be set up for each module published under
`foxygo.at`.

Files redirection is used to redirect repository file access references
to be able to serve files from a `github.com/foxygoat` repository.
Currently this is intended to serve jsonnet files for use by
`foxygo.at/jsonnext/importer`.

