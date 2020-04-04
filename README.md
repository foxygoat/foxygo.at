# Firebase hosting of https://foxygo.at

The `foxygo.at` domain is used to name Go modules. However it does not
host those modules, but instead redirects to the code on github.com.
Firebase is used to do this redirection as it does it easily, cheaply
(free!) and with TLS.

## DNS Setup

The GCP project hosting the firebase project is `foxygoat-ab0f2` which
has a custom domain set up as per the [firebase custom domain
docs](https://firebase.google.com/docs/hosting/custom-domain). To
implement this, three DNS records were created in the [GoDaddy DNS
Management for foxygo.at](https://dcc.godaddy.com/manage/foxygo.at/dns):

  * a `TXT` record for google-site-verification
  * 2 `A` records (151.101.1.195, 151.101.65.195)

In BIND zone format:

    @       3600     IN     A       151.101.1.195
    @       3600     IN     A       151.101.65.195
    @       600      IN     TXT     "google-site-verification=<redacted>"

The shorter timeout on the `TXT` record is so if we need to re-create
it, it will not take too long to propagate. It will be queried
infrequently (just on setup I assume) so the short expiry should not
create excessive lookups.

## Firebase setup

The initial files in this repository have been created using the
[`firebase` CLI tool](https://firebase.google.com/docs/cli) and running:

    firebase init

The only Firebase product selected was `Hosting`.

## Redirection

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

## Deployment

Any changes to the Firebase configuration needs to be deployed. This can
be done by running:

    make deploy

This runs `firebase deploy`. You may need to first run `firebase login`
if you have not yet logged in.
