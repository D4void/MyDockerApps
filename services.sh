#!/bin/bash

# Vérifie que deux arguments sont fournis
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 {joplin|nextcloud|zm} {up|down}"
  exit 1
fi

SERVICE="$1"
ACTION="$2"

# Vérifie que l'action est bien "up" ou "down"
if [[ "$ACTION" != "up" && "$ACTION" != "down" ]]; then
  echo "Erreur : action invalide. Utilise 'up' ou 'down'."
  exit 2
fi

# Définit les services Docker à lancer ou arrêter
case "$SERVICE" in
  joplin)
    SERVICES="MyJoplinApp MyJoplinPostgres"
    ;;
  nextcloud)
    SERVICES="nc-db nc-redis nc-nextcloud nc-cron"
    ;;
  zm)
    SERVICES="zm-db zm"
    ;;
  *)
    echo "Erreur : service inconnu. Utilise 'joplin', 'nextcloud' ou 'zm'."
    exit 3
    ;;
esac

# Exécute la commande docker compose appropriée
if [ "$ACTION" = "up" ]; then
  docker compose up $SERVICES -d
else
  docker compose down $SERVICES
fi
