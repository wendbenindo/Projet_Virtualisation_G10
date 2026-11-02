# Projet RÉSULTATS-BF - Groupe 10

Infrastructure de consultation de résultats d'examens avec haute disponibilité et scalabilité.

## 📋 Structure du projet

```
Projet_Virtualisation_G10/
├── README.md              # Ce fichier
├── .gitignore             # ✅ Fichiers à ignorer
├── .gitattributes         # ✅ Gestion fins de ligne
├── .env.exemple           # ✅ Template des secrets
├── Vagrantfile            # À CRÉER - Configuration VMs
├── app/                   # Application Flask
├── scripts/               # Scripts de provisionnement
├── config/                # Fichiers de configuration
├── sql/                   # Scripts SQL
├── tests/                 # Scripts de tests
└── docs/                  # Documentation du projet
```

## 🚀 Démarrage rapide

### Prérequis
- VirtualBox installé
- Vagrant installé
- 8 Go de RAM minimum (3 Go pour les VMs)

### Installation

1. **Cloner le dépôt**
   ```bash
   git clone <url-du-repo>
   cd Projet_Virtualisation_G10
   ```

2. **Créer le fichier .env** (secrets)
   ```bash
   cp .env.exemple .env
   # Éditer .env avec les vrais mots de passe
   ```

3. **Lancer l'infrastructure**
   ```bash
   vagrant up
   ```

4. **Accéder à l'application**
   - Interface : http://localhost:8080
   - Stats HAProxy : http://localhost:8080/stats

## 📊 Architecture

### VMs déployées
- **lb1** (192.168.65.11) - Load Balancer HAProxy
- **app1, app2** (192.168.65.21-22) - Serveurs Flask
- **bdd1** (192.168.65.31) - MySQL Master
- **bdd2** (192.168.65.32) - MySQL Slave (réplication)

### Scalabilité
```bash
NB_APP=4 vagrant up   # Démarrer avec 4 serveurs au lieu de 2
```

## 🎯 Répartition des tâches

**📋 Voir le fichier détaillé : [REPARTITION_TACHES.md](./REPARTITION_TACHES.md)**

| Membre | Rôle | Fichiers principaux |
|--------|------|---------------------|
| **Membre 1** | Infrastructure & Load Balancer | `Vagrantfile`, `scripts/load_balancer.sh` |
| **Membre 2** | Base de données & Réplication | `scripts/db_master.sh`, `scripts/db_slave.sh`, `sql/init_data.sql` |
| **Membre 3** | Application & Tests | `app/app.py`, `scripts/app_server.sh`, `tests/*.sh` |
| **TOUS** | Documentation | `docs/*.md` |

## 📝 Checklist avant rendu

- [ ] `vagrant up` fonctionne sur une machine vierge
- [ ] Aucun mot de passe dans Git
- [ ] Fichier `config/noeuds.yml` généré automatiquement
- [ ] Tests V1 à V6 réalisés avec mesures
- [ ] Documentation complète dans `docs/`
- [ ] Journal de bord rempli
- [ ] 2 extensions implémentées minimum

## 🔗 Liens utiles

- Sujet du projet : (à ajouter)
- Dépôt Git : (à ajouter)
- Trello/Kanban : (à ajouter)
