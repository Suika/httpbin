FROM alpine:3.10

LABEL name="httpbin"
LABEL version="0.9.2"
LABEL description="A simple HTTP service."
LABEL org.kennethreitz.vendor="Kenneth Reitz"

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apk add --no-cache --update python3

WORKDIR /httpbin

ADD Pipfile Pipfile.lock /httpbin/

RUN apk add --no-cache --update git python3-dev libffi-dev build-base && \
    pip3 install --no-cache-dir pipenv && pipenv lock -r > requirements.txt && \
    pip3 install --no-cache-dir -r requirements.txt && \
    apk del git python3-dev libffi-dev build-base

ADD . /httpbin

RUN pip3 install --no-cache-dir /httpbin

EXPOSE 80

CMD ["gunicorn", "-b", "0.0.0.0:80", "httpbin:app", "-k", "gevent"]