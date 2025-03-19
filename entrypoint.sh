#!/bin/sh

if [ -z "$GITHUB_USERNAME" ]; then
    echo "Missing environment variable: GITHUB_USERNAME" >&2
    exit 1
fi

if [ -z "$GITHUB_PASSWORD" ]; then
    echo "Missing environment variable: GITHUB_PASSWORD" >&2
    exit 1
fi

cat >/root/.netrc << EOF
machine github.com
login $GITHUB_USERNAME
password $GITHUB_PASSWORD
EOF

if [ $INSTANT_RUN == 'true' ]; then
    /usr/bin/backup.sh
fi

echo "$CRON /usr/bin/backup.sh" >/etc/crontabs/root

touch /var/log/cron.log
ln -sf /proc/1/fd/1 /var/log/cron.log
crond -f -l 0 >/var/log/cron.log 2>&1 &

echo "Cron started successfully."

tail -f /dev/null

