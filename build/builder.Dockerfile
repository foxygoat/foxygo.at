FROM golang:buster as jsonnet

ADD Makefile Makefile
RUN make get-jsonnet

FROM node:buster

RUN npm i -g firebase-tools
ADD build/firebase.sh /usr/bin
RUN chmod +x /usr/bin/firebase.sh
COPY --from=jsonnet /go/bin/jsonnet /usr/bin
COPY --from=jsonnet /go/bin/jsonnetfmt /usr/bin

ENTRYPOINT [ "/usr/bin/firebase.sh" ]
