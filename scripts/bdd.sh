#!/usr/bin/env bash
# =============================================================================
# Atelier 3 — machine virtuelle « bdd » (192.168.56.20)
# Installe PostgreSQL et l'ouvre au réseau privé de l'atelier.
# Script idempotent : « vagrant provision » peut être relancé sans dégât.
# =============================================================================
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

RESEAU="192.168.56.0/24"
BASE="atelier"
UTIL="atelier"
MDP="atelier"          # mot de passe de démonstration — jamais en production

echo "== [bdd] installation de PostgreSQL =="
apt-get update -qq
apt-get install -y -qq postgresql

# --- Répertoires de configuration (la version de PostgreSQL varie) -----------
CONF=$(find /etc/postgresql -name postgresql.conf | head -n1)
CONFD="$(dirname "$CONF")/conf.d"
HBA="$(dirname "$CONF")/pg_hba.conf"
mkdir -p "$CONFD"

# --- Piège n° 1 : écouter sur 0.0.0.0, pas seulement sur 127.0.0.1 -----------
# Un fichier déposé dans conf.d est relu automatiquement : pas de sed, donc
# pas d'accumulation de lignes si le script est rejoué.
echo "== [bdd] ouverture de l'écoute réseau =="
cat > "$CONFD/atelier.conf" <<'EOF'
listen_addresses = '*'
EOF

# --- Autorisation d'accès depuis le réseau privé de l'atelier ----------------
LIGNE="host    ${BASE}    ${UTIL}    ${RESEAU}    scram-sha-256"
grep -qF "$LIGNE" "$HBA" || echo "$LIGNE" >> "$HBA"

systemctl restart postgresql

# --- Rôle et base : créés seulement s'ils n'existent pas ---------------------
echo "== [bdd] création du rôle et de la base =="
EXISTE_ROLE=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${UTIL}'")
[ "$EXISTE_ROLE" = "1" ] || \
  sudo -u postgres psql -c "CREATE ROLE ${UTIL} LOGIN PASSWORD '${MDP}';"

EXISTE_BASE=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='${BASE}'")
[ "$EXISTE_BASE" = "1" ] || \
  sudo -u postgres createdb -O "${UTIL}" "${BASE}"

# --- Jeu de données minimal --------------------------------------------------
sudo -u postgres psql -d "${BASE}" <<SQL
CREATE TABLE IF NOT EXISTS messages (id serial PRIMARY KEY, texte text NOT NULL);
INSERT INTO messages (texte)
  SELECT 'Bonjour depuis la base de donnees'
  WHERE NOT EXISTS (SELECT 1 FROM messages);
GRANT SELECT ON messages TO ${UTIL};
SQL

echo "== [bdd] PostgreSQL prêt sur ${RESEAU} =="
# Vérification locale :
#   vagrant ssh bdd -c "sudo -u postgres psql -d atelier -c 'TABLE messages'"
#
# Remarque pédagogique : les données de PostgreSQL restent dans /var/lib/postgresql,
# à l'intérieur de la machine virtuelle. On ne place JAMAIS un répertoire de données
# de base sur un dossier synchronisé (vboxsf ne respecte ni les verrous ni fsync).
