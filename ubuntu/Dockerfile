FROM ubuntu:20.04 as release

RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt focal main restricted\n\
deb mirror://mirrors.ubuntu.com/mirrors.txt focal-updates main restricted\n\
deb mirror://mirrors.ubuntu.com/mirrors.txt focal universe\n\
deb mirror://mirrors.ubuntu.com/mirrors.txt focal-updates universe\n\
deb mirror://mirrors.ubuntu.com/mirrors.txt focal multiverse\n\
deb mirror://mirrors.ubuntu.com/mirrors.txt focal-updates multiverse\n\
deb mirror://mirrors.ubuntu.com/mirrors.txt focal-backports main restricted universe multiverse\n\
deb mirror://mirrors.ubuntu.com/mirrors.txt focal-security main restricted\n\
deb mirror://mirrors.ubuntu.com/mirrors.txt focal-security universe\n\
deb mirror://mirrors.ubuntu.com/mirrors.txt focal-security multiverse\n"> /etc/apt/sources.list

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    locales \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

FROM release as test
COPY ubuntu/run_tests.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/run_tests.sh

FROM release as production
