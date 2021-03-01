FROM docker.io/bitnami/minideb:buster

ARG PYTHON_VERSION=3.6.13
ARG NUMPY_VERSION=1.17.0

RUN install_packages build-essential curl ca-certificates tar && \
    curl https://downloads.bitnami.com/files/stacksmith/python-${PYTHON_VERSION}-0-linux-amd64-debian-10.tar.gz -so /tmp/python.tar.gz && \
    tar -zxf /tmp/python.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files'

ENV PYTHON_PATH=/opt/bitnami/python
ENV PATH="$PYTHON_PATH/bin:$PATH"
RUN pip install -U pip wheel --no-cache-dir && \
    pip install numpy==${NUMPY_VERSION} --no-cache-dir && \
    pip install luminaire --no-cache-dir && \
    rm -rf /tmp/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
