<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Clinique Excellence - Connexion & Inscription</title>
    
    <!-- Font Awesome -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
      integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A=="
      crossorigin="anonymous"
      referrerpolicy="no-referrer"
    />
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap"
      rel="stylesheet"
    />
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/register.css" />
</head>
<body>
    <!-- Animated Background -->
    <div class="animated-background">
        <div class="medical-icon icon-1"><i class="fas fa-heartbeat"></i></div>
        <div class="medical-icon icon-2"><i class="fas fa-stethoscope"></i></div>
        <div class="medical-icon icon-3"><i class="fas fa-user-md"></i></div>
        <div class="medical-icon icon-4"><i class="fas fa-pills"></i></div>
        <div class="medical-icon icon-5"><i class="fas fa-syringe"></i></div>
        <div class="medical-icon icon-6"><i class="fas fa-hospital"></i></div>
        <div class="medical-icon icon-7"><i class="fas fa-notes-medical"></i></div>
        <div class="medical-icon icon-8"><i class="fas fa-ambulance"></i></div>
        <div class="medical-icon icon-9"><i class="fas fa-dna"></i></div>
        <div class="medical-icon icon-10"><i class="fas fa-microscope"></i></div>
        
        <!-- Floating Circles -->
        <div class="floating-circle circle-1"></div>
        <div class="floating-circle circle-2"></div>
        <div class="floating-circle circle-3"></div>
        <div class="floating-circle circle-4"></div>
        <div class="floating-circle circle-5"></div>
    </div>

    <!-- Message d'alerte -->
    <% 
        String error = (String) request.getAttribute("error");
        String registerSuccess = request.getParameter("register");
        if (error != null) { 
    %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <span><%= error %></span>
            <button class="close-alert" onclick="this.parentElement.style.display='none'">
                <i class="fas fa-times"></i>
            </button>
        </div>
    <% } %>
    
    <% if ("success".equals(registerSuccess)) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span>Inscription réussie ! Vous pouvez maintenant vous connecter.</span>
            <button class="close-alert" onclick="this.parentElement.style.display='none'">
                <i class="fas fa-times"></i>
            </button>
        </div>
    <% } %>

    <%
        // Récupérer le mode depuis l'attribut (priorité) ou paramètre URL
        String modeAttr = (String) request.getAttribute("mode");
        String modeParam = request.getParameter("mode");
        String mode = modeAttr != null ? modeAttr : modeParam;
        
        // Par défaut, afficher le formulaire de connexion
        boolean showSignupForm = "signup".equals(mode);
    %>

    <div class="container" id="container" data-mode="<%= mode != null ? mode : "login" %>">
        <!-- Sign Up Form -->
        <div class="sign-up">
            <form action="${pageContext.request.contextPath}/register" method="POST">
                <h1>Créer un Compte</h1>
                <div class="icons">
            <a href="#" class="icon"><i class="fa-brands fa-facebook"></i></a>
            <a href="#" class="icon"><i class="fa-brands fa-google"></i></a>
          </div>
          <span>or use email for registeration</span>
                <div class="form-row">
                    <input type="text" name="nom" placeholder="Nom *" required />
                    <input type="text" name="prenom" placeholder="Prénom *" required />
                </div>
                
                <input type="email" name="email" placeholder="Email *" required />
                
                <div class="form-row">
                    <input type="password" name="motDePasse" id="passwordRegister" placeholder="Mot de passe *" required minlength="6" />
                    <input type="password" name="confirmPassword" id="confirmPasswordRegister" placeholder="Confirmer mot de passe *" required minlength="6" />
                </div>
                
                <div class="form-row optional">
                    <input type="number" name="poids" step="0.1" min="0" max="500" placeholder="Poids (kg)" />
                    <input type="number" name="taille" min="0" max="250" placeholder="Taille (cm)" />
                </div>
                
                <div class="password-strength" id="passwordStrength">
                    <div class="strength-bar"></div>
                </div>
                
                <button type="submit">
                    <i class="fas fa-user-plus"></i> S'inscrire
                </button>
            </form>
        </div>

        <!-- Sign In Form -->
        <div class="sign-in">
            <form action="${pageContext.request.contextPath}/login" method="POST">
                <h1>Se Connecter</h1>
                <div class="icons">
            <a href="#" class="icon"><i class="fa-brands fa-facebook"></i></a>
            <a href="#" class="icon"><i class="fa-brands fa-google"></i></a>
          </div>
          <span>or use email for registeration</span>
                <input type="email" name="email" placeholder="Email" required />
                <input type="password" name="motDePasse" placeholder="Mot de passe" required />
                
                <a href="${pageContext.request.contextPath}/forgot-password">
                    <i class="fas fa-lock"></i> Mot de passe oublié ?
                </a>
                
                <button type="submit">
                    <i class="fas fa-sign-in-alt"></i> Connexion
                </button>
            </form>
        </div>

        <!-- Toggle Container -->
        <div class="toogle-container">
            <div class="toogle">
                <div class="toogle-panel toogle-left">
                    <div class="logo-icon">
                        <i class="fas fa-hospital-symbol"></i>
                    </div>
                    <h1>Rejoignez-nous !</h1>
                    <p>Connectez-vous pour accéder à vos consultations et gérer votre santé</p>
                    <button class="hidden" id="login">
                        <i class="fas fa-sign-in-alt"></i> Se Connecter
                    </button>
                </div>
                <div class="toogle-panel toogle-right">
                    <div class="logo-icon">
                        <i class="fas fa-hospital-symbol"></i>
                    </div>
                    <h1>Welcome Back !</h1>
                    <p>Créez votre compte pour bénéficier de nos services médicaux</p>
                    <button class="hidden" id="register">
                        <i class="fas fa-user-plus"></i> S'inscrire
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/register.js"></script>
</body>
</html>
