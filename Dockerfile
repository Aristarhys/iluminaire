FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Artem Bashev <artem.bashev@gmail.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PYTHON_LOCATION="/opt/bitnami"

ARG PYTHON_VERSION=3.6.13
ARG NUMPY_VERSION=1.17.0
ARG SCIPY_VERSION=1.2.2

RUN install_packages build-essential curl ca-certificates tar && \
    curl https://downloads.bitnami.com/files/stacksmith/python-${PYTHON_VERSION}-0-${OS_NAME}-${OS_ARCH}-${OS_FLAVOUR}.tar.gz -so /tmp/python.tar.gz && \
    tar -zxf /tmp/python.tar.gz -P --transform "s|^[^/]*/files|${PYTHON_LOCATION}|" --wildcards '*/files'

RUN ${PYTHON_LOCATION}/python/bin/python -m venv luminaire-venv

ENV PATH="/luminaire-venv/bin:$PATH"

RUN pip install -U pip wheel setuptools --no-cache-dir && \
    pip install numpy==${NUMPY_VERSION} --no-cache-dir && \
    pip install scipy==${SCIPY_VERSION} --no-cache-dir && \
    pip install luminaire --no-cache-dir && \
    rm -rf /tmp/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
