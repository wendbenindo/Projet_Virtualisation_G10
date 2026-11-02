# Configuration

## Fichiers

### `noeuds.yml` (GÉNÉRÉ AUTOMATIQUEMENT)
**⚠️ NE PAS CRÉER MANUELLEMENT**

Ce fichier est généré par le script `load_balancer.sh` lors du provisionnement.

Il contient la liste dynamique de toutes les VMs avec leurs IPs.

**Exemple de contenu:**
```yaml
load_balancer:
  ip: "192.168.65.11"
  port: 80

app_servers:
  - name: "app1"
    ip: "192.168.65.21"
    port: 5000
  - name: "app2"
    ip: "192.168.65.22"
    port: 5000

database:
  master:
    ip: "192.168.65.31"
    port: 3306
  slave:
    ip: "192.168.65.32"
    port: 3306
```

**Utilisation:** HAProxy lit ce fichier pour configurer son backend.

## ⚠️ Important
Le fichier `noeuds.yml` est dans `.gitignore` car il est généré automatiquement.
