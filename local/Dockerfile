FROM ubuntu:20.04

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
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    locales \
    make \
    software-properties-common \
    nodejs \
 && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

SHELL ["/bin/bash", "-c"]

# docker

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
 && add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
RUN apt-get update && apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# docker-compose

RUN VERSION=$( \
    curl --silent "https://api.github.com/repos/docker/compose/releases/latest" | \
    grep '"tag_name":' | \
    sed -E 's/.*"([^"]+)".*/\1/' \
    ) \
 && curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
 && chmod +x /usr/local/bin/docker-compose
