# Tests et validation

Scripts pour valider les exigences du projet (V1 à V6).

## Tests à implémenter

### V1 - Répartition de charge
**Fichier:** `test_load_distribution.sh`

**Objectif:** Vérifier que les requêtes sont bien réparties entre app1 et app2.

**Méthode:** 
- Faire 100 requêtes
- Compter combien passent par chaque serveur
- Vérifier que la répartition est équilibrée (~50/50)

---

### V2 - Résilience aux pannes
**Fichier:** `test_server_failure.sh`

**Objectif:** Éteindre un serveur et vérifier que le service continue.

**Méthode:**
- Générer du trafic
- Arrêter app1 avec `vagrant halt app1`
- Vérifier que les requêtes continuent (100% vers app2)
- Redémarrer app1

---

### V3 - Scalabilité
**Fichier:** `test_scalability.sh`

**Objectif:** Mesurer l'augmentation du débit avec plus de serveurs.

**Méthode:**
- Mesurer débit avec NB_APP=2 (requêtes/seconde)
- Reconstruire avec NB_APP=4
- Mesurer à nouveau
- Comparer les résultats

**Outil suggéré:** Apache Bench (`ab`) ou `wrk`

---

### V4 - Basculement base de données
**Fichier:** `test_db_failover.sh`

**Objectif:** Vérifier la résilience de la base de données.

**Méthode:**
- Arrêter bdd1 (master)
- Vérifier que le service échoue proprement
- Promouvoir bdd2 en master
- Reconfigurer les app pour utiliser bdd2
- Vérifier que le service reprend

---

### V5 - Reconstruction complète
**Fichier:** `test_full_rebuild.sh`

**Objectif:** `vagrant destroy -f && vagrant up` fonctionne sans intervention.

**Méthode:**
- Détruire toutes les VMs
- Chronométrer la reconstruction
- Vérifier que tout fonctionne

---

### V6 - Load balancer de secours (Extension E1)
**Fichier:** `test_lb_failover.sh`

**Objectif:** Arrêter lb1 et vérifier que lb2 prend le relais.

**Méthode:**
- Configurer lb2 avec Keepalived (VIP)
- Arrêter lb1
- Vérifier que le VIP bascule vers lb2
- Trafic continue sans interruption

---

## Format des résultats

Chaque test doit produire un rapport avec :
- Timestamp
- Commandes exécutées
- Résultats mesurés (chiffres réels !)
- Statut: PASS/FAIL
- Captures d'écran ou logs

**Exemple:**
```
=======================================
Test V1 - Répartition de charge
Date: 2024-11-01 14:30:00
=======================================
Requêtes totales: 100
- app1: 48 requêtes (48%)
- app2: 52 requêtes (52%)

Statut: ✅ PASS
Écart acceptable: < 10%
=======================================
```
