<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/login.css" rel="stylesheet">
</head>
<body>
    <a href="${pageContext.request.contextPath}/" class="back-home">
        <i class="fas fa-arrow-left"></i>
        Retour à l'accueil
    </a>

    <div class="login-container">
        <!-- Left Side - Branding -->
        <div class="login-brand">
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

                <h1 class="brand-title">Bienvenue sur Clinique Excellence</h1>
                <p class="brand-description">
                    Accédez à votre espace personnel pour gérer vos consultations et rendez-vous médicaux.
                </p>

                <ul class="brand-features">
                    <li>
                        <i class="fas fa-shield-alt"></i>
                        <span>Sécurité maximale</span>
                    </li>
                    <li>
                        <i class="fas fa-clock"></i>
                        <span>Service 24/7</span>
                    </li>
                    <li>
                        <i class="fas fa-user-md"></i>
                        <span>Suivi médical complet</span>
                    </li>
                    <li>
                        <i class="fas fa-mobile-alt"></i>
                        <span>Multi-plateformes</span>
                    </li>
                </ul>
            </div>

            <div class="brand-footer">
                © 2025 Clinique Excellence. Tous droits réservés.
            </div>
        </div>

        <!-- Right Side - Login Form -->
        <div class="login-form-container">
            <div class="form-header">
                <h2 class="form-title">Connexion</h2>
                <p class="form-subtitle">Connectez-vous à votre compte pour continuer</p>
            </div>


            <!-- Alert Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${error}</span>
                </div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>${success}</span>
                </div>
            </c:if>

            <!-- Login Form -->
            <form class="login-form" action="${pageContext.request.contextPath}/login" method="POST">
                <input type="hidden" name="userType" id="userType" value="patient">

                <div class="form-group">
                    <label class="form-label" for="email">Adresse Email</label>
                    <div class="input-wrapper">
                        <i class="fas fa-envelope input-icon"></i>
                        <input 
                            type="email" 
                            id="email" 
                            name="email" 
                            class="form-input" 
                            placeholder="votre.email@exemple.com"
                            required
                        >
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Mot de passe</label>
                    <div class="input-wrapper">
                        <i class="fas fa-lock input-icon" id="passwordToggle"></i>
                        <input 
                            type="password" 
                            id="password" 
                            name="motDePasse" 
                            class="form-input" 
                            placeholder="••••••••"
                            required
                        >
                    </div>
                </div>

                <div class="form-options">
                    <div class="checkbox-group">
                        <input type="checkbox" id="remember" name="remember">
                        <label for="remember">Se souvenir de moi</label>
                    </div>
                    <a href="#" class="forgot-link">Mot de passe oublié ?</a>
                </div>

                <button type="submit" class="submit-btn">
                    <span>Se Connecter</span>
                    <i class="fas fa-arrow-right"></i>
                </button>
            </form>

            <div class="divider">
                <span>ou</span>
            </div>

            <p class="register-link">
                Vous n'avez pas de compte ? <a href="${pageContext.request.contextPath}/register">Créer un compte</a>
            </p>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/login.js"></script>
</body>
</html>
