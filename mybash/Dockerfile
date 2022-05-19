FROM alpine

RUN apk add bash

COPY urlencode /bin/
COPY switchvault /bin/

ENTRYPOINT ["/bin/urlencode"]
