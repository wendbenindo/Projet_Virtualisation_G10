# Répartition des tâches - Groupe 10

**Équipe :** 3 personnes  
**Durée :** 4 semaines  
**Projet :** RÉSULTATS-BF - Infrastructure haute disponibilité

---

## 👥 Membres de l'équipe

| Nom | Rôle principal | Email/Contact |
|-----|----------------|---------------|
| **Membre A** | Infrastructure et répartition | _à compléter_ |
| **Membre B** | Données et application | _à compléter_ |
| **Membre C** | Essais, observabilité et documentation | _à compléter_ |

---

## 📋 Tâches par personne

### 🔵 Membre A - Infrastructure et répartition

**Fichiers à créer :**
- [ ] `.gitattributes` - Gestion fins de ligne
- [ ] `.gitignore` - Fichiers à exclure
- [ ] `Vagrantfile` - Configuration complète des VMs
- [ ] `scripts/lb.sh` - Provisionnement HAProxy
- [ ] Template HAProxy généré depuis `config/noeuds.yml`
- [ ] Extension **E1** - Load balancer de secours (lb2, keepalived)

**Responsabilités :**
- Plan d'adressage IP (à confirmer avec l'enseignant)
- Configuration des 5 VMs avec mémoire exacte :
  - lb1 : 192.168.X.11 (512 Mo) - port 8080 exposé
  - app1, app2 : 192.168.X.21-22 (512 Mo chacun)
  - bdd1, bdd2 : 192.168.X.31-32 (**768 Mo chacun**)
  - **Total : 3 Go (512+512+512+768+768)**
- Boîte Vagrant : `bento/ubuntu-24.04` version `202404.23.0`
- Génération automatique de `config/noeuds.yml`
- HAProxy configuré avec sonde `/sante` (pas `/health`)
- Paramètre `NB_APP` fonctionnel

**Tests assignés :**
- V1 - Répartition de charge
- V2 - Résilience aux pannes
- V6 - Load balancer de secours (lb2)

**Rotation obligatoire :**
- Écrire le script de test de charge `ab` (V3)
- Relire `replique.sh` (Membre B)

**Estimation :** ~30h

---

### 🟢 Membre B - Données et application

**Fichiers à créer :**
- [ ] `scripts/bdd.sh` - Configuration PostgreSQL Master
- [ ] `scripts/replique.sh` - Configuration PostgreSQL Réplique (streaming replication)
- [ ] `sql/init.sql` - Génération 50 000 candidats
- [ ] `scripts/bascule.sh` - Script de basculement automatique et chronométré
- [ ] `app/app.py` - Application Flask (<100 lignes)
- [ ] `scripts/app.sh` - Déploiement de l'application

**Responsabilités :**
- Installation PostgreSQL (pas MySQL !) sur bdd1 et bdd2
- Réplication en flux (streaming replication)
- Port PostgreSQL : **5432**
- Génération 50 000 candidats avec `generate_series`
- Application Flask avec **3 routes** :
  - `GET /sante` - Healthcheck pour HAProxy
  - `GET /resultat?matricule=XXX` - Consultation
  - `GET /info` - Informations serveur
- Reprise automatique si base de données absente
- Script de bascule exécutable et chronométré (R6)

**Tests assignés :**
- V4 - Basculement base de données

**Rotation obligatoire :**
- Écrire la section "Base de données" du dossier
- Tester `lb.sh` (Membre A)

**Estimation :** ~35h (charge la plus forte)

---

### 🟡 Membre C - Essais, observabilité et documentation

**Fichiers à créer :**
- [ ] `.env.exemple` - Template des secrets (versionné)
- [ ] Génération automatique de `.env` dans les scripts
- [ ] `tests/test_v1.sh` à `tests/test_v6.sh` - Scripts de validation
- [ ] `tests/test_idempotence.sh` - Test d'idempotence (R2)
- [ ] `README.md` - Guide complet du projet
- [ ] `docs/architecture.md` - Dossier d'architecture (10-15 pages)
- [ ] `docs/journal_de_bord.md` - Journal (1-2 pages)
- [ ] `docs/resultats_tests.md` - Mesures et analyses
- [ ] Extension **E2** - Monitoring (Prometheus + Grafana)

**Responsabilités :**
- Gestion des secrets (`.env` créé automatiquement, pas manuellement)
- Scripts de tests pour V1 à V6
- Test d'idempotence (réexécuter vagrant up sans erreur)
- Campagne de mesures avec outils (Apache Bench, wrk)
- Documentation complète (README + dossier + journal)
- Monitoring et tableaux de bord

**Tests assignés :**
- V3 - Scalabilité (mesures avec NB_APP=2 puis NB_APP=4)
- V5 - Reconstruction complète

**Rotation obligatoire :**
- Écrire la sonde `/sante` côté app.py (avec Membre B)
- Créer le test d'idempotence

**Estimation :** ~28h (moins chargé en S1-S2, plus en S4)

---

## 🔄 Rotation obligatoire

**Chaque membre doit avoir au moins 1 commit significatif hors de son domaine :**

| Membre | Commit hors domaine |
|--------|---------------------|
| **A** | Script de test de charge `ab` (V3) + relecture `replique.sh` |
| **B** | Section "Base de données" du dossier + test de `lb.sh` |
| **C** | Sonde `/sante` dans app.py + test d'idempotence |

---

## 📅 Planning aligné sur les jalons

### Semaine 1 - Fondations
**Objectif :** `vagrant up` fonctionne chez les 3

- [ ] Confirmer le sous-réseau avec l'enseignant
- [ ] Dépôt Git créé avec `.gitattributes`, `.gitignore`, `.env.exemple`
- [ ] README minimal
- [ ] Vagrantfile avec les 5 VMs (sans provisionnement)
- [ ] `config/noeuds.yml` généré automatiquement
- [ ] Les VMs démarrent

**Jalon J1 (fin S1) :** `vagrant up` fonctionne sur les 3 postes

---

### Semaine 2 - Application et répartition
**Objectif :** V1 et V2 passent

- [ ] `app.sh` + `app.py` avec les 3 routes
- [ ] HAProxy généré depuis `noeuds.yml`
- [ ] Route `/sante` effective
- [ ] Paramètre `NB_APP` fonctionnel
- [ ] Tests V1 (répartition) et V2 (résilience)

**Jalon J2 (fin S2) :** V1 et V2 passent

**Test hebdomadaire :** Chacun fait `vagrant destroy -f && vagrant up` sur le poste d'un autre membre

---

### Semaine 3 - Réplication et extensions
**Objectif :** V4 passe

- [ ] Réplication PostgreSQL en flux
- [ ] Script de bascule chronométré
- [ ] Extension E1 (lb2 avec keepalived)
- [ ] Extension E2 (Prometheus + Grafana)
- [ ] Test V4 (basculement base)

**Jalon J3 (fin S3) :** V4 passe

**Test hebdomadaire :** `vagrant destroy -f && vagrant up` sur un autre poste

---

### Semaine 4 - Mesures et documentation
**Objectif :** Rendu et soutenance

- [ ] Campagne de mesures V3 et V5
- [ ] Dossier d'architecture (10-15 pages)
- [ ] Journal de bord (1-2 pages)
- [ ] README complet
- [ ] Répétition de la démo
- [ ] Test sur machine vierge

**Test hebdomadaire :** `vagrant destroy -f && vagrant up` sur un autre poste

---

## 🎯 Extensions à implémenter (minimum 2)

**Répartition décidée :**
- [ ] **E1** - Load balancer de secours (lb2) avec Keepalived → **Membre A**
- [ ] **E2** - Monitoring (Prometheus + Grafana) → **Membre C**

**Extensions disponibles :**
- **E1** - lb2 avec keepalived (VIP, bascule automatique)
- **E2** - Monitoring Prometheus + Grafana + Node Exporter
- **E3** - Cache Redis pour améliorer performances
- **E4** - Déploiement sans interruption (rolling update, serveur par serveur)

---

## 📊 Critères d'évaluation (rappel)

| Critère | Points | Responsable principal |
|---------|--------|-----------------------|
| Reconstruction (`vagrant up`) | 4 | Membre A |
| Scalabilité (NB_APP) | 3 | Membre A + C (tests) |
| Résilience (pannes) | 4 | Membre B + A (tests) |
| Qualité technique | 2 | TOUS |
| Extensions (min 2) | 2 | Membres A + C |
| Dossier + mesures | 3 | Membre C + TOUS |
| Démonstration | 2 | TOUS |
| **TOTAL** | **20** | |

---

## 🔄 Workflow Git

**Branches :**
```bash
main                        # Code validé uniquement (protégé)
├── feature/infrastructure  # Membre A
├── feature/database        # Membre B
└── feature/tests           # Membre C
```

**Règles :**
1. **Jamais de commit direct sur `main`**
2. Une branche par fonctionnalité
3. Commits réguliers avec messages clairs
4. Pull Request validée par **1 autre membre** (pas besoin de 2)
5. Merge après validation

**Premier commit (important) :**
```bash
git init
git add .gitattributes .gitignore .env.exemple README.md
git commit -m "feat: initial project structure"
```

**Exemples de messages de commit :**
```
✅ feat: add Vagrantfile with 5 VMs and noeuds.yml generation
✅ feat: configure HAProxy with /sante probe
✅ feat: implement PostgreSQL streaming replication
✅ fix: correct database connection timeout
✅ docs: add architecture diagrams
✅ test: add V3 scalability test with ab
```

---

## 📞 Communication

**Outils suggérés :**
- Discord/WhatsApp/Telegram : Communication quotidienne
- Trello/Notion/GitHub Projects : Suivi des tâches
- Git : Code et révisions
- Google Meet/Zoom : Réunions hebdomadaires

**Réunions prévues :**
- Semaine 1 : Kick-off et confirmation du sous-réseau
- Semaine 2 : Point d'avancement (J2)
- Semaine 3 : Tests d'intégration (J3)
- Semaine 4 : Répétition de la démo

**Test hebdomadaire obligatoire :**
Chaque semaine, un membre fait `vagrant destroy -f && vagrant up` sur le poste d'un autre membre.

---

## ⚠️ Points d'attention (CORRIGÉS)

**Pénalités selon le sujet :**
- ❌ **Mots de passe dans Git** → **-2 points** (pas 0/20)
- ❌ **`vagrant up` échoue sur machine vierge** → Note plafonnée à 8/20
- ❌ **IPs en dur dans HAProxy** (violation R3) → Pénalité
- ❌ **Besoin de copier `.env` manuellement** → Note plafonnée à 8/20

**Contraintes techniques :**
- ✅ Sous-réseau : **À CONFIRMER avec l'enseignant** (192.168.56.x à 192.168.63.x)
- ✅ Mémoire totale : **3 Go maximum** (512+512+512+768+768 = 3072 Mo)
- ✅ Base de données : **PostgreSQL** (pas MySQL)
- ✅ Port : **5432** (PostgreSQL)
- ✅ Routes : **/sante**, **/resultat**, **/info** (pas /health)
- ✅ `.env` créé **automatiquement** par les scripts (pas manuellement)

**Succès garantis :**
- ✅ Tester `vagrant destroy -f && vagrant up` chaque semaine sur un autre poste
- ✅ Faire des commits atomiques et clairs
- ✅ Documenter au fur et à mesure
- ✅ S'entraider et communiquer
- ✅ Mesures réelles et honnêtes

---

##  Checklist de conformité au sujet

**Avant le rendu, vérifier :**

### Infrastructure (R1-R3)
- [ ] Vagrantfile utilise `bento/ubuntu-24.04` version `202404.23.0`
- [ ] 5 VMs avec IPs confirmées avec l'enseignant
- [ ] Port 8080 exposé UNIQUEMENT sur lb1
- [ ] Mémoire totale = 3072 Mo (512+512+512+768+768)
- [ ] `config/noeuds.yml` généré automatiquement (pas versionné)
- [ ] HAProxy configuré depuis `noeuds.yml` (pas d'IPs en dur)
- [ ] `NB_APP` paramétrable et fonctionnel
- [ ] `.gitattributes` présent dès le premier commit

### Sécurité
- [ ] `.env` dans `.gitignore`
- [ ] `.env.exemple` versionné
- [ ] Aucun mot de passe dans Git
- [ ] `.env` créé automatiquement par les scripts (pas de copie manuelle)
- [ ] `vagrant up` fonctionne sans geste manuel

### Base de données
- [ ] **PostgreSQL** (pas MySQL)
- [ ] Port **5432** (pas 3306)
- [ ] Réplication en flux (streaming replication)
- [ ] 50 000 candidats générés avec `generate_series`
- [ ] Script de bascule exécutable et chronométré

### Application
- [ ] Route `/sante` pour HAProxy (pas `/health`)
- [ ] Route `/resultat?matricule=XXX`
- [ ] Route `/info` - Informations serveur
- [ ] Retour JSON uniquement (pas de HTML)
- [ ] Application < 100 lignes
- [ ] Reprise automatique si base absente

### Tests et mesures
- [ ] V1 - Répartition de charge mesurée
- [ ] V2 - Résilience aux pannes testée
- [ ] V3 - Scalabilité mesurée (NB_APP=2 vs NB_APP=4)
- [ ] V4 - Basculement base de données testé
- [ ] V5 - Reconstruction complète validée
- [ ] V6 - Load balancer de secours (E1)
- [ ] Test d'idempotence (R2)
- [ ] Mesures réelles (pas inventées)

### Extensions (minimum 2)
- [ ] Extension E1 implémentée (Membre A)
- [ ] Extension E2 implémentée (Membre C)
- [ ] Extensions documentées

### Documentation
- [ ] Dossier d'architecture (10-15 pages)
- [ ] Journal de bord (1-2 pages)
- [ ] Résultats de tests avec mesures
- [ ] README complet (livrable à part entière)

### Rotation obligatoire
- [ ] Membre A : commit hors de son domaine
- [ ] Membre B : commit hors de son domaine
- [ ] Membre C : commit hors de son domaine

### Tests hebdomadaires
- [ ] S1 : `vagrant destroy -f && vagrant up` sur un autre poste
- [ ] S2 : `vagrant destroy -f && vagrant up` sur un autre poste
- [ ] S3 : `vagrant destroy -f && vagrant up` sur un autre poste
- [ ] S4 : `vagrant destroy -f && vagrant up` sur un autre poste

---

## 🎓 Livrables finaux

**À rendre :**
1. **Dépôt Git** avec tout le code
2. **Dossier d'architecture** (PDF, 10-15 pages)
3. **Journal de bord** (PDF, 1-2 pages)
4. **README** complet
5. **Démonstration** (20 min en direct)

**Format de la démo (20 min) :**
1. **Présentation architecture** (3 min)
2. **`vagrant destroy -f` puis `vagrant up` en direct** (5-10 min, pendant lesquelles on explique)
3. **Trois scénarios tirés au sort** par l'enseignant (parmi V1 à V6)
4. **Questions** : N'importe quel membre peut être interrogé → chacun doit tout savoir démontrer !

---

## 📝 Notes

_Ce fichier doit être mis à jour au fur et à mesure du projet._

**Dernière mise à jour :** _[Date]_  
**Statut global :** 🟡 En cours  
**Sous-réseau confirmé :** _À compléter après confirmation avec l'enseignant_
