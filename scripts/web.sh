#!/usr/bin/env bash
# =============================================================================
# Atelier 3 — machines virtuelles « web1 » (192.168.56.11) et « web2 » (…12)
# Installe Nginx et publie une page qui affiche QUI a répondu.
# Le même script sert les deux machines virtuelles : c'est la page qui diffère,
# parce qu'elle est construite à partir du nom d'hôte.
# =============================================================================
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

BDD_IP="192.168.56.20"
BASE="atelier"; UTIL="atelier"; MDP="atelier"

echo "== [web] installation de Nginx =="
apt-get update -qq
apt-get install -y -qq nginx postgresql-client

NOM=$(hostname)
IP=$(ip -4 addr show | awk '/192\.168\.56\./ {print $2}' | cut -d/ -f1)

# Couleur distincte par machine virtuelle : l'alternance devient visible d'un
# coup d'œil lors du test du répartiteur.
case "$NOM" in
  web1) COULEUR="#1868F2" ;;
  web2) COULEUR="#0E9F84" ;;
  *)    COULEUR="#5C6787" ;;
esac

# --- Vérification de la liaison avec la base de données ----------------------
# « if » protège du « set -e » : une base injoignable ne doit pas faire échouer
# le provisionnement, elle doit se voir sur la page.
if MSG=$(PGPASSWORD="$MDP" psql -h "$BDD_IP" -U "$UTIL" -d "$BASE" \
          -tAc "SELECT texte FROM messages LIMIT 1" 2>/dev/null); then
  ETAT="base joignable — « ${MSG} »"
else
  ETAT="base INJOIGNABLE depuis ${NOM}"
fi

echo "== [web] publication de la page =="
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="fr">
<meta charset="utf-8">
<title>Atelier 3 — ${NOM}</title>
<style>
  body   { font-family: system-ui, sans-serif; margin: 0;
           display: grid; place-items: center; height: 100vh;
           background: ${COULEUR}; color: #fff; text-align: center; }
  h1     { font-size: 4rem; margin: 0 0 .5rem; letter-spacing: .05em; }
  p      { font-size: 1.2rem; margin: .25rem; opacity: .9; }
</style>
<div>
  <h1>${NOM}</h1>
  <p>adresse : ${IP}</p>
  <p>${ETAT}</p>
  <p>page générée le $(date '+%d/%m/%Y à %H:%M:%S')</p>
</div>
EOF

# --- En-tête de diagnostic ---------------------------------------------------
# curl -sI http://localhost:8080 | grep X-Serveur  →  montre qui a répondu,
# même si le navigateur affiche une version en cache.
cat > /etc/nginx/conf.d/atelier-entete.conf <<EOF
add_header X-Serveur "${NOM}" always;
add_header Cache-Control "no-store" always;
EOF

nginx -t
systemctl reload nginx
systemctl enable --quiet nginx

echo "== [web] ${NOM} prêt sur ${IP}:80 =="
# Nginx écoute par défaut sur 0.0.0.0:80 — rappel du piège n° 1 : un service
# qui n'écouterait que sur 127.0.0.1 serait invisible pour le répartiteur.
