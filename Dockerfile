FROM ubuntu:18.04 AS BUILD

LABEL mantainer="Adrian Kriel <admin@extremeshok.com>" vendor="eXtremeSHOK.com"

# build time varbiles
ARG OVERLAY_ARCH="amd64"

# environment variables
ENV PS1="[$(whoami)@$(hostname):$(pwd)]$ "
#ENV PS1 "\h:\W \u$ "
ENV HOME="/root"
ENV TERM="xterm"

ENV DEBIAN_FRONTEND="noninteractive"

RUN \
  echo "**** install packages ****" \
  && apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    shadow \
    tar

RUN \
  echo "**** install s6 overlay ****" \
  && S6VERSION="$(curl --silent "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')" \
  && echo "$S6VERSION" \
  && curl --silent -o /tmp/s6-overlay.tar.gz -L \
   "https://github.com/just-containers/s6-overlay/releases/download/${S6VERSION}/s6-overlay-${OVERLAY_ARCH}.tar.gz" \
  && tar xfz /tmp/s6-overlay.tar.gz -C / \
  && rm -f /tmp/s6-overlay.tar.gz

RUN \
  echo "**** install socklog overlay ****" \
  && SOCKLOGVERSION="$(curl --silent "https://api.github.com/repos/just-containers/socklog-overlay/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')" \
  && echo "$SOCKLOGVERSION" \
  && curl --silent -o /tmp/socklog-overlay.tar.gz -L \
   "https://github.com/just-containers/socklog-overlay/releases/download/${SOCKLOGVERSION}/socklog-overlay-${OVERLAY_ARCH}.tar.gz" \
  && tar xfz /tmp/socklog-overlay.tar.gz -C / \
  && rm -f /tmp/socklog-overlay.tar.gz

RUN \
  echo "**** create xs user and make our folders ****" \
  && addgroup --gid 911 --system xs \
  && adduser --uid 911 --system --disabled-password --ingroup xs --home /config --shell /bin/false xs \
  && adduser xs users \
  && mkdir -p \
    /app \
    /config \S6VERSION \
    /defaults

RUN \
  echo "**** cleanup ****" \
  && apt-get clean \
  && rm -rf /etc/cron.daily/ \
  && rm -rf /tmp/*

# add local files
COPY rootfs/ /

RUN chmod 755 /sbin/apt-install

ENTRYPOINT ["/init"]
