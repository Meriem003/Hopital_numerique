/* ============================================
   HERO SECTION ENHANCED - INTERACTIVE ANIMATIONS
   ============================================ */

document.addEventListener('DOMContentLoaded', function() {
    
    // ===== ANIMATED COUNTER =====
    function animateCounter(element, target, duration = 2000) {
        const start = 0;
        const increment = target / (duration / 16);
        let current = start;
        
        const timer = setInterval(() => {
            current += increment;
            if (current >= target) {
                element.textContent = Math.floor(target);
                clearInterval(timer);
            } else {
                element.textContent = Math.floor(current);
            }
        }, 16);
    }
    
    // Démarrer les compteurs quand la section hero est visible
    const observerOptions = {
        threshold: 0.5
    };
    
    const heroObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                // Animer les compteurs
                document.querySelectorAll('.stat-number').forEach(counter => {
                    const target = parseInt(counter.getAttribute('data-target'));
                    animateCounter(counter, target);
                });
                
                heroObserver.disconnect();
            }
        });
    }, observerOptions);
    
    const heroSection = document.querySelector('.hero');
    if (heroSection) {
        heroObserver.observe(heroSection);
    }
    
    // ===== PARTICLES ANIMATION =====
    const particlesContainer = document.getElementById('heroParticles');
    if (particlesContainer) {
        createParticles(particlesContainer, 30);
    }
    
    function createParticles(container, count) {
        for (let i = 0; i < count; i++) {
            const particle = document.createElement('div');
            particle.className = 'particle';
            
            // Position et taille aléatoires
            const size = Math.random() * 4 + 2;
            const left = Math.random() * 100;
            const animationDuration = Math.random() * 10 + 10;
            const delay = Math.random() * 5;
            const opacity = Math.random() * 0.3 + 0.1;
            
            particle.style.cssText = `
                position: absolute;
                width: ${size}px;
                height: ${size}px;
                background: rgba(8, 145, 178, ${opacity});
                border-radius: 50%;
                left: ${left}%;
                bottom: -10px;
                animation: particleFloat ${animationDuration}s ease-in-out ${delay}s infinite;
            `;
            
            container.appendChild(particle);
        }
        
        // Ajouter l'animation CSS si elle n'existe pas
        if (!document.querySelector('#particle-animation-style')) {
            const style = document.createElement('style');
            style.id = 'particle-animation-style';
            style.textContent = `
                @keyframes particleFloat {
                    0% {
                        transform: translateY(0) translateX(0);
                        opacity: 0;
                    }
                    10% {
                        opacity: 1;
                    }
                    90% {
                        opacity: 1;
                    }
                    100% {
                        transform: translateY(-100vh) translateX(${Math.random() * 100 - 50}px);
                        opacity: 0;
                    }
                }
            `;
            document.head.appendChild(style);
        }
    }
    
    // ===== TYPING EFFECT =====
    const typingText = document.querySelector('.typing-effect');
    if (typingText) {
        const text = typingText.textContent;
        typingText.textContent = '';
        let charIndex = 0;
        
        function typeWriter() {
            if (charIndex < text.length) {
                typingText.textContent += text.charAt(charIndex);
                charIndex++;
                setTimeout(typeWriter, 100);
            }
        }
        
        setTimeout(typeWriter, 800);
    }
    
    // ===== PARALLAX EFFECT =====
    window.addEventListener('mousemove', (e) => {
        const mouseX = e.clientX / window.innerWidth;
        const mouseY = e.clientY / window.innerHeight;
        
        // Déplacer les éléments flottants
        document.querySelectorAll('.floating-element').forEach((element, index) => {
            const speed = (index + 1) * 0.5;
            const x = (mouseX - 0.5) * speed * 30;
            const y = (mouseY - 0.5) * speed * 30;
            element.style.transform = `translate(${x}px, ${y}px)`;
        });
        
        // Déplacer les cercles de fond
        document.querySelectorAll('.hero-circle').forEach((circle, index) => {
            const speed = (index + 1) * 0.3;
            const x = (mouseX - 0.5) * speed * 50;
            const y = (mouseY - 0.5) * speed * 50;
            circle.style.transform = `translate(${x}px, ${y}px)`;
        });
    });
    
    // ===== MOCKUP CARDS HOVER EFFECT =====
    document.querySelectorAll('.mockup-card').forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-8px) scale(1.02)';
            this.style.boxShadow = '0 12px 30px rgba(8, 145, 178, 0.2)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
            this.style.boxShadow = '';
        });
    });
    
    // ===== STATS HOVER EFFECT =====
    document.querySelectorAll('.stat').forEach(stat => {
        stat.addEventListener('mouseenter', function() {
            const icon = this.querySelector('.stat-icon');
            icon.style.transform = 'scale(1.1) rotate(5deg)';
        });
        
        stat.addEventListener('mouseleave', function() {
            const icon = this.querySelector('.stat-icon');
            icon.style.transform = 'scale(1) rotate(0deg)';
        });
    });
    
    // ===== BUTTON RIPPLE EFFECT =====
    document.querySelectorAll('.btn').forEach(button => {
        button.addEventListener('click', function(e) {
            const rect = this.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            
            const ripple = document.createElement('span');
            ripple.style.cssText = `
                position: absolute;
                width: 20px;
                height: 20px;
                background: rgba(255, 255, 255, 0.6);
                border-radius: 50%;
                left: ${x}px;
                top: ${y}px;
                transform: translate(-50%, -50%) scale(0);
                animation: ripple 0.6s ease-out;
                pointer-events: none;
            `;
            
            this.appendChild(ripple);
            
            setTimeout(() => ripple.remove(), 600);
        });
    });
    
    // Ajouter l'animation ripple CSS
    if (!document.querySelector('#ripple-animation-style')) {
        const style = document.createElement('style');
        style.id = 'ripple-animation-style';
        style.textContent = `
            @keyframes ripple {
                to {
                    transform: translate(-50%, -50%) scale(20);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);
    }
    
    // ===== SCROLL REVEAL ANIMATION =====
    const revealElements = document.querySelectorAll('[data-aos]');
    
    const revealObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('aos-animate');
                revealObserver.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.1,
        rootMargin: '0px 0px -100px 0px'
    });
    
    revealElements.forEach(element => {
        element.style.opacity = '0';
        revealObserver.observe(element);
    });
    
    // Ajouter les styles d'animation AOS
    if (!document.querySelector('#aos-animation-style')) {
        const style = document.createElement('style');
        style.id = 'aos-animation-style';
        style.textContent = `
            [data-aos] {
                transition: opacity 0.6s ease, transform 0.6s ease;
            }
            
            [data-aos].aos-animate {
                opacity: 1 !important;
                transform: translateY(0) !important;
            }
            
            [data-aos="fade-up"] {
                transform: translateY(30px);
            }
            
            [data-aos="fade-left"] {
                transform: translateX(30px);
            }
            
            [data-aos="fade-down"] {
                transform: translateY(-30px);
            }
        `;
        document.head.appendChild(style);
    }
    
    // ===== GRADIENT ANIMATION =====
    const gradientText = document.querySelector('.gradient-text');
    if (gradientText) {
        let hue = 180;
        setInterval(() => {
            hue = (hue + 1) % 360;
            gradientText.style.background = `linear-gradient(135deg, 
                hsl(${hue}, 70%, 50%), 
                hsl(${(hue + 30) % 360}, 70%, 55%), 
                hsl(${(hue + 60) % 360}, 70%, 60%)
            )`;
            gradientText.style.backgroundClip = 'text';
            gradientText.style.webkitBackgroundClip = 'text';
        }, 50);
    }
    
    // ===== SMOOTH SCROLL =====
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            if (href !== '#' && href !== '') {
                e.preventDefault();
                const target = document.querySelector(href);
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            }
        });
    });
    
    // ===== LAZY LOADING IMAGES =====
    const images = document.querySelectorAll('img[data-src]');
    const imageObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                img.src = img.dataset.src;
                img.removeAttribute('data-src');
                imageObserver.unobserve(img);
            }
        });
    });
    
    images.forEach(img => imageObserver.observe(img));
    
    // ===== PERFORMANCE: REDUCE ANIMATIONS ON LOW-END DEVICES =====
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
        document.querySelectorAll('*').forEach(element => {
            element.style.animation = 'none';
            element.style.transition = 'none';
        });
    }
    
    console.log('✅ Hero Section Enhanced - Animations chargées avec succès');
});

// ===== UTILITY: Throttle Function =====
function throttle(func, delay) {
    let lastCall = 0;
    return function(...args) {
        const now = new Date().getTime();
        if (now - lastCall < delay) {
            return;
        }
        lastCall = now;
        return func(...args);
    };
}

// ===== UTILITY: Debounce Function =====
function debounce(func, delay) {
    let timeoutId;
    return function(...args) {
        clearTimeout(timeoutId);
        timeoutId = setTimeout(() => func.apply(this, args), delay);
    };
}
