# Structure des Services - Clinique Numérique

## 📋 Vue d'ensemble

Ce document décrit l'organisation des interfaces et implémentations de service pour l'application de gestion de clinique.

## 📁 Structure des dossiers

```
src/main/java/com/clinic/clinicapp/service/
├── AdminService.java               (Interface)
├── AuthService.java                (Interface - Existante)
├── ConsultationService.java        (Interface)
├── DocteurService.java             (Interface)
├── PatientService.java             (Interface)
└── impl/
    ├── AdminServiceImpl.java       (Implémentation)
    ├── AuthServiceImpl.java        (Implémentation - Existante)
    ├── ConsultationServiceImpl.java (Implémentation)
    ├── DocteurServiceImpl.java     (Implémentation)
    └── PatientServiceImpl.java     (Implémentation)
```

---

## 🩺 1. PatientService

### Fonctionnalités principales
- ✅ Créer et gérer leur compte patient
- ✅ Consulter la liste des docteurs disponibles par département
- ✅ Réserver un rendez-vous avec un docteur
- ✅ Annuler ou modifier une réservation
- ✅ Consulter l'historique de leurs consultations et diagnostics

### Méthodes principales
```java
// Gestion du compte
- creerComptePatient(Patient patient)
- mettreAJourPatient(Patient patient)
- getPatientById(Long patientId)
- getPatientByEmail(String email)

// Consultation des docteurs
- consulterTousLesDocteurs()
- consulterDocteursByDepartement(Long departementId)
- consulterDocteursBySpecialite(String specialite)

// Gestion des réservations
- reserverRendezVous(Long patientId, Long docteurId, LocalDateTime dateHeure, String motif)
- annulerReservation(Long consultationId)
- modifierReservation(Long consultationId, LocalDateTime nouvelleDate, String nouveauMotif)

// Historique
- consulterHistoriqueConsultations(Long patientId)
- consulterConsultationsAVenir(Long patientId)
- consulterConsultationsPassees(Long patientId)
```

---

## 👨‍⚕️ 2. DocteurService

### Fonctionnalités principales
- ✅ Consulter leur planning de consultations
- ✅ Valider ou refuser une réservation faite par un patient
- ✅ Réaliser une consultation : saisir le compte rendu médical
- ✅ Mettre à jour l'état d'une consultation
- ✅ Accéder à l'historique médical des patients qu'ils suivent

### Méthodes principales
```java
// Gestion du compte
- creerCompteDocteur(Docteur docteur)
- mettreAJourDocteur(Docteur docteur)
- getDocteurById(Long docteurId)
- getDocteurByEmail(String email)

// Planning
- consulterPlanning(Long docteurId)
- consulterConsultationsAVenir(Long docteurId)
- consulterConsultationsDuJour(Long docteurId, LocalDateTime date)
- consulterReservationsEnAttente(Long docteurId)

// Gestion des réservations
- validerReservation(Long consultationId)
- refuserReservation(Long consultationId, String motifRefus)

// Réalisation de consultation
- realiserConsultation(Long consultationId, String compteRendu, String diagnostic, String traitement)
- mettreAJourStatutConsultation(Long consultationId, StatusConsultation nouveauStatut)
- terminerConsultation(Long consultationId)

// Suivi des patients
- consulterHistoriqueMedicalPatient(Long docteurId, Long patientId)
- consulterPatientssSuivis(Long docteurId)
```

---

## 🏥 3. AdminService

### Fonctionnalités principales
- ✅ Gérer les départements (ajout, modification, suppression)
- ✅ Gérer les docteurs et leur rattachement aux départements
- ✅ Gérer les salles et optimiser l'occupation par créneaux
- ✅ Superviser toutes les réservations et consultations
- ✅ Générer des statistiques globales

### Méthodes principales

#### Gestion des Départements
```java
- creerDepartement(Departement departement)
- modifierDepartement(Departement departement)
- supprimerDepartement(Long departementId)
- listerTousLesDepartements()
- rechercherDepartementsByNom(String nom)
```

#### Gestion des Docteurs
```java
- creerDocteur(Docteur docteur)
- modifierDocteur(Docteur docteur)
- supprimerDocteur(Long docteurId)
- rattacherDocteurADepartement(Long docteurId, Long departementId)
- listerTousLesDocteurs()
- listerDocteursByDepartement(Long departementId)
```

#### Gestion des Salles
```java
- creerSalle(Salle salle)
- modifierSalle(Salle salle)
- supprimerSalle(Long salleId)
- verifierDisponibiliteSalle(Long salleId, LocalDateTime dateHeure)
- trouverSalleDisponible(LocalDateTime dateHeure)
- consulterOccupationSalle(Long salleId, LocalDateTime dateDebut, LocalDateTime dateFin)
- optimiserOccupationSalles(LocalDateTime dateDebut, LocalDateTime dateFin)
```

#### Supervision des Consultations
```java
- superviserToutesLesConsultations()
- consulterConsultationsByStatut(String statut)
- consulterConsultationsByPeriode(LocalDateTime dateDebut, LocalDateTime dateFin)
- consulterConsultationsByPatient(Long patientId)
- consulterConsultationsByDocteur(Long docteurId)
- annulerConsultation(Long consultationId, String motifAnnulation)
```

#### Statistiques
```java
- obtenirNombreTotalPatients()
- obtenirNombreTotalDocteurs()
- obtenirNombreTotalConsultations()
- obtenirNombreConsultationsByStatut()
- calculerTauxOccupationGlobalSalles(LocalDateTime dateDebut, LocalDateTime dateFin)
- obtenirConsultationsByDepartement(LocalDateTime dateDebut, LocalDateTime dateFin)
- obtenirDocteursPlusConsultes(int limite, LocalDateTime dateDebut, LocalDateTime dateFin)
- genererRapportStatistique(LocalDateTime dateDebut, LocalDateTime dateFin)
```

---

## 📅 4. ConsultationService

### Fonctionnalités principales
Service partagé pour la gestion centralisée des consultations, utilisé par Patient, Docteur et Admin.

### Méthodes principales
```java
// CRUD de base
- creerConsultation(Consultation consultation)
- mettreAJourConsultation(Consultation consultation)
- getConsultationById(Long consultationId)
- supprimerConsultation(Long consultationId)

// Recherche et filtrage
- listerToutesLesConsultations()
- getConsultationsByPatient(Long patientId)
- getConsultationsByDocteur(Long docteurId)
- getConsultationsBySalle(Long salleId)
- getConsultationsByStatut(StatusConsultation statut)
- getConsultationsByPeriode(LocalDateTime dateDebut, LocalDateTime dateFin)

// Gestion des créneaux
- existeConsultationPourCreneau(LocalDateTime dateHeure, Long salleId)
- verifierDisponibiliteCreneau(Long docteurId, LocalDateTime dateHeure)
- trouverSalleDisponible(LocalDateTime dateHeure)
- calculerFinCreneau(LocalDateTime dateHeureDebut)
- creneauxSeChevauchent(LocalDateTime debut1, LocalDateTime debut2)

// Gestion du compte rendu
- changerStatut(Long consultationId, StatusConsultation nouveauStatut)
- ajouterCompteRendu(Long consultationId, String compteRendu, String diagnostic, String traitement)

// Validation
- validerConsultation(Consultation consultation)
- compterConsultationsByStatut(StatusConsultation statut)
```

---

## 🔄 Règles de gestion implémentées

### 1. Réservation de créneau
- Un patient peut avoir plusieurs consultations, mais **une seule réservation par créneau**
- Chaque consultation bloque automatiquement un **créneau de 30 minutes** dans une salle
- Une salle peut accueillir **une seule consultation par créneau de 30 minutes**

### 2. Statuts de consultation
Les consultations suivent un cycle de vie défini par des statuts :
- **RESERVEE** : Réservation initiale par le patient
- **VALIDEE** : Validation par le docteur
- **TERMINEE** : Consultation effectuée avec compte rendu
- **ANNULEE** : Annulation (par patient, docteur ou admin)

### 3. Docteur et département
- Un docteur appartient à **un seul département**
- Un docteur peut avoir **plusieurs consultations**
- Les patients peuvent consulter les docteurs par département

### 4. Historique
- Les consultations passées restent **accessibles dans l'historique**
- Les patients peuvent consulter leurs diagnostics
- Les docteurs peuvent accéder à l'historique médical de leurs patients

---

## 🛠️ Prochaines étapes

### Pour implémenter ces services :

1. **Créer les Repository** (couche d'accès aux données)
   - PatientRepository
   - DocteurRepository
   - ConsultationRepository
   - DepartementRepository
   - SalleRepository

2. **Implémenter les méthodes dans les ServiceImpl**
   - Injection des repositories
   - Logique métier
   - Gestion des exceptions
   - Transactions

3. **Créer les Servlets/Controllers**
   - PatientController
   - DocteurController
   - AdminController

4. **Développer les vues JSP**
   - Utiliser JSTL pour l'affichage
   - Formulaires de réservation
   - Tableaux de bord

5. **Implémenter la sécurité**
   - Filtres d'authentification
   - Gestion des sessions
   - Contrôle d'accès par rôle

---

## 📝 Notes importantes

- ✅ Toutes les interfaces sont créées avec des méthodes documentées
- ✅ Toutes les implémentations sont créées avec des méthodes vides (TODO)
- ✅ La structure respecte l'architecture en couches (MVC)
- ✅ Les commentaires indiquent clairement les fonctionnalités à implémenter
- ✅ Les types de retour et paramètres correspondent aux besoins du brief

---

## 📚 Ressources

- **Entités** : `com.clinic.clinicapp.entity`
- **Enums** : `com.clinic.clinicapp.enums`
- **Services** : `com.clinic.clinicapp.service`
- **Implémentations** : `com.clinic.clinicapp.service.impl`

---

**Date de création** : Octobre 2025  
**Version** : 1.0  
**Statut** : Structure créée - Prêt pour l'implémentation
