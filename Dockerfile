# syntax=docker/dockerfile:1

FROM alpine:3

RUN apk update \
    && apk add --no-cache tini curl jq git

COPY --chmod=755 entrypoint.sh /usr/bin/entrypoint.sh
COPY --chmod=755 backup.sh /usr/bin/backup.sh

ENV INSTANT_RUN=true
ENV CRON="0 3 * * *"

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/entrypoint.sh"]
VOLUME ["/backups"]
WORKDIR /backups
CMD [""]

HEALTHCHECK --interval=5m \
    --start-period=5m \
    --start-interval=10s \
    CMD pgrep crond || exit 1
