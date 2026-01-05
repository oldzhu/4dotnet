FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Allow overriding apt mirrors (useful behind proxies / restricted networks)
ARG APT_MIRROR=http://archive.ubuntu.com/ubuntu/
ARG APT_SECURITY_MIRROR=http://security.ubuntu.com/ubuntu/

# Buildroot host dependencies + common tooling used by this repo's scripts.
# Note: we deliberately keep this broad to reduce "missing package" friction.
RUN set -eux; \
        # Apply mirror overrides for Ubuntu 24.04 (deb822) and legacy sources.list.
        if [ -f /etc/apt/sources.list.d/ubuntu.sources ]; then \
            sed -i "s|URIs: .*archive.ubuntu.com/ubuntu/|URIs: ${APT_MIRROR}|" /etc/apt/sources.list.d/ubuntu.sources; \
            sed -i "s|URIs: .*security.ubuntu.com/ubuntu/|URIs: ${APT_SECURITY_MIRROR}|" /etc/apt/sources.list.d/ubuntu.sources; \
        fi; \
        if [ -f /etc/apt/sources.list ]; then \
            sed -i "s|http://archive.ubuntu.com/ubuntu/|${APT_MIRROR}|g" /etc/apt/sources.list; \
            sed -i "s|http://security.ubuntu.com/ubuntu/|${APT_SECURITY_MIRROR}|g" /etc/apt/sources.list; \
        fi; \
        \
        # Update with retries (some networks intermittently fail on a subset of mirrors).
        for i in 1 2 3 4 5; do \
            apt-get -o Acquire::Retries=5 update && break; \
            echo "apt-get update failed, retry $i/5" >&2; \
            sleep 3; \
        done; \
        \
        # Ensure TLS trust store exists (some mirrors are HTTPS-only).
        apt-get -o Acquire::Retries=5 install -y --no-install-recommends ca-certificates; \
        update-ca-certificates; \
        \
        apt-get -o Acquire::Retries=5 install -y --no-install-recommends \
        bash \
    coreutils \
    file \
    findutils \
    gawk \
    gcc \
    g++ \
    git \
    make \
    patch \
    perl \
    python3 \
    python3-setuptools \
    python3-venv \
    rsync \
    sed \
    unzip \
    wget \
    xz-utils \
    bison \
    flex \
    bc \
    cpio \
    libncurses-dev \
    libssl-dev \
    liblttng-ust-dev \
    texinfo \
    && rm -rf /var/lib/apt/lists/*

# Default to a non-root user experience (the wrapper runs with your UID/GID).
WORKDIR /work/buildroot

CMD ["bash"]
