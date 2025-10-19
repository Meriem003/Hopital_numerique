-- Migration pour ajouter la relation entre Salle et Departement
-- Date: 2025-10-16
-- IMPORTANT: Une salle DOIT toujours appartenir à un département

-- Ajouter la colonne departement_id si elle n'existe pas
-- ATTENTION: La colonne est NOT NULL car une salle doit toujours avoir un département
ALTER TABLE salles 
ADD COLUMN IF NOT EXISTS departement_id BIGINT NOT NULL;

-- Ajouter la contrainte de clé étrangère
ALTER TABLE salles 
ADD CONSTRAINT IF NOT EXISTS fk_salle_departement 
FOREIGN KEY (departement_id) 
REFERENCES departements(id) 
ON DELETE RESTRICT;  -- Empêche la suppression d'un département qui a des salles

-- Créer un index sur departement_id pour améliorer les performances
CREATE INDEX IF NOT EXISTS idx_salle_departement 
ON salles(departement_id);

-- Note: Si vous avez déjà des salles sans département, 
-- vous devez d'abord les associer à un département avant d'exécuter cette migration.
-- Exemple:
-- UPDATE salles SET departement_id = 1 WHERE departement_id IS NULL;
