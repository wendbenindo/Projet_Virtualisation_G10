# Scripts de provisionnement

Scripts shell exécutés par Vagrant lors du `vagrant up`.

## Fichiers à créer

### 1. `load_balancer.sh`
**Machine:** lb1  
**Rôle:** Installer et configurer HAProxy

**Tâches:**
- Installer HAProxy
- Générer `/vagrant/config/noeuds.yml` dynamiquement avec les IPs des VMs
- Configurer HAProxy à partir de `noeuds.yml` (pas d'IPs en dur !)
- Redémarrer HAProxy

### 2. `app_server.sh`
**Machine:** app1, app2, ...  
**Rôle:** Déployer l'application Flask

**Tâches:**
- Installer Python 3, pip, venv
- Copier l'application depuis `/vagrant/app/`
- Installer les dépendances Python
- Créer un service systemd
- Démarrer l'application sur le port 5000

### 3. `db_master.sh`
**Machine:** bdd1  
**Rôle:** Configurer MySQL Master

**Tâches:**
- Installer MySQL
- Configurer la réplication (server-id=1, log_bin)
- Créer la base de données `resultats_bf`
- Importer les données SQL (`sql/init_data.sql`)
- Créer les utilisateurs (app, réplication)

### 4. `db_slave.sh`
**Machine:** bdd2  
**Rôle:** Configurer MySQL Slave

**Tâches:**
- Installer MySQL
- Configurer en slave (server-id=2, relay-log, read_only)
- Se connecter au master et démarrer la réplication
- Vérifier le statut de la réplication

## Variables d'environnement disponibles
Les scripts reçoivent des variables depuis le Vagrantfile:
- `SUBNET` - Sous-réseau (ex: 192.168.65)
- `NB_APP` - Nombre de serveurs applicatifs
- `DB_HOST` - IP de la base de données
- `APP_ID` - Numéro du serveur (1, 2, ...)

## ⚠️ Important
- Tous les scripts doivent être idempotents (réexécutables sans erreur)
- Utiliser `set -e` en début de script (arrêt sur erreur)
- Charger les secrets depuis `/vagrant/.env`
