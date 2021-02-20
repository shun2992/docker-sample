FROM alpine:3.13 as release

RUN apk add --no-cache --virtual .build-deps \
curl \
bash

RUN curl https://raw.githubusercontent.com/nektos/act/master/install.sh | bash

RUN apk del .build-deps
