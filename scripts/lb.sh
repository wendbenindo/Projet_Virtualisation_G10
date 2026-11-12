#!/usr/bin/env bash
# =============================================================================
# Atelier 3 — machine virtuelle « lb » (192.168.56.10)
# Nginx en répartiteur de charge devant web1 et web2.
# Port 80 de cette machine virtuelle → http://localhost:8080 sur l'hôte
# (redirection déclarée dans le Vagrantfile).
# =============================================================================
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

WEB1="192.168.56.11"
WEB2="192.168.56.12"

echo "== [lb] installation de Nginx =="
apt-get update -qq
apt-get install -y -qq nginx

echo "== [lb] configuration du répartiteur =="
cat > /etc/nginx/sites-available/repartiteur <<EOF
upstream grappe_web {
    # Répartition « tourniquet » (round-robin) : c'est le mode par défaut.
    # max_fails / fail_timeout : après 1 échec, le serveur est écarté 10 s.
    server ${WEB1}:80 max_fails=1 fail_timeout=10s;
    server ${WEB2}:80 max_fails=1 fail_timeout=10s;
}

server {
    listen 80 default_server;

    location / {
        proxy_pass http://grappe_web;
        proxy_set_header Host              \$host;
        proxy_set_header X-Real-IP         \$remote_addr;
        proxy_set_header X-Forwarded-For   \$proxy_add_x_forwarded_for;

        # Une machine virtuelle éteinte ne répond RIEN : sans délai court,
        # le navigateur attendrait plus d'une minute avant la bascule.
        proxy_connect_timeout 2s;
        proxy_read_timeout    5s;
        proxy_next_upstream   error timeout http_502 http_503 http_504;

        # Sans cela le navigateur réafficherait sa copie en cache et
        # l'alternance entre web1 et web2 serait invisible.
        add_header Cache-Control "no-store" always;
    }

    # Page d'état du répartiteur lui-même : http://localhost:8080/lb-sante
    location = /lb-sante {
        default_type text/plain;
        return 200 "repartiteur lb operationnel\n";
    }
}
EOF

# Ici le lien symbolique est légitime : /etc/nginx n'est pas un dossier
# synchronisé. Dans un partage VirtualBox il serait refusé (piège n° 2).
ln -sfn /etc/nginx/sites-available/repartiteur /etc/nginx/sites-enabled/repartiteur
rm -f /etc/nginx/sites-enabled/default

nginx -t
systemctl reload nginx
systemctl enable --quiet nginx

echo "== [lb] répartiteur prêt : http://localhost:8080 depuis l'hôte =="
# Tests attendus :
#   1) for i in $(seq 6); do curl -sI http://localhost:8080 | grep X-Serveur; done
#      → web1, web2, web1, web2, …
#   2) vagrant halt web1 puis on recharge → seul web2 répond (bascule < 3 s)
#   3) vagrant up web1 puis on recharge → l'alternance reprend après ~10 s
