FROM python:3.14-alpine

ARG RESOURCE_VERSION="1.0"
ENV RESOURCE_VERSION="${RESOURCE_VERSION}"

RUN apk add --update --no-cache jq \
    && pip install --upgrade awscli

ADD assets/ /opt/resource/
