<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/register.css" rel="stylesheet">
</head>
<body>
    <!-- <a href="${pageContext.request.contextPath}/" class="back-home">
        <i class="fas fa-arrow-left"></i>
        Retour à l'accueil
    </a> -->

    <div class="register-container">
        <!-- Left Side - Branding -->
        <div class="register-brand">
            <div class="brand-content">
                <div class="brand-logo">
                    <div class="brand-logo-icon">
                        <i class="fas fa-hospital-symbol"></i>
                    </div>
                    <div class="brand-logo-text">
                        <div class="brand-logo-title">Clinique Excellence</div>
                        <div class="brand-logo-subtitle">Medical Platform</div>
                    </div>
                </div>

                <h1 class="brand-title">Rejoignez notre plateforme médicale</h1>
                <p class="brand-description">
                    Créez votre compte patient pour accéder à tous nos services médicaux digitaux et gérer vos consultations en ligne.
                </p>

                <ul class="brand-features">
                    <li>
                        <i class="fas fa-check"></i>
                        <span>Inscription rapide et sécurisée</span>
                    </li>
                    <li>
                        <i class="fas fa-check"></i>
                        <span>Accès immédiat aux services</span>
                    </li>
                    <li>
                        <i class="fas fa-check"></i>
                        <span>Gestion complète de votre santé</span>
                    </li>
                    <li>
                        <i class="fas fa-check"></i>
                        <span>Support disponible 24/7</span>
                    </li>
                </ul>
            </div>

            <div class="brand-footer">
                © 2025 Clinique Excellence. Tous droits réservés.
            </div>
        </div>

        <!-- Right Side - Register Form -->
        <div class="register-form-container">
            <div class="form-header">
                <h2 class="form-title">Créer un compte</h2>
            </div>

            <!-- Register Form -->
            <form class="register-form" action="${pageContext.request.contextPath}/register" method="POST" id="registerForm">
                
                <!-- Section 1: Informations Personnelles -->
                <div class="form-section">
                    <div class="section-header">
                        <div class="section-title">
                            <div class="section-icon">
                                <i class="fas fa-user"></i>
                            </div>
                            <span>Informations Personnelles</span>
                        </div>
                        <div class="toggle-btn">
                            <i class="fas fa-chevron-up"></i>
                        </div>
                    </div>
                    <div class="section-content">
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label" for="nom">
                                    Nom <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <i class="fas fa-user input-icon"></i>
                                    <input 
                                        type="text" 
                                        id="nom" 
                                        name="nom" 
                                        class="form-input" 
                                        placeholder="Votre nom"
                                        value="${param.nom}"
                                        required
                                    >
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="prenom">
                                    Prénom <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <i class="fas fa-user input-icon"></i>
                                    <input 
                                        type="text" 
                                        id="prenom" 
                                        name="prenom" 
                                        class="form-input" 
                                        placeholder="Votre prénom"
                                        value="${param.prenom}"
                                        required
                                    >
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="email">
                                Adresse Email <span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="fas fa-envelope input-icon"></i>
                                <input 
                                    type="email" 
                                    id="email" 
                                    name="email" 
                                    class="form-input" 
                                    placeholder="votre.email@exemple.com"
                                    value="${param.email}"
                                    required
                                >
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Section 2: Informations Médicales -->
                <div class="form-section">
                    <div class="section-header">
                        <div class="section-title">
                            <div class="section-icon">
                                <i class="fas fa-heartbeat"></i>
                            </div>
                            <span>Informations Médicales</span>
                        </div>
                        <div class="toggle-btn">
                            <i class="fas fa-chevron-up"></i>
                        </div>
                    </div>
                    <div class="section-content">
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label" for="poids">
                                    Poids <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <i class="fas fa-weight input-icon"></i>
                                    <input 
                                        type="number" 
                                        id="poids" 
                                        name="poids" 
                                        class="form-input" 
                                        placeholder="70"
                                        min="20"
                                        max="300"
                                        step="0.1"
                                        value="${param.poids}"
                                        required
                                    >
                                    <span class="input-unit">kg</span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="taille">
                                    Taille <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <i class="fas fa-ruler-vertical input-icon"></i>
                                    <input 
                                        type="number" 
                                        id="taille" 
                                        name="taille" 
                                        class="form-input" 
                                        placeholder="170"
                                        min="100"
                                        max="250"
                                        step="0.1"
                                        value="${param.taille}"
                                        required
                                    >
                                    <span class="input-unit">cm</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Section 3: Sécurité -->
                <div class="form-section">
                    <div class="section-header">
                        <div class="section-title">
                            <div class="section-icon">
                                <i class="fas fa-lock"></i>
                            </div>
                            <span>Sécurité du Compte</span>
                        </div>
                        <div class="toggle-btn">
                            <i class="fas fa-chevron-up"></i>
                        </div>
                    </div>
                    <div class="section-content">
                        <div class="form-group">
                            <label class="form-label" for="motDePasse">
                                Mot de passe <span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="fas fa-lock input-icon"></i>
                                <input 
                                    type="password" 
                                    id="password" 
                                    name="motDePasse" 
                                    class="form-input" 
                                    placeholder="••••••••"
                                    required
                                    minlength="8"
                                >
                            </div>
                            <div class="password-strength">
                                <div class="password-strength-bar" id="passwordStrengthBar"></div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="confirmPassword">
                                Confirmer le mot de passe <span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="fas fa-lock input-icon"></i>
                                <input 
                                    type="password" 
                                    id="confirmPassword" 
                                    name="confirmPassword" 
                                    class="form-input" 
                                    placeholder="••••••••"
                                    required
                                >
                            </div>
                        </div>

                        <div class="checkbox-group">
                            <input type="checkbox" id="terms" name="terms" required>
                            <label for="terms">
                                J'accepte les <a href="#">conditions d'utilisation</a> et la <a href="#">politique de confidentialité</a>
                            </label>
                        </div>
                    </div>
                </div>

                <button type="submit" class="submit-btn">
                    <span>Créer mon compte</span>
                    <i class="fas fa-arrow-right"></i>
                </button>
            </form>

            <div class="divider">
                <span>ou</span>
            </div>

            <p class="login-link">
                Vous avez déjà un compte ? <a href="${pageContext.request.contextPath}/login">Se connecter</a>
            </p>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/register.js"></script>
</body>
</html>