# 🏥 Hôpital Numérique - Système de Gestion de Clinique

## 📋 Description du Projet

**Hôpital Numérique** est une application web complète de gestion de clinique développée en Java EE. Cette solution permet de gérer efficacement les patients, les médecins, les consultations, les départements et les salles d'une clinique médicale.

## ✨ Fonctionnalités Principales

### 👤 Gestion des Utilisateurs
- **Administrateurs** : Gestion complète du système
- **Docteurs** : Gestion des consultations et suivi des patients
- **Patients** : Prise de rendez-vous et consultation de l'historique médical

### 🏗️ Modules Principaux

#### 📊 Dashboard Admin
- Gestion des patients (CRUD complet)
- Gestion des docteurs (CRUD complet)
- Gestion des départements médicaux
- Gestion des salles de consultation
- Statistiques et aperçu général

#### 👨‍⚕️ Espace Docteur
- Gestion des consultations
- Historique médical des patients
- Planning des rendez-vous
- Création de rapports de consultation

#### 🧑‍🦱 Espace Patient
- Réservation de rendez-vous
- Consultation de l'historique médical
- Liste des médecins disponibles
- Gestion du profil personnel

## 🛠️ Technologies Utilisées

### Backend
- **Java 21** - Langage de programmation
- **Jakarta EE 6.1.0** - Framework web (Servlet, JSP)
- **Hibernate 7.0.4** - ORM (Object-Relational Mapping)
- **JPA** - Persistence API
- **Maven** - Gestion des dépendances

### Frontend
- **JSP (JavaServer Pages)** - Vues dynamiques
- **JSTL 3.0** - Tag library
- **HTML5/CSS3** - Structure et design
- **JavaScript** - Interactivité

### Base de Données
- **MySQL** - Système de gestion de base de données

### Validation & Tests
- **Hibernate Validator 9.0.1** - Validation des données
- **JUnit Jupiter 5.13.2** - Tests unitaires

## 📁 Structure du Projet

```
clinicApp/
├── src/
│   ├── main/
│   │   ├── java/com/clinic/clinicapp/
│   │   │   ├── controller/     # Servlets (contrôleurs)
│   │   │   ├── entity/         # Entités JPA
│   │   │   ├── enums/          # Énumérations
│   │   │   ├── filter/         # Filtres de sécurité
│   │   │   ├── repository/     # Couche d'accès aux données
│   │   │   ├── service/        # Logique métier
│   │   │   └── util/           # Classes utilitaires
│   │   ├── resources/
│   │   │   ├── hibernate.cfg.xml       # Configuration Hibernate
│   │   │   └── META-INF/persistence.xml # Configuration JPA
│   │   └── webapp/
│   │       ├── views/
│   │       │   ├── admin/      # Pages admin
│   │       │   ├── docteur/    # Pages docteur
│   │       │   ├── patient/    # Pages patient
│   │       │   └── auth/       # Pages d'authentification
│   │       ├── assets/         # CSS, JS, Images
│   │       └── WEB-INF/web.xml # Configuration web
│   └── test/                   # Tests unitaires
├── database/                   # Scripts SQL
├── pom.xml                     # Configuration Maven
└── README.md                   # Ce fichier
```

## 🚀 Installation et Configuration

### Prérequis

- **Java JDK 21** ou supérieur
- **Apache Tomcat 10.x** ou serveur Jakarta EE compatible
- **MySQL 8.0** ou supérieur
- **Maven 3.6** ou supérieur

### Étapes d'Installation

#### 1. Cloner le Projet

```bash
git clone https://github.com/Meriem003/Hopital_numerique.git
cd Hopital_numerique
```

#### 2. Configuration de la Base de Données

Créez une base de données MySQL :

```sql
CREATE DATABASE clinique_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Configurez les paramètres de connexion dans `src/main/resources/hibernate.cfg.xml` :

```xml
<property name="hibernate.connection.url">jdbc:mysql://localhost:3306/clinique_db</property>
<property name="hibernate.connection.username">VOTRE_USERNAME</property>
<property name="hibernate.connection.password">VOTRE_PASSWORD</property>
```

#### 3. Exécuter les Migrations

Exécutez les scripts SQL dans l'ordre :

```bash
mysql -u root -p clinique_db < database/migration_salle_departement.sql
mysql -u root -p clinique_db < database/test_data_planning.sql
```

#### 4. Compiler le Projet

```bash
mvn clean install
```

#### 5. Déployer l'Application

**Option A : Déploiement manuel**
- Copiez le fichier `target/clinicApp-1.0-SNAPSHOT.war` dans le dossier `webapps` de Tomcat
- Démarrez Tomcat

**Option B : Via Maven (si configuré)**
```bash
mvn tomcat7:deploy
```

#### 6. Accéder à l'Application

Ouvrez votre navigateur et accédez à :
```
http://localhost:8080/clinicApp-1.0-SNAPSHOT/
```

## 📊 Modèle de Données

### Entités Principales

- **Personne** (classe abstraite)
  - Patient
  - Docteur
  - Admin

- **Département** : Services médicaux (Cardiologie, Pédiatrie, etc.)
- **Salle** : Salles de consultation associées aux départements
- **Consultation** : Rendez-vous entre patients et docteurs

### Relations

- Un **Département** possède plusieurs **Salles** (1:N)
- Un **Docteur** travaille dans un **Département** (N:1)
- Un **Patient** peut avoir plusieurs **Consultations** (1:N)
- Un **Docteur** peut effectuer plusieurs **Consultations** (1:N)
- Une **Consultation** se déroule dans une **Salle** (N:1)

## 🔐 Sécurité

- Filtres de sécurité pour contrôler l'accès aux différentes sections
- Sessions utilisateur sécurisées
- Validation des données côté serveur avec Hibernate Validator
- Protection contre les injections SQL via JPA/Hibernate

## 🎨 Interface Utilisateur

L'application dispose de plusieurs interfaces personnalisées :

- **Page d'accueil** : Présentation de la clinique avec animations médicales
- **Dashboards** : Tableaux de bord spécifiques pour chaque type d'utilisateur
- **Formulaires** : Interfaces intuitives pour la saisie de données
- **Tables** : Affichage et gestion des données avec recherche et filtres

## 🧪 Tests

Exécuter les tests unitaires :

```bash
mvn test
```

## 📝 Scripts SQL Disponibles

- `migration_salle_departement.sql` : Migration pour la relation Salle-Département
- `test_data_planning.sql` : Données de test pour le système de planning

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. Forkez le projet
2. Créez une branche pour votre fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Poussez vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📄 Licence

Ce projet est développé dans un cadre éducatif.

## 👨‍💻 Auteur

**Meriem003**
- GitHub: [@Meriem003](https://github.com/Meriem003)

## 🔧 Résolution de Problèmes

### Problème : Erreur de connexion à la base de données

**Solution** : Vérifiez que :
- MySQL est démarré
- Les identifiants dans `hibernate.cfg.xml` sont corrects
- La base de données `clinique_db` existe

### Problème : Erreur 404 après déploiement

**Solution** : 
- Vérifiez que le fichier WAR est bien déployé dans Tomcat
- Consultez les logs Tomcat pour identifier l'erreur
- Vérifiez l'URL d'accès (doit inclure le nom du contexte)

### Problème : Erreurs de compilation Maven

**Solution** :
```bash
mvn clean
mvn dependency:purge-local-repository
mvn clean install
```

---

## 📚 Documentation Technique

### Configuration Hibernate

Le fichier `hibernate.cfg.xml` configure :
- La connexion à la base de données MySQL
- Le pool de connexions (10 connexions)
- Le mode de mise à jour automatique du schéma (`hbm2ddl.auto=update`)
- L'affichage et le formatage des requêtes SQL
- Le mapping des entités

### Endpoints Principaux (Exemples)

- `/admin/dashboard` - Tableau de bord administrateur
- `/docteur/consultations` - Gestion des consultations
- `/patient/reserver` - Réservation de rendez-vous
- `/auth/register` - Inscription

---

**Note** : Ce projet utilise Jakarta EE 10+ (namespace `jakarta.*`), assurez-vous d'utiliser un serveur d'application compatible (Tomcat 10+, GlassFish 7+, etc.).
