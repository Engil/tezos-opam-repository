ARG BUILD_IMAGE

FROM ${BUILD_IMAGE}

# Metadata
LABEL org.label-schema.vendor="Nomadic Labs" \
      org.label-schema.url="https://www.nomadic-labs.com" \
      org.label-schema.name="Tezos" \
      org.label-schema.description="Tezos node" \
      org.label-schema.vcs-url=https://gitlab.com/tezos/tezos \
      org.label-schema.docker.schema-version="1.0" \
      distro_style="apk" \
      distro="alpine" \
      distro_long="alpine-$alpine_version" \
      operatingsystem="linux"

RUN apk --no-cache add libev gmp sudo hidapi libffi gcc libc-dev

RUN adduser -S tezos && \
    echo 'tezos ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/tezos && \
    chmod 440 /etc/sudoers.d/tezos && \
    chown root:root /etc/sudoers.d/tezos && \
    sed -i.bak 's/^Defaults.*requiretty//g' /etc/sudoers && \
    mkdir -p /var/run/tezos/node /var/run/tezos/client && \
    sudo chown -R tezos /var/run/tezos

COPY zcash-params /usr/share/zcash-params

USER tezos
ENV USER=tezos

WORKDIR /home/tezos
