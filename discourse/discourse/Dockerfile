FROM ubuntu:20.04

USER root

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y git curl wget netcat nano iputils-ping net-tools sed

RUN curl -fsSL https://get.docker.com -o get-docker.sh \
    && sh get-docker.sh

RUN git clone https://github.com/discourse/discourse_docker.git /var/discourse

WORKDIR /var/discourse
