#!/bin/sh
set -e

if [[ $stream_max_length ]]; then
  sed -i "s/^#StreamMaxLength .*$/StreamMaxLength $stream_max_length/g" /etc/clamav/clamd.conf
fi

freshclam -d &
clamd &

pids=`jobs -p`

exitcode=0

terminate() {
    for pid in $pids; do
        if ! kill -0 $pid 2>/dev/null; then
            wait $pid
            exitcode=$?
        fi
    done
    kill $pids 2>/dev/null
}

trap terminate CHLD
wait

exit $exitcode
