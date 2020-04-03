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

## Deployment

Any changes to the Firebase configuration needs to be deployed. This can
be done by running:

    make deploy

This runs `firebase deploy`. You may need to first run `firebase login`
if you have not yet logged in.
