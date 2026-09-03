FROM python:3.14-alpine

RUN apk add --update --no-cache jq

RUN chown -R guest /opt
USER guest
WORKDIR /opt

ENV PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:$PATH"

RUN python -m venv "${VIRTUAL_ENV}" \
    && pip install --upgrade awscli \
    && aws --version

ADD assets/ /opt/resource/
