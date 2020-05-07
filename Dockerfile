FROM ubuntu:20.04 AS BUILD

LABEL mantainer="Adrian Kriel <admin@extremeshok.com>" vendor="eXtremeSHOK.com"

USER root

# build time varbiles
ARG OVERLAY_ARCH="amd64"

# environment variables
ENV PS1="[$(whoami)@$(hostname):$(pwd)]$ "
#ENV PS1 "\h:\W \u$ "
ENV HOME="/root"
ENV TERM="xterm"

ENV DEBIAN_FRONTEND="noninteractive"

RUN echo "**** Upgrade all packages ****" \
  && apt-get update  && apt-get upgrade -y -qq

RUN echo "**** Install packages ****" \
  && apt-get update && apt-get install -qq -y --no-install-recommends \
  ca-certificates \
  cron \
  curl \
  rsync \
  tar \
  wget

RUN echo "**** install s6 overlay ****" \
  && S6VERSION="$(curl --silent "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')" \
  && echo "$S6VERSION" \
  && curl --silent -o /tmp/s6-overlay.tar.gz -L \
   "https://github.com/just-containers/s6-overlay/releases/download/${S6VERSION}/s6-overlay-${OVERLAY_ARCH}.tar.gz" \
  && mkdir -p /tmp/s6-overlay \
  && tar xfz /tmp/s6-overlay.tar.gz -C /tmp/s6-overlay \
  && rsync -h -v -r -P -t --ignore-existing --links /tmp/s6-overlay/ / \
  && rm -f /tmp/s6-overlay.tar.gz \
  && rm -rf /tmp/s6-overlay

RUN echo "**** install socklog overlay ****" \
  && SOCKLOGVERSION="$(curl --silent "https://api.github.com/repos/just-containers/socklog-overlay/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')" \
  && echo "$SOCKLOGVERSION" \
  && curl --silent -o /tmp/socklog-overlay.tar.gz -L \
   "https://github.com/just-containers/socklog-overlay/releases/download/${SOCKLOGVERSION}/socklog-overlay-${OVERLAY_ARCH}.tar.gz" \
  && mkdir -p /tmp/socklog-overlay \
  && tar xfz /tmp/socklog-overlay.tar.gz -C /tmp/socklog-overlay \
  && rsync -h -v -r -P -t --ignore-existing --links /tmp/socklog-overlay/ / \
  && rm -f /tmp/socklog-overlay.tar.gz \
  && rm -rf /tmp/socklog-overlay

RUN echo "**** create xs user and make our folders ****" \
  && addgroup --gid 911 --system xs \
  && adduser --uid 911 --system --disabled-password --ingroup xs --home /config --shell /bin/false xs \
  && adduser xs users \
  && mkdir -p \
    /app \
    /config \S6VERSION \
    /defaults \
    /etc/cron.d

RUN \
  echo "**** cleanup ****" \
  && apt-get clean \
  && echo "" > /var/log/alternatives.log \
  && echo "" > /var/log/bootstrap.log \
  && echo "" > /var/log/dpkg.log \
  && rm -rf /etc/cron.d/* \
  && rm -rf /etc/cron.daily/* \
  && rm -rf /tmp/* \
  && rm -rf /var/cache/apt/* \
  && rm -rf /var/cache/debconf/* \
  && rm -rf /var/cache/ldconfig/* \
  && rm -rf /var/log/apt/*

# add local files
COPY rootfs/ /

RUN echo "**** bugfix missing /sbin/ldconfig.real ****" \
  && ln -s /usr/sbin/ldconfig.real /sbin/ldconfig.real

RUN chmod 744 /sbin/apt-install

ENTRYPOINT ["/init"]
