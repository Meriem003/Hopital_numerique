<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Contactez Clinique Excellence - Nous sommes à votre écoute pour toutes vos questions">
    <meta name="keywords" content="contact, clinique, médecin, rendez-vous, assistance">
    <title>Contact - Clinique Excellence</title>
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/home.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/contact.css" rel="stylesheet">
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
                <li><a href="${pageContext.request.contextPath}/" class="nav-link">
                    <i class="fas fa-home"></i>
                    <span>Accueil</span>
                </a></li>
                <li><a href="${pageContext.request.contextPath}/#services" class="nav-link">
                    <i class="fas fa-concierge-bell"></i>
                    <span>Services</span>
                </a></li>
                <li><a href="${pageContext.request.contextPath}/#profils" class="nav-link">
                    <i class="fas fa-user-md"></i>
                    <span>Profils</span>
                </a></li>
                <li><a href="${pageContext.request.contextPath}/contact.jsp" class="nav-link active">
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

    <!-- Contact Hero -->
    <section class="contact-hero">
        <div class="container">
            <div class="contact-hero-content">
                <div class="section-badge">
                    <i class="fas fa-headset"></i> Support 24/7
                </div>
                <h1 class="page-title">Contactez-Nous</h1>
                <p class="page-subtitle">
                    Notre équipe est à votre écoute pour répondre à toutes vos questions
                </p>
            </div>
        </div>
    </section>

    <!-- Contact Main Section -->
    <section class="contact-main">
        <div class="container">
            <div class="contact-grid">
                <!-- Contact Form -->
                <div class="contact-form-wrapper">
                    <div class="form-header">
                        <h2>Envoyez-nous un Message</h2>
                        <p>Remplissez le formulaire ci-dessous et nous vous répondrons dans les plus brefs délais</p>
                    </div>
                    
                    <form class="contact-form" id="contactForm" action="${pageContext.request.contextPath}/contact" method="POST">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="nom">
                                    <i class="fas fa-user"></i>
                                    Nom Complet
                                </label>
                                <input type="text" id="nom" name="nom" required placeholder="Votre nom complet">
                            </div>
                            
                            <div class="form-group">
                                <label for="email">
                                    <i class="fas fa-envelope"></i>
                                    Email
                                </label>
                                <input type="email" id="email" name="email" required placeholder="votre.email@example.com">
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="telephone">
                                    <i class="fas fa-phone"></i>
                                    Téléphone
                                </label>
                                <input type="tel" id="telephone" name="telephone" placeholder="+212 6XX-XXXXXX">
                            </div>
                            
                            <div class="form-group">
                                <label for="sujet">
                                    <i class="fas fa-tag"></i>
                                    Sujet
                                </label>
                                <select id="sujet" name="sujet" required>
                                    <option value="">Sélectionnez un sujet</option>
                                    <option value="rendez-vous">Prise de rendez-vous</option>
                                    <option value="information">Demande d'information</option>
                                    <option value="technique">Support technique</option>
                                    <option value="reclamation">Réclamation</option>
                                    <option value="autre">Autre</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="message">
                                <i class="fas fa-comment-dots"></i>
                                Message
                            </label>
                            <textarea id="message" name="message" rows="6" required placeholder="Décrivez votre demande en détail..."></textarea>
                        </div>
                        
                        <button type="submit" class="btn btn-primary btn-submit">
                            <i class="fas fa-paper-plane"></i>
                            Envoyer le Message
                        </button>
                    </form>
                </div>

                <!-- Contact Info -->
                <div class="contact-info-wrapper">
                    <div class="contact-info-card">
                        <div class="info-header">
                            <h3>Informations de Contact</h3>
                            <p>N'hésitez pas à nous contacter par les moyens suivants</p>
                        </div>
                        
                        <div class="info-items">
                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="fas fa-map-marker-alt"></i>
                                </div>
                                <div class="info-content">
                                    <h4>Adresse</h4>
                                    <p>Avenue Hassan II, Fès 30000<br>Maroc</p>
                                </div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="fas fa-phone-alt"></i>
                                </div>
                                <div class="info-content">
                                    <h4>Téléphone</h4>
                                    <p>+212 535-XX-XX-XX<br>+212 6XX-XXXXXX</p>
                                </div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="fas fa-envelope"></i>
                                </div>
                                <div class="info-content">
                                    <h4>Email</h4>
                                    <p>contact@clinique-excellence.ma<br>support@clinique-excellence.ma</p>
                                </div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div class="info-content">
                                    <h4>Horaires d'ouverture</h4>
                                    <p>Lun - Ven: 08:00 - 20:00<br>Sam: 09:00 - 18:00<br>Dim: Urgences uniquement</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="social-section">
                            <h4>Suivez-nous</h4>
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
                                <a href="#" class="social-link" aria-label="Instagram">
                                    <i class="fab fa-instagram"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Map Section -->
    <section class="map-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Notre Localisation</h2>
                <p class="section-subtitle">Trouvez-nous facilement sur la carte</p>
            </div>
            <div class="map-container">
                <iframe 
                    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3308.2857!2d-5.0!3d34.0333!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zMzTCsDAxJzU5LjkiTiA1wrAwMCcwMC4wIlc!5e0!3m2!1sfr!2sma!4v1234567890"
                    width="100%" 
                    height="450" 
                    style="border:0;" 
                    allowfullscreen="" 
                    loading="lazy" 
                    referrerpolicy="no-referrer-when-downgrade">
                </iframe>
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
                    <li><a href="${pageContext.request.contextPath}/#profils">Urgences</a></li>
                    <li><a href="${pageContext.request.contextPath}/#profils">Médecine Générale</a></li>
                    <li><a href="${pageContext.request.contextPath}/#profils">Neurologie</a></li>
                    <li><a href="${pageContext.request.contextPath}/#services">Cardiologie</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h4>Liens Rapides</h4>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/">Accueil</a></li>
                    <li><a href="${pageContext.request.contextPath}/#services">Services</a></li>
                    <li><a href="${pageContext.request.contextPath}/#profils">Équipes</a></li>
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

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/contact.js"></script>
</body>
</html>
