# Scripts SQL

## Fichier à créer: `init_data.sql`

### Objectif
Générer **50 000 candidats** avec leurs résultats d'examens.

### Structure de la table

```sql
CREATE TABLE candidats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    matricule VARCHAR(20) UNIQUE NOT NULL,    -- Format: BF2024XXXXX
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    resultat ENUM('ADMIS', 'REFUSE', 'EN_ATTENTE') NOT NULL,
    moyenne DECIMAL(4,2),                     -- Entre 0.00 et 20.00
    mention VARCHAR(50),                      -- Très Bien, Bien, Assez Bien, Passable
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_matricule (matricule)
);
```

### Répartition suggérée
- 70% ADMIS (moyenne >= 10)
- 25% REFUSE (moyenne < 10)
- 5% EN_ATTENTE (pas encore évalué)

### Noms burkinabè courants
- Noms: TRAORE, OUEDRAOGO, SAWADOGO, KABORE, ZONGO, SANKARA, etc.
- Prénoms: Abdoulaye, Aminata, Ibrahim, Fatimata, Moussa, etc.

### Méthode de génération
Utiliser une procédure stockée MySQL pour générer les données rapidement.

### Performance
- Désactiver temporairement les contraintes pendant l'insertion
- Faire des commits par batch (tous les 1000 enregistrements)
