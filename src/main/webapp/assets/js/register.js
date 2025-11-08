// ============================================
// CLINIQUE EXCELLENCE - REGISTER/LOGIN TOGGLE
// ============================================

const container = document.getElementById("container");
const registerbtn = document.getElementById("register");
const loginbtn = document.getElementById("login");

// Toggle to Sign Up
if (registerbtn) {
  registerbtn.addEventListener("click", () => {
    container.classList.add("active");
  });
}

// Toggle to Sign In
if (loginbtn) {
  loginbtn.addEventListener("click", () => {
    container.classList.remove("active");
  });
}

// ============================================
// CHECK URL PARAMETERS FOR MODE
// ============================================

window.addEventListener("DOMContentLoaded", () => {
  // Vérifier l'attribut data-mode du container (défini par le serveur)
  const dataMode = container.getAttribute('data-mode');
  
  // Si data-mode est défini, l'utiliser
  if (dataMode === 'signup') {
    container.classList.add("active");
  } else {
    // Par défaut, afficher le formulaire de connexion
    container.classList.remove("active");
  }
});

// ============================================
// ANIMATED BACKGROUND PARTICLES
// ============================================

window.addEventListener("load", () => {
  container.style.opacity = "0";
  container.style.transform = "translateY(20px)";
  
  setTimeout(() => {
    container.style.transition = "all 0.6s ease";
    container.style.opacity = "1";
    container.style.transform = "translateY(0)";
  }, 100);
  
  // Add extra floating particles dynamically
  createFloatingParticles();
});

function createFloatingParticles() {
  const background = document.querySelector('.animated-background');
  if (!background) return;
  
  const particleCount = 15;
  const colors = ['#0891b2', '#06b6d4', '#14b8a6'];
  
  for (let i = 0; i < particleCount; i++) {
    const particle = document.createElement('div');
    particle.className = 'particle';
    
    const size = Math.random() * 4 + 2;
    const color = colors[Math.floor(Math.random() * colors.length)];
    const left = Math.random() * 100;
    const animationDuration = Math.random() * 10 + 15;
    const delay = Math.random() * 5;
    
    particle.style.cssText = `
      position: absolute;
      width: ${size}px;
      height: ${size}px;
      background: ${color};
      border-radius: 50%;
      left: ${left}%;
      bottom: -10px;
      opacity: 0;
      animation: riseUp ${animationDuration}s ease-in ${delay}s infinite;
      box-shadow: 0 0 10px ${color};
    `;
    
    background.appendChild(particle);
  }
}

// Add CSS animation for particles
const style = document.createElement('style');
style.textContent = `
  @keyframes riseUp {
    0% {
      bottom: -10px;
      opacity: 0;
      transform: translateX(0) scale(0.5);
    }
    10% {
      opacity: 0.6;
    }
    90% {
      opacity: 0.4;
    }
    100% {
      bottom: 110%;
      opacity: 0;
      transform: translateX(${Math.random() * 100 - 50}px) scale(1);
    }
  }
`;
document.head.appendChild(style);

// ============================================
// PASSWORD STRENGTH INDICATOR
// ============================================

const passwordInput = document.getElementById("passwordRegister");
const strengthIndicator = document.getElementById("passwordStrength");
const strengthBar = strengthIndicator.querySelector(".strength-bar");

if (passwordInput) {
  passwordInput.addEventListener("input", function() {
    const password = this.value;
    
    if (password.length === 0) {
      strengthIndicator.classList.remove("active");
      strengthBar.className = "strength-bar";
      return;
    }
    
    strengthIndicator.classList.add("active");
    
    const strength = calculatePasswordStrength(password);
    
    strengthBar.classList.remove("weak", "medium", "strong");
    
    if (strength < 3) {
      strengthBar.classList.add("weak");
    } else if (strength < 5) {
      strengthBar.classList.add("medium");
    } else {
      strengthBar.classList.add("strong");
    }
  });
}

function calculatePasswordStrength(password) {
  let strength = 0;
  
  // Length check
  if (password.length >= 8) strength++;
  if (password.length >= 12) strength++;
  
  // Contains lowercase
  if (/[a-z]/.test(password)) strength++;
  
  // Contains uppercase
  if (/[A-Z]/.test(password)) strength++;
  
  // Contains numbers
  if (/\d/.test(password)) strength++;
  
  // Contains special characters
  if (/[!@#$%^&*(),.?":{}|<>]/.test(password)) strength++;
  
  return strength;
}

// ============================================
// FORM VALIDATION
// ============================================

const forms = document.querySelectorAll("form");

forms.forEach((form) => {
  form.addEventListener("submit", (e) => {
    const inputs = form.querySelectorAll("input[required]");
    let isValid = true;
    let errorMessage = "";

    inputs.forEach((input) => {
      if (!input.value.trim()) {
        isValid = false;
        input.style.borderColor = "#ef4444";
        
        setTimeout(() => {
          input.style.borderColor = "";
        }, 2000);
      }
    });

    // Check if it's the register form
    const isRegisterForm = form.querySelector('input[name="confirmPassword"]') !== null;
    
    if (isRegisterForm && isValid) {
      const password = form.querySelector('input[name="motDePasse"]').value;
      const confirmPassword = form.querySelector('input[name="confirmPassword"]').value;
      
      // Password match validation
      if (password !== confirmPassword) {
        e.preventDefault();
        isValid = false;
        errorMessage = "Les mots de passe ne correspondent pas";
        showAlert(errorMessage, "error");
      }
      
      // Password strength validation
      if (password.length < 6) {
        e.preventDefault();
        isValid = false;
        errorMessage = "Le mot de passe doit contenir au moins 6 caractères";
        showAlert(errorMessage, "error");
      }
      
      // Email validation
      const email = form.querySelector('input[name="email"]').value;
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email)) {
        e.preventDefault();
        isValid = false;
        errorMessage = "Veuillez entrer une adresse email valide";
        showAlert(errorMessage, "error");
      }
      
      // Poids validation (optional but if provided must be valid)
      const poidsInput = form.querySelector('input[name="poids"]');
      if (poidsInput && poidsInput.value) {
        const poids = parseFloat(poidsInput.value);
        if (poids <= 0 || poids > 500) {
          e.preventDefault();
          isValid = false;
          errorMessage = "Le poids doit être entre 0 et 500 kg";
          showAlert(errorMessage, "error");
        }
      }
      
      // Taille validation (optional but if provided must be valid)
      const tailleInput = form.querySelector('input[name="taille"]');
      if (tailleInput && tailleInput.value) {
        const taille = parseInt(tailleInput.value);
        if (taille <= 0 || taille > 250) {
          e.preventDefault();
          isValid = false;
          errorMessage = "La taille doit être entre 0 et 250 cm";
          showAlert(errorMessage, "error");
        }
      }
    }

    if (!isValid && errorMessage === "") {
      e.preventDefault();
      showAlert("Veuillez remplir tous les champs obligatoires", "error");
    }
  });
});

// ============================================
// SHOW ALERT FUNCTION
// ============================================

function showAlert(message, type) {
  // Remove existing alerts
  const existingAlerts = document.querySelectorAll('.alert');
  existingAlerts.forEach(alert => alert.remove());
  
  const alert = document.createElement('div');
  alert.className = `alert alert-${type}`;
  
  const icon = type === 'error' 
    ? '<i class="fas fa-exclamation-circle"></i>' 
    : '<i class="fas fa-check-circle"></i>';
  
  alert.innerHTML = `
    ${icon}
    <span>${message}</span>
    <button class="close-alert" onclick="this.parentElement.remove()">
      <i class="fas fa-times"></i>
    </button>
  `;
  
  document.body.appendChild(alert);
  
  // Auto remove after 5 seconds
  setTimeout(() => {
    alert.style.opacity = '0';
    setTimeout(() => alert.remove(), 300);
  }, 5000);
}

// ============================================
// INPUT FOCUS EFFECTS
// ============================================

const inputs = document.querySelectorAll("input");

inputs.forEach((input) => {
  input.addEventListener("focus", () => {
    input.style.transform = "scale(1.02)";
  });

  input.addEventListener("blur", () => {
    input.style.transform = "scale(1)";
  });
});

// ============================================
// AUTO-DISMISS ALERTS
// ============================================

window.addEventListener("load", () => {
  const alerts = document.querySelectorAll('.alert');
  alerts.forEach(alert => {
    setTimeout(() => {
      alert.style.opacity = '0';
      setTimeout(() => alert.remove(), 300);
    }, 5000);
  });
});
