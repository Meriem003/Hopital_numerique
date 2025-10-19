-- Script SQL pour tester le planning docteur
-- Données de test pour les consultations

-- Note: Assurez-vous que vous avez déjà des docteurs, patients et salles dans votre base de données
-- Remplacez les IDs selon vos données existantes

-- Exemple d'insertion de consultations pour la semaine du 14 au 20 octobre 2025
-- Supposons que le docteur_id = 1, et nous avons plusieurs patients

-- Lundi 14 octobre 2025
INSERT INTO consultations (date_heure, statut, motif, patient_id, docteur_id, salle_id, date_creation)
VALUES 
('2025-10-14 09:00:00', 'VALIDEE', 'Contrôle cardiaque', 1, 1, 1, NOW()),
('2025-10-14 10:00:00', 'VALIDEE', 'Consultation de suivi', 2, 1, 1, NOW()),
('2025-10-14 14:00:00', 'TERMINEE', 'Première consultation', 3, 1, 1, NOW());

-- Mardi 15 octobre 2025
INSERT INTO consultations (date_heure, statut, motif, patient_id, docteur_id, salle_id, date_creation)
VALUES 
('2025-10-15 09:30:00', 'RESERVEE', 'Consultation générale', 4, 1, 1, NOW()),
('2025-10-15 11:00:00', 'VALIDEE', 'Suivi post-opératoire', 5, 1, 1, NOW()),
('2025-10-15 15:00:00', 'ANNULEE', 'Consultation annulée', 6, 1, 1, NOW());

-- Mercredi 16 octobre 2025 (Aujourd'hui)
INSERT INTO consultations (date_heure, statut, motif, patient_id, docteur_id, salle_id, date_creation)
VALUES 
('2025-10-16 08:30:00', 'VALIDEE', 'Contrôle de routine', 7, 1, 1, NOW()),
('2025-10-16 10:00:00', 'RESERVEE', 'Première consultation', 8, 1, 1, NOW()),
('2025-10-16 14:30:00', 'RESERVEE', 'Suivi cardiaque', 9, 1, 1, NOW());

-- Jeudi 17 octobre 2025
INSERT INTO consultations (date_heure, statut, motif, patient_id, docteur_id, salle_id, date_creation)
VALUES 
('2025-10-17 09:00:00', 'VALIDEE', 'Consultation de suivi', 10, 1, 1, NOW()),
('2025-10-17 11:00:00', 'RESERVEE', 'Bilan cardiaque', 11, 1, 1, NOW());

-- Vendredi 18 octobre 2025
INSERT INTO consultations (date_heure, statut, motif, patient_id, docteur_id, salle_id, date_creation)
VALUES 
('2025-10-18 08:00:00', 'RESERVEE', 'Urgence', 12, 1, 1, NOW()),
('2025-10-18 10:30:00', 'VALIDEE', 'Consultation générale', 13, 1, 1, NOW());

-- Samedi 19 octobre 2025
INSERT INTO consultations (date_heure, statut, motif, patient_id, docteur_id, salle_id, date_creation)
VALUES 
('2025-10-19 09:00:00', 'VALIDEE', 'Contrôle mensuel', 14, 1, 1, NOW());

-- Dimanche 20 octobre 2025 - Pas de consultation (jour de repos)

-- Consultations pour les semaines suivantes (pour tester la navigation)
-- Semaine du 21 au 27 octobre 2025
INSERT INTO consultations (date_heure, statut, motif, patient_id, docteur_id, salle_id, date_creation)
VALUES 
('2025-10-21 09:00:00', 'RESERVEE', 'Consultation de suivi', 1, 1, 1, NOW()),
('2025-10-22 10:30:00', 'RESERVEE', 'Bilan annuel', 2, 1, 1, NOW()),
('2025-10-23 14:00:00', 'VALIDEE', 'Contrôle post-opératoire', 3, 1, 1, NOW());

-- Semaine précédente (7 au 13 octobre 2025) - pour tester la navigation arrière
INSERT INTO consultations (date_heure, statut, motif, patient_id, docteur_id, salle_id, date_creation)
VALUES 
('2025-10-07 09:00:00', 'TERMINEE', 'Consultation passée 1', 4, 1, 1, NOW()),
('2025-10-08 11:00:00', 'TERMINEE', 'Consultation passée 2', 5, 1, 1, NOW()),
('2025-10-09 15:00:00', 'TERMINEE', 'Consultation passée 3', 6, 1, 1, NOW());

-- Vérification des données insérées
SELECT 
    c.id,
    c.date_heure,
    c.statut,
    c.motif,
    CONCAT(p.nom, ' ', p.prenom) as patient_nom,
    CONCAT(d.nom, ' ', d.prenom) as docteur_nom,
    s.numero as salle_numero
FROM consultations c
JOIN patients p ON c.patient_id = p.id
JOIN docteurs d ON c.docteur_id = d.id
JOIN salles s ON c.salle_id = s.id
WHERE d.id = 1
ORDER BY c.date_heure;

-- Compter les consultations par statut pour cette semaine
SELECT 
    statut,
    COUNT(*) as nombre
FROM consultations
WHERE docteur_id = 1
AND date_heure BETWEEN '2025-10-14 00:00:00' AND '2025-10-20 23:59:59'
GROUP BY statut;
