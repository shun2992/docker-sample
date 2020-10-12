FROM alpine:3.12 as release

RUN apk --no-cache add bash

FROM release as test
COPY alpine/run_tests.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/run_tests.sh

FROM release as production
