#!/bin/bash

# Check we have 2 args
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 {joplin|nextcloud|zm} {up|down}"
  exit 1
fi

SERVICE="$1"
ACTION="$2"

# Check action is "up" or "down"
if [[ "$ACTION" != "up" && "$ACTION" != "down" ]]; then
  echo "Error : invalid action. Use 'up' or 'down'."
  exit 2
fi

# Define docker services to start or stop
case "$SERVICE" in
  joplin)
    SERVICES="joplin_app joplin_db"
    ;;
  nextcloud)
    SERVICES="nc-db nc-redis nc-nextcloud nc-cron"
    ;;
  zm)
    SERVICES="zm-db zm"
    ;;
  *)
    echo "Error : unknown service. Use 'joplin', 'nextcloud' or 'zm'."
    exit 3
    ;;
esac

# Execute docker compose command
if [ "$ACTION" = "up" ]; then
  docker compose up $SERVICES -d
else
  docker compose down $SERVICES
fi
