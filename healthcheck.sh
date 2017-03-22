#!/usr/bin/env bash

if [ -f "$GLOBAL_INITIALIZATION_FILE" ]; then
  if [ cat "$GLOBAL_INITIALIZATION_FILE" == "OK" ]; then
    return 0
  else return 1
  fi
fi

return 1
