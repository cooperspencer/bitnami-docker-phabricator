#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

_forwardTerm () {
    echo "Caugth signal SIGTERM, passing it to child processes..."
    pgrep -P $$ | xargs kill -15 2>/dev/null
    wait
    exit $?
}

trap _forwardTerm TERM

nami start --foreground phabricator &
echo "Starting Apache..."
exec httpd -f /opt/bitnami/apache/conf/httpd.conf -D FOREGROUND &
wait
