# Application Flask - RÉSULTATS-BF

## Objectif
Application web simple (<100 lignes) pour consulter les résultats d'examens.

## À créer

### Fichier: `app.py`

**Endpoints requis:**
- `GET /sante` - Healthcheck pour HAProxy (**pas /health**)
- `GET /resultat?matricule=XXXXX` - Consultation résultat
- `GET /info` - Informations sur le serveur

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
- psycopg2 (ou psycopg2-binary) - **PostgreSQL, pas MySQL**

## Configuration
- Les credentials sont dans `.env` (créé automatiquement par les scripts)
- L'application doit reprendre automatiquement si la base est absente
- Port PostgreSQL : **5432**
