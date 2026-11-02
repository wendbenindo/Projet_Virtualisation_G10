# Application Flask - RÉSULTATS-BF

## Objectif
Application web simple (<100 lignes) pour consulter les résultats d'examens.

## À créer

### Fichier: `app.py`

**Endpoints requis:**
- `GET /health` - Healthcheck pour HAProxy
- `GET /resultat?matricule=XXXXX` - Consultation résultat

**Retour:** JSON uniquement (pas de templates HTML)

**Exemple de réponse:**
```json
{
  "found": true,
  "candidat": {
    "matricule": "BF202400001",
    "nom": "TRAORE",
    "prenom": "Abdoulaye",
    "resultat": "ADMIS",
    "moyenne": 15.75,
    "mention": "Bien"
  },
  "server": "app1"
}
```

## Dépendances Python
- Flask
- python-dotenv
- mysqlclient

## Configuration
Les credentials de base de données sont dans `.env` (pas dans le code !).
