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
    <link href="${pageContext.request.contextPath}/assets/css/medical-animations.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar" id="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="logo-container">
                <div class="logo-icon">
                    <i class="fas fa-hospital-symbol"></i>
                </div>
                <div class="logo-text">
                    <div class="logo-title">Clinique Excellence</div>
                    <div class="logo-subtitle">Medical Platform</div>
                </div>
            </a>
            
            <button class="mobile-menu-toggle" id="mobileMenuToggle" aria-label="Toggle menu">
                <span class="hamburger-line"></span>
                <span class="hamburger-line"></span>
                <span class="hamburger-line"></span>
            </button>
            
            <ul class="nav-menu" id="navMenu">
                <li><a href="${pageContext.request.contextPath}/" class="nav-link active">
                    <i class="fas fa-home"></i>
                    <span>Accueil</span>
                </a></li>
                <li><a href="#profils" class="nav-link">
                    <i class="fas fa-user-md"></i>
                    <span>Profils</span>
                </a></li>
                <li><a href="${pageContext.request.contextPath}/contact.jsp" class="nav-link">
                    <i class="fas fa-envelope"></i>
                    <span>Contact</span>
                </a></li>
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
                <div class="hero-badge">
                    <i class="fas fa-heartbeat"></i>
                    <span>Plateforme Médicale Certifiée</span>
                </div>
                <h1 class="hero-title">
                    Votre Santé,<br>
                    <span class="gradient-text">Notre Priorité</span>
                </h1>
                <p class="hero-description">
                    Plateforme médicale moderne pour la gestion de vos consultations, 
                    rendez-vous et suivi médical en toute simplicité.
                </p>
                <div class="hero-buttons">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/${sessionScope.role.toLowerCase()}/dashboard" class="btn btn-primary">
                                <i class="fas fa-tachometer-alt"></i>
                                Tableau de Bord
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">
                                <i class="fas fa-calendar-check"></i>
                                Prendre Rendez-vous
                            </a>
                            <a href="#services" class="btn btn-outline">
                                <i class="fas fa-info-circle"></i>
                                En savoir plus
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="hero-stats">
                    <div class="stat">
                        <div class="stat-icon">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-number">150+</div>
                            <div class="stat-label">Médecins</div>
                        </div>
                    </div>
                    <div class="stat">
                        <div class="stat-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-number">25k+</div>
                            <div class="stat-label">Patients</div>
                        </div>
                    </div>
                    <div class="stat">
                        <div class="stat-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-number">24h</div>
                            <div class="stat-label">Disponible</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="hero-visual">
                <div class="floating-element float-1">
                    <i class="fas fa-heartbeat"></i>
                </div>
                <div class="floating-element float-2">
                    <i class="fas fa-stethoscope"></i>
                </div>
                <div class="floating-element float-3">
                    <i class="fas fa-briefcase-medical"></i>
                </div>
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
                                <h4>Rendez-vous</h4>
                                <p>Gestion en temps réel</p>
                            </div>
                        </div>
                        <div class="mockup-card">
                            <div class="mockup-icon">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <div class="mockup-info">
                                <h4>Médecins</h4>
                                <p>150+ spécialistes</p>
                            </div>
                        </div>
                        <div class="mockup-card">
                            <div class="mockup-icon">
                                <i class="fas fa-heartbeat"></i>
                            </div>
                            <div class="mockup-info">
                                <h4>Suivi Santé</h4>
                                <p>Monitoring continu</p>
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
            <span class="section-label">
                <i class="fas fa-heartbeat"></i> Nos Services
            </span>
            <h2 class="section-title">Solutions de Santé Digitale</h2>
            <p class="section-description">
                Des outils modernes pour une gestion médicale efficace et sécurisée
            </p>
        </div>
        <div class="services-grid">
            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <h3>Prise de Rendez-vous</h3>
                <p>Réservation en ligne simplifiée avec vérification automatique de disponibilité et notifications.</p>
                <a href="#" class="service-link">
                    En savoir plus <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-heartbeat"></i>
                </div>
                <h3>Suivi Médical</h3>
                <p>Historique complet de vos consultations et suivi en temps réel de votre santé.</p>
                <a href="#" class="service-link">
                    En savoir plus <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-shield-virus"></i>
                </div>
                <h3>Sécurité Garantie</h3>
                <p>Protection maximale de vos données avec chiffrement et authentification sécurisée.</p>
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
            <h2 class="section-title">Services Médicaux Spécialisés</h2>
            <p class="section-description">
                Des espaces dédiés pour chaque service médical
            </p>
        </div>
        <div class="profiles-grid">
            <div class="profile-card">
                <div class="profile-icon">
                    <i class="fas fa-ambulance"></i>
                </div>
                <h3>Service des Urgences</h3>
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
                        Soins immédiats
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Équipements de réanimation
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
                <h3>Médecine Générale</h3>
                <p class="subtitle">Consultations et suivi</p>
                <ul class="profile-features">
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Consultations générales
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Suivi régulier
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Examens de routine
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Prévention et dépistage
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
                <h3>Neurologie</h3>
                <p class="subtitle">Spécialiste système nerveux</p>
                <ul class="profile-features">
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Diagnostic neurologique
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Traitement spécialisé
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Examens avancés
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        Suivi personnalisé
                    </li>
                </ul>
                <a href="${pageContext.request.contextPath}/login" class="btn-profile">
                    <i class="fas fa-sign-in-alt"></i> Accéder
                </a>
            </div>
        </div>
    </section>

    <!-- Pourquoi Nous Choisir Section -->
    <section class="why-choose-us">
        <div class="container">
            <div class="section-header">
                <span class="section-badge">
                    <i class="fas fa-award"></i> Excellence
                </span>
                <h2 class="section-title">Pourquoi Nous Choisir</h2>
                <p class="section-subtitle">
                    Des services médicaux de qualité avec une technologie moderne
                </p>
            </div>
            <div class="why-grid">
                <div class="why-card">
                    <div class="why-number">01</div>
                    <div class="why-icon">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <h3>Équipe Experte</h3>
                    <p>Médecins qualifiés avec plusieurs années d'expérience dans leurs spécialités.</p>
                </div>
                <div class="why-card">
                    <div class="why-number">02</div>
                    <div class="why-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <h3>Disponibilité 24/7</h3>
                    <p>Service d'urgence disponible 24h/24 pour répondre à vos besoins médicaux.</p>
                </div>
                <div class="why-card">
                    <div class="why-number">03</div>
                    <div class="why-icon">
                        <i class="fas fa-microscope"></i>
                    </div>
                    <h3>Technologie Avancée</h3>
                    <p>Équipements médicaux de dernière génération pour des diagnostics précis.</p>
                </div>
                <div class="why-card">
                    <div class="why-number">04</div>
                    <div class="why-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3>Sécurité Maximale</h3>
                    <p>Protection complète de vos données avec protocoles de sécurité stricts.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Témoignages Section -->
    <section class="testimonials">
        <div class="container">
            <div class="section-header">
                <span class="section-badge">
                    <i class="fas fa-comments"></i> Témoignages
                </span>
                <h2 class="section-title">Ce Que Disent Nos Patients</h2>
                <p class="section-subtitle">
                    Retours d'expérience de nos patients satisfaits
                </p>
            </div>
            <div class="testimonials-grid">
                <div class="testimonial-card">
                    <div class="testimonial-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                    </div>
                    <p class="testimonial-text">
                        "Service exceptionnel et équipe très professionnelle. La plateforme en ligne 
                        facilite grandement la prise de rendez-vous."
                    </p>
                    <div class="testimonial-author">
                        <div class="author-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="author-info">
                            <h4>Sarah L.</h4>
                            <span>Patiente depuis 2023</span>
                        </div>
                    </div>
                </div>
                <div class="testimonial-card">
                    <div class="testimonial-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                    </div>
                    <p class="testimonial-text">
                        "Médecins compétents et à l'écoute. Le suivi médical en ligne est très pratique 
                        pour consulter mon historique."
                    </p>
                    <div class="testimonial-author">
                        <div class="author-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="author-info">
                            <h4>Ahmed M.</h4>
                            <span>Patient depuis 2022</span>
                        </div>
                    </div>
                </div>
                <div class="testimonial-card">
                    <div class="testimonial-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                    </div>
                    <p class="testimonial-text">
                        "Infrastructure moderne et accueil chaleureux. Je recommande vivement cette clinique 
                        pour sa qualité de service."
                    </p>
                    <div class="testimonial-author">
                        <div class="author-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="author-info">
                            <h4>Fatima Z.</h4>
                            <span>Patiente depuis 2024</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- FAQ Section -->
    <section class="faq">
        <div class="container">
            <div class="section-header">
                <span class="section-badge">
                    <i class="fas fa-question-circle"></i> Support
                </span>
                <h2 class="section-title">Questions Fréquentes</h2>
                <p class="section-subtitle">
                    Trouvez rapidement les réponses à vos questions
                </p>
            </div>
            <div class="faq-container">
                <div class="faq-item">
                    <div class="faq-question">
                        <h3>Comment prendre un rendez-vous en ligne ?</h3>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Créez un compte, connectez-vous, puis accédez à l'espace rendez-vous. Sélectionnez 
                        votre médecin, choisissez une date disponible et confirmez votre réservation.</p>
                    </div>
                </div>
                <div class="faq-item">
                    <div class="faq-question">
                        <h3>Mes données médicales sont-elles sécurisées ?</h3>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Absolument. Nous utilisons un chiffrement de niveau bancaire et respectons 
                        strictement les normes de confidentialité médicale pour protéger vos informations.</p>
                    </div>
                </div>
                <div class="faq-item">
                    <div class="faq-question">
                        <h3>Puis-je annuler ou modifier mon rendez-vous ?</h3>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Oui, vous pouvez modifier ou annuler votre rendez-vous jusqu'à 24h avant l'heure 
                        prévue via votre espace patient.</p>
                    </div>
                </div>
                <div class="faq-item">
                    <div class="faq-question">
                        <h3>Comment accéder à mon historique médical ?</h3>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Connectez-vous à votre espace patient et accédez à la section "Historique". 
                        Vous y trouverez toutes vos consultations, prescriptions et résultats d'examens.</p>
                    </div>
                </div>
                <div class="faq-item">
                    <div class="faq-question">
                        <h3>Quels sont les moyens de paiement acceptés ?</h3>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Nous acceptons les paiements en espèces, par carte bancaire, et les règlements 
                        via assurance maladie pour les patients couverts.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta">
        <div class="container">
            <div class="cta-content">
                <div class="cta-text">
                    <h2>Prêt à Prendre Soin de Votre Santé ?</h2>
                    <p>Rejoignez des milliers de patients qui nous font confiance pour leur suivi médical.</p>
                </div>
                <div class="cta-buttons">
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-large">
                        <i class="fas fa-user-plus"></i>
                        Créer un Compte
                    </a>
                    <a href="#services" class="btn btn-outline-light btn-large">
                        <i class="fas fa-phone-alt"></i>
                        Nous Contacter
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="footer-content">
            <div class="footer-brand">
                <div class="footer-logo">
                    <div class="footer-logo-icon">
                        <i class="fas fa-hospital-symbol"></i>
                    </div>
                    <div class="footer-logo-text">
                        <div class="footer-logo-title">Clinique Excellence</div>
                        <div class="footer-logo-subtitle">Plateforme Médicale</div>
                    </div>
                </div>
                <p class="footer-description">
                    Solution moderne pour la gestion médicale et le suivi des patients.
                </p>
                <div class="social-links">
                    <a href="#" class="social-link" aria-label="Facebook">
                        <i class="fab fa-facebook-f"></i>
                    </a>
                    <a href="#" class="social-link" aria-label="LinkedIn">
                        <i class="fab fa-linkedin-in"></i>
                    </a>
                    <a href="#" class="social-link" aria-label="Twitter">
                        <i class="fab fa-twitter"></i>
                    </a>
                </div>
            </div>
            
            <div class="footer-section">
                <h4>Départements</h4>
                <ul class="footer-links">
                    <li><a href="#profils">Urgences</a></li>
                    <li><a href="#profils">Médecine Générale</a></li>
                    <li><a href="#profils">Neurologie</a></li>
                    <li><a href="#services">Cardiologie</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h4>Liens Rapides</h4>
                <ul class="footer-links">
                    <li><a href="#accueil">Accueil</a></li>
                    <li><a href="#services">Services</a></li>
                    <li><a href="#profils">Équipes</a></li>
                    <li><a href="${pageContext.request.contextPath}/login">Connexion</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h4>Contact</h4>
                <ul class="footer-links footer-contact">
                    <li>
                        <i class="fas fa-map-marker-alt"></i>
                        <span>Avenue Hassan II, Fès 30000</span>
                    </li>
                    <li>
                        <i class="fas fa-phone-alt"></i>
                        <span>+212 535-XX-XX-XX</span>
                    </li>
                    <li>
                        <i class="fas fa-envelope"></i>
                        <span>contact@clinique-excellence.ma</span>
                    </li>
                </ul>
            </div>
        </div>
        
        <div class="footer-bottom">
            <div class="footer-bottom-content">
                <p class="footer-copyright">
                    © 2025 <strong>Clinique Excellence</strong>. Tous droits réservés.
                </p>
                <div class="footer-legal">
                    <a href="#">Confidentialité</a>
                    <a href="#">Conditions</a>
                    <a href="#">Cookies</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Custom JavaScript -->
    <script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
</body>
</html>
