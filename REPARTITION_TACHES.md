# Répartition des tâches - Groupe 10

**Équipe :** 3 personnes  
**Durée :** 4 semaines  
**Projet :** RÉSULTATS-BF - Infrastructure haute disponibilité

---

## 👥 Membres de l'équipe

| Nom | Rôle principal | Email/Contact |
|-----|----------------|---------------|
| **Membre 1** | Infrastructure & Load Balancer | _à compléter_ |
| **Membre 2** | Base de données & Réplication | _à compléter_ |
| **Membre 3** | Application & Tests | _à compléter_ |

---

## 📋 Tâches par personne

### 🔵 Membre 1 - Infrastructure & Load Balancer

**Fichiers à créer :**
- [ ] `Vagrantfile` - Configuration complète des VMs
- [ ] `scripts/load_balancer.sh` - Provisionnement HAProxy
- [ ] Extension E1 ou E2 (au choix)

**Responsabilités :**
- Configuration des 5 VMs (lb1, app1, app2, bdd1, bdd2)
- Génération automatique de `config/noeuds.yml`
- Configuration HAProxy avec backend dynamique
- Paramètre `NB_APP` fonctionnel
- Tests V1 - Répartition de charge
- Tests V5 - Reconstruction complète

**Estimation :** ~30h

---

### 🟢 Membre 2 - Base de données & Réplication

**Fichiers à créer :**
- [ ] `scripts/db_master.sh` - Configuration MySQL Master
- [ ] `scripts/db_slave.sh` - Configuration MySQL Slave
- [ ] `sql/init_data.sql` - Génération 50 000 candidats
- [ ] Extension E1 ou E2 (au choix)

**Responsabilités :**
- Installation et configuration MySQL sur bdd1
- Configuration de la réplication Master-Slave
- Génération des données de test (50k candidats)
- Gestion des secrets (.env)
- Tests V4 - Basculement base de données
- Documentation architecture BDD

**Estimation :** ~30h

---

### 🟡 Membre 3 - Application & Tests

**Fichiers à créer :**
- [ ] `scripts/app_server.sh` - Provisionnement serveurs Flask
- [ ] `app/app.py` - Application Flask (<100 lignes)
- [ ] `tests/test_*.sh` - Scripts de tests V1-V6
- [ ] Extension E3 ou E4 (au choix)

**Responsabilités :**
- Développement application Flask (API JSON)
- Connexion à la base de données
- Endpoint `/health` pour HAProxy
- Endpoint `/resultat?matricule=XXX`
- Tests V2 - Résilience aux pannes
- Tests V3 - Scalabilité
- Documentation tests et résultats

**Estimation :** ~30h

---

## 🤝 Tâches communes (TOUS)

**Documentation (partagée) :**
- [ ] `docs/architecture.md` - Schémas et description technique
- [ ] `docs/journal_de_bord.md` - Suivi hebdomadaire
- [ ] `docs/resultats_tests.md` - Résultats mesurés
- [ ] `docs/guide_utilisation.md` - Manuel utilisateur
- [ ] Préparation de la démo (20 min)

**Révision croisée :**
- Chaque membre revoit le code des autres (Pull Requests)
- Tests d'intégration ensemble
- Validation finale sur machine vierge

---

## 📅 Planning suggéré

### Semaine 1 - Fondations
- [x] Lecture du sujet
- [ ] Structure du projet créée
- [ ] Vagrantfile de base (Membre 1)
- [ ] Scripts shell vides créés
- [ ] Première réunion de synchronisation

### Semaine 2 - Développement
- [ ] Load Balancer fonctionnel (Membre 1)
- [ ] Base de données Master configurée (Membre 2)
- [ ] Application Flask de base (Membre 3)
- [ ] `vagrant up` fonctionne (même sans réplication)

### Semaine 3 - Intégration
- [ ] Réplication MySQL opérationnelle (Membre 2)
- [ ] Tests V1, V2, V3 réalisés (Membre 3)
- [ ] Extension 1 implémentée (à définir qui)
- [ ] Extension 2 implémentée (à définir qui)
- [ ] Tests V4, V5, V6

### Semaine 4 - Finalisation
- [ ] Documentation complète
- [ ] Tests sur machine vierge
- [ ] Corrections des bugs
- [ ] Préparation de la démo
- [ ] Répétition de la présentation
- [ ] Rendu final

---

## 🎯 Extensions à implémenter (minimum 2)

**À décider ensemble :**
- [ ] **E1** - Load balancer de secours (lb2) avec Keepalived
- [ ] **E2** - Monitoring (Prometheus + Grafana)
- [ ] **E3** - Cache Redis pour améliorer les performances
- [ ] **E4** - Déploiement sans interruption (blue-green)

**Répartition suggérée :**
- Extension 1 : _Membre à définir_
- Extension 2 : _Membre à définir_

---

## 📊 Critères d'évaluation (rappel)

| Critère | Points | Responsable |
|---------|--------|-------------|
| Reconstruction (`vagrant up`) | 4 | Membre 1 |
| Scalabilité (NB_APP) | 3 | Membre 1 |
| Résilience (pannes) | 4 | Membre 2 + 3 |
| Qualité technique | 2 | TOUS |
| Extensions (min 2) | 2 | Membres 1+2 ou 1+3 |
| Dossier + mesures | 3 | TOUS |
| Démonstration | 2 | TOUS |
| **TOTAL** | **20** | |

---

## 🔄 Workflow Git

**Branches :**
```bash
main                    # Code validé uniquement
├── feature/vagrant     # Membre 1
├── feature/database    # Membre 2
└── feature/app         # Membre 3
```

**Règles :**
1. **Jamais de commit direct sur `main`**
2. Créer une branche pour chaque fonctionnalité
3. Faire des commits réguliers avec messages clairs
4. Ouvrir une Pull Request pour merge
5. Au moins 1 autre membre doit valider avant merge

**Exemples de commits :**
```
✅ feat: add Vagrantfile with 5 VMs configuration
✅ feat: configure HAProxy load balancing
✅ feat: implement MySQL replication
✅ fix: correct database connection timeout
✅ docs: add architecture diagrams
```

---

## 📞 Communication

**Outils suggérés :**
- Discord/WhatsApp : Communication quotidienne
- Trello/Notion : Suivi des tâches
- Git : Code et révisions
- Google Meet/Zoom : Réunions hebdomadaires

**Réunions prévues :**
- Semaine 1 : Kick-off et répartition
- Semaine 2 : Point d'avancement
- Semaine 3 : Tests d'intégration
- Semaine 4 : Répétition de la démo

---

## ⚠️ Points d'attention

**Pénalités à éviter :**
- ❌ Mots de passe dans Git (-∞)
- ❌ `vagrant up` échoue (note plafonnée à 8/20)
- ❌ Mesures inventées (-4 points)
- ❌ IPs en dur dans le code (-2 points)
- ❌ Moins de 2 extensions (-2 points)

**Succès garantis :**
- ✅ Tester `vagrant up` régulièrement
- ✅ Faire des commits atomiques et clairs
- ✅ Documenter au fur et à mesure
- ✅ S'entraider et communiquer
- ✅ Mesures réelles et honnêtes

---

## 📝 Notes

_Ce fichier doit être mis à jour au fur et à mesure du projet._

**Dernière mise à jour :** _[Date]_  
**Statut global :** 🟡 En cours
