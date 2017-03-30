#!/usr/bin/env bash
echo "Healthcheck..."
# error or not done yet
[ ! -f "$HEALTHCHECK_FILE" ] && return 1
# more than one lines
[ $(wc -l "$HEALTHCHECK_FILE"  | awk '{print $1}' ) -ne 1 ] && return 1

[ "$(cat "$HEALTHCHECK_FILE")" == "OK" ] && return 0


return 1
