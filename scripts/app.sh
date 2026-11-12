
#!/usr/bin/env bash
set -euo pipefail

# ==================================================
# RÉSULTATS-BF - INSTALLATION DU SERVEUR APPLICATIF
# ==================================================

APP_DIR="/vagrant/app"
APP_FILE="${APP_DIR}/app.py"
SERVICE_NAME="resultats-bf"

echo "=== Installation du serveur applicatif ==="

# 1. Vérifier la présence de l'application
if [ ! -f "$APP_FILE" ]; then
    echo "ERREUR : fichier ${APP_FILE} introuvable."
    echo "Le fichier app/app.py doit être présent dans le projet."
    exit 1
fi

# 2. Installer Python et les dépendances
export DEBIAN_FRONTEND=noninteractive

apt-get update

apt-get install -y \
    python3 \
    python3-flask \
    python3-psycopg2

# 3. Créer le service systemd
cat > "/etc/systemd/system/${SERVICE_NAME}.service" <<EOF
[Unit]
Description=Application RÉSULTATS-BF
After=network.target

[Service]
Type=simple
User=vagrant
WorkingDirectory=${APP_DIR}
ExecStart=/usr/bin/python3 ${APP_FILE}
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# 4. Activer et démarrer le service
systemctl daemon-reload
systemctl enable "${SERVICE_NAME}"
systemctl restart "${SERVICE_NAME}"

# 5. Vérifier le service
if systemctl is-active --quiet "${SERVICE_NAME}"; then
    echo "Application RÉSULTATS-BF démarrée avec succès."
else
    echo "ERREUR : impossible de démarrer l'application."
    systemctl status "${SERVICE_NAME}" --no-pager
    exit 1
fi

echo "=== Provisionnement applicatif terminé ==="
