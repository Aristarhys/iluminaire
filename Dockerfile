FROM docker.io/bitnami/minideb:buster

RUN install_packages build-essential curl ca-certificates tar && \
    curl https://downloads.bitnami.com/files/stacksmith/python-3.6.13-0-linux-amd64-debian-10.tar.gz -so python.tar.gz && \
    tar -zxf python.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf python.tar.gz

ENV VIRTUAL_ENV=/opt/venv
RUN /opt/bitnami/python/bin/python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install -U pip wheel --no-cache-dir && \
    pip install numpy==1.17.0 --no-cache-dir && \
    pip install luminaire --no-cache-dir

ENTRYPOINT ["python"]
