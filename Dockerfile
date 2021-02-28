FROM docker.io/bitnami/minideb:buster

RUN install_packages build-essential curl ca-certificates tar && \
    curl https://downloads.bitnami.com/files/stacksmith/python-3.6.13-0-linux-amd64-debian-10.tar.gz -so /tmp/python.tar.gz && \
    tar -zxf /tmp/python.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files'

ENV PYTHON_PATH=/opt/bitnami/python
ENV PATH="$PYTHON_PATH/bin:$PATH"
RUN pip install -U pip wheel --no-cache-dir && \
    pip install numpy==1.17.0 --no-cache-dir && \
    pip install luminaire --no-cache-dir && \
    rm -rf /tmp/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
