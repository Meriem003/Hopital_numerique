<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Clinique Excellence - Plateforme de gestion médicale premium avec consultation en ligne, dossiers patients et planning intelligent">
    <meta name="keywords" content="clinique, médecin, consultation, santé, soins médicaux">
    <meta name="author" content="Clinique Excellence">
    <title>Clinique Excellence - Gestion Médicale Premium</title>
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/home.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar" id="navbar">
        <div class="nav-container">
            <div class="logo-container">
                <div class="logo-icon">
                    <i class="fas fa-hospital-symbol"></i>
                </div>
                <div class="logo-text">
                    <div class="logo-title">Clinique Excellence</div>
                    <div class="logo-subtitle">Medical Platform</div>
                </div>
            </div>
            <ul class="nav-menu">
                <li><a href="#accueil">Accueil</a></li>
                <li><a href="#services">Services</a></li>
                <li><a href="#profils">Profils</a></li>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li>
                            <a href="${pageContext.request.contextPath}/${sessionScope.role.toLowerCase()}/dashboard" class="btn-login btn-dashboard">
                                <i class="fas fa-tachometer-alt"></i>
                                <span>Mon Dashboard</span>
                            </a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li>
                            <a href="${pageContext.request.contextPath}/login" class="btn-login btn-primary-nav">
                                <i class="fas fa-user-circle"></i>
                                <span>Connexion</span>
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero" id="accueil">
        <div class="hero-container">
            <div class="hero-content">
                <h1 class="hero-title">
                    La <span class="gradient-text">Digitalisation</span> au Service de Votre Santé
                </h1>
                <div class="hero-buttons">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/${sessionScope.role.toLowerCase()}/dashboard" class="btn btn-primary">
                                <i class="fas fa-tachometer-alt"></i>
                                Mon Tableau de Bord
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">
                                <i class="fas fa-user-plus"></i>
                                Commencer Maintenant
                            </a>
                            <a href="#services" class="btn btn-outline">
                                <i class="fas fa-play-circle"></i>
                                Découvrir Plus
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="hero-stats">
                    <div class="stat">
                        <div class="stat-number">99.9%</div>
                        <div class="stat-label">Disponibilité</div>
                    </div>
                    <div class="stat">
                        <div class="stat-number">24/7</div>
                        <div class="stat-label">Support</div>
                    </div>
                    <div class="stat">
                        <div class="stat-number">100%</div>
                        <div class="stat-label">Sécurisé</div>
                    </div>
                </div>
            </div>
            
            <div class="hero-visual">
                <div class="floating-element float-1"></div>
                <div class="floating-element float-2"></div>
                <div class="dashboard-mockup">
                    <div class="mockup-header">
                        <div class="mockup-dot"></div>
                        <div class="mockup-dot"></div>
                        <div class="mockup-dot"></div>
                    </div>
                    <div class="mockup-content">
                        <div class="mockup-card">
                            <div class="mockup-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="mockup-info">
                                <h4>Consultations Actives</h4>
                                <p>Gestion en temps réel</p>
                            </div>
                        </div>
                        <div class="mockup-card">
                            <div class="mockup-icon">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <div class="mockup-info">
                                <h4>Équipe Médicale</h4>
                                <p>Planning optimisé</p>
                            </div>
                        </div>
                        <div class="mockup-card">
                            <div class="mockup-icon">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <div class="mockup-info">
                                <h4>Statistiques Live</h4>
                                <p>Tableau de bord analytique</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Services Section -->
    <section class="services" id="services">
        <div class="section-header">
            <span class="section-label">Nos Services</span>
            <h2 class="section-title">Fonctionnalités Premium</h2>
            <p class="section-description">
                Une suite complète d'outils professionnels pour une gestion médicale moderne et efficace
            </p>
        </div>
        <div class="services-grid">
            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-calendar-alt"></i>
                </div>
                <h3>Gestion Intelligente</h3>
                <p>Système de réservation automatisé avec créneaux de 30 minutes et vérification de disponibilité en temps réel pour une efficacité maximale.</p>
                <a href="#" class="service-link">
                    En savoir plus <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-chart-pie"></i>
                </div>
                <h3>Analytics & Rapports</h3>
                <p>Tableaux de bord interactifs avec statistiques en temps réel, KPIs et rapports détaillés pour une meilleure prise de décision.</p>
                <a href="#" class="service-link">
                    En savoir plus <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <h3>Sécurité Maximale</h3>
                <p>Protection des données médicales conforme aux normes avec chiffrement, authentification sécurisée et gestion granulaire des droits.</p>
                <a href="#" class="service-link">
                    En savoir plus <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-user-md"></i>
                </div>
                <h3>Espace Docteurs</h3>
                <p>Interface professionnelle dédiée avec planning personnalisé, validation des consultations et accès complet aux dossiers médicaux.</p>
                <a href="#" class="service-link">
                    En savoir plus <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-folder-open"></i>
                </div>
                <h3>Dossiers Digitaux</h3>
                <p>Archivage électronique sécurisé avec historique complet des consultations, diagnostics et traitements accessibles instantanément.</p>
                <a href="#" class="service-link">
                    En savoir plus <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-door-open"></i>
                </div>
                <h3>Optimisation des Salles</h3>
                <p>Gestion intelligente des espaces avec allocation automatique et optimisation de l'occupation pour maximiser la productivité.</p>
                <a href="#" class="service-link">
                    En savoir plus <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>
    </section>

    <!-- Profiles Section -->
    <section class="profiles" id="profils">
        <div class="section-header">
            <span class="section-label">Nos Départements</span>
            <h2 class="section-title">Une Interface Pour Chacun</h2>
            <p class="section-description">
                Des espaces dédiés pour chaque service médical, adaptés à vos besoins spécifiques
            </p>
        </div>
        <div class="profiles-grid">
            <div class="profile-card">
                <div class="profile-icon">
                    <i class="fas fa-ambulance"></i>
                </div>
                <h3>Service des urgences</h3>
                <p class="subtitle">Prise en charge immédiate</p>
                <ul class="profile-features">
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Accueil 24h/24 et 7j/7
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Équipe médicale d'urgence
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Soins immédiats et stabilisation
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Équipements de réanimation
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Transfert vers services spécialisés
                    </li>
                </ul>
                <a href="${pageContext.request.contextPath}/login" class="btn-profile">
                    <i class="fas fa-sign-in-alt"></i> Accéder
                </a>
            </div>
            <div class="profile-card">
                <div class="profile-icon">
                    <i class="fas fa-stethoscope"></i>
                </div>
                <h3>Service de médecine générale</h3>
                <p class="subtitle">Consultations courantes et suivi</p>
                <ul class="profile-features">
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Consultations médicales générales
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Suivi régulier des patients
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Examens de routine
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Prévention et dépistage
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Orientation vers spécialistes
                    </li>
                </ul>
                <a href="${pageContext.request.contextPath}/login" class="btn-profile">
                    <i class="fas fa-sign-in-alt"></i> Accéder
                </a>
            </div>
            <div class="profile-card">
                <div class="profile-icon">
                    <i class="fas fa-brain"></i>
                </div>
                <h3>Service de neurologie</h3>
                <p class="subtitle">Spécialiste du système nerveux</p>
                <ul class="profile-features">
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Diagnostic des maladies neurologiques
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Traitement cerveau et nerfs
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Soins de la moelle épinière
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Examens neurologiques avancés
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Suivi personnalisé des pathologies
                    </li>
                </ul>
                <a href="${pageContext.request.contextPath}/login" class="btn-profile">
                    <i class="fas fa-sign-in-alt"></i> Accéder
                </a>
            </div>
        </div>
    </section>

    <!-- Footer Minimal -->
    <footer>
        <div class="footer-wave">
            <svg viewBox="0 0 1200 120" preserveAspectRatio="none">
                <path d="M0,0V46.29c47.79,22.2,103.59,32.17,158,28,70.36-5.37,136.33-33.31,206.8-37.5C438.64,32.43,512.34,53.67,583,72.05c69.27,18,138.3,24.88,209.4,13.08,36.15-6,69.85-17.84,104.45-29.34C989.49,25,1113-14.29,1200,52.47V0Z" opacity=".25"></path>
                <path d="M0,0V15.81C13,36.92,27.64,56.86,47.69,72.05,99.41,111.27,165,111,224.58,91.58c31.15-10.15,60.09-26.07,89.67-39.8,40.92-19,84.73-46,130.83-49.67,36.26-2.85,70.9,9.42,98.6,31.56,31.77,25.39,62.32,62,103.63,73,40.44,10.79,81.35-6.69,119.13-24.28s75.16-39,116.92-43.05c59.73-5.85,113.28,22.88,168.9,38.84,30.2,8.66,59,6.17,87.09-7.5,22.43-10.89,48-26.93,60.65-49.24V0Z" opacity=".5"></path>
                <path d="M0,0V5.63C149.93,59,314.09,71.32,475.83,42.57c43-7.64,84.23-20.12,127.61-26.46,59-8.63,112.48,12.24,165.56,35.4C827.93,77.22,886,95.24,951.2,90c86.53-7,172.46-45.71,248.8-84.81V0Z"></path>
            </svg>
        </div>
        
        <div class="footer-content">
            <div class="footer-brand">
                <div class="footer-logo">
                    <div class="footer-logo-container">
                        <div class="footer-logo-icon">
                            <i class="fas fa-hospital-symbol"></i>
                        </div>
                        <div class="footer-logo-text">
                            <div class="footer-logo-title">Clinique Excellence</div>
                            <div class="footer-logo-subtitle">Medical Platform</div>
                        </div>
                    </div>
                </div>
                <p class="footer-description">
                    Plateforme médicale digitale de nouvelle génération offrant des solutions innovantes pour la gestion des consultations, 
                    dossiers patients et planification médicale. Votre santé, notre priorité.
                </p>

                <div class="social-links">
                    <a href="#" class="social-link" title="Facebook" aria-label="Facebook">
                        <i class="fab fa-facebook-f"></i>
                    </a>
                    <a href="#" class="social-link" title="LinkedIn" aria-label="LinkedIn">
                        <i class="fab fa-linkedin-in"></i>
                    </a>

                    <a href="#" class="social-link" title="Twitter" aria-label="Twitter">
                        <i class="fab fa-twitter"></i>
                    </a>
                </div>
            </div>
            
            <div class="footer-section">
                <h4><i class="fas fa-hospital"></i> Nos Départements</h4>
                <ul class="footer-links">
                    <li><a href="#profils"><i class="fas fa-ambulance"></i> Service des Urgences</a></li>
                    <li><a href="#profils"><i class="fas fa-stethoscope"></i> Médecine Générale</a></li>
                    <li><a href="#profils"><i class="fas fa-brain"></i> Neurologie</a></li>
                    <li><a href="#services"><i class="fas fa-heartbeat"></i> Cardiologie</a></li>
                    <li><a href="#services"><i class="fas fa-user-md"></i> Pédiatrie</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h4><i class="fas fa-link"></i> Liens Rapides</h4>
                <ul class="footer-links">
                    <li><a href="#accueil"><i class="fas fa-home"></i> Accueil</a></li>
                    <li><a href="#services"><i class="fas fa-concierge-bell"></i> Services</a></li>
                    <li><a href="#profils"><i class="fas fa-users"></i> Nos Équipes</a></li>
                    <li><a href="${pageContext.request.contextPath}/login"><i class="fas fa-sign-in-alt"></i> Connexion</a></li>
                    <li><a href="${pageContext.request.contextPath}/register"><i class="fas fa-user-plus"></i> Inscription</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h4><i class="fas fa-info-circle"></i> Informations</h4>
                <ul class="footer-links footer-contact">
                    <li>
                        <i class="fas fa-map-marker-alt"></i>
                        <div>
                            <strong>Adresse</strong>
                            <span>Avenue Hassan II, Fès 30000, Maroc</span>
                        </div>
                    </li>
                    <li>
                        <i class="fas fa-phone-alt"></i>
                        <div>
                            <strong>Téléphone</strong>
                            <span>+212 535-XX-XX-XX</span>
                        </div>
                    </li>
                    <li>
                        <i class="fas fa-envelope"></i>
                        <div>
                            <strong>Email</strong>
                            <span>contact@clinique-excellence.ma</span>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
        
        <div class="footer-bottom">
            <div class="footer-bottom-content">
                <p class="footer-copyright">
                    <i class="fas fa-copyright"></i> 2025 <strong>Clinique Excellence</strong>. Tous droits réservés.
                </p>
                <div class="footer-legal">
                    <a href="#"><i class="fas fa-shield-alt"></i> Confidentialité</a>
                    <a href="#"><i class="fas fa-file-contract"></i> Conditions d'utilisation</a>
                    <a href="#"><i class="fas fa-cookie-bite"></i> Politique de Cookies</a>
                    <a href="#"><i class="fas fa-universal-access"></i> Accessibilité</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Custom JavaScript -->
    <script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
</body>
</html>
