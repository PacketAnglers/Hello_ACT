FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=America/Detriot

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    openssh-server \
    python3 \
    python3-pip \
    snapd \
    sudo \
    wget

COPY requirements.txt requirements.txt

COPY requirements.yml requirements.yml

RUN pip3 install -r requirements.txt

RUN ansible-galaxy collection install -r requirements.yml --force

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t robbyrussell \
    -p git \
    -p ssh-agent \
    -a 'alias pip="pip3"' \
    -a 'alias python="python3"'

ENV SHELL /bin/zsh
