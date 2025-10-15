<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary: #0f172a;
            --secondary: #1e40af;
            --accent: #3b82f6;
            --gold: #f59e0b;
            --white: #ffffff;
            --gray-50: #f8fafc;
            --gray-100: #f1f5f9;
            --gray-200: #e2e8f0;
            --gray-600: #475569;
            --gray-900: #0f172a;
            --success: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
            --info: #3b82f6;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: var(--gray-50);
            color: var(--gray-900);
        }

        /* Sidebar */
        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: 280px;
            height: 100vh;
            background: linear-gradient(180deg, var(--primary) 0%, var(--secondary) 100%);
            padding: 2rem;
            overflow-y: auto;
            z-index: 1000;
            box-shadow: 4px 0 20px rgba(0, 0, 0, 0.1);
        }

        .sidebar::-webkit-scrollbar {
            width: 6px;
        }

        .sidebar::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.1);
        }

        .sidebar::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.3);
            border-radius: 3px;
        }

        .logo-section {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 3rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .logo-icon {
            width: 50px;
            height: 50px;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            font-size: 1.5rem;
        }

        .logo-text h3 {
            color: var(--white);
            font-size: 1.25rem;
            font-weight: 800;
        }

        .logo-text p {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .user-profile {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-avatar {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, var(--gold), var(--warning));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            font-size: 1.25rem;
            font-weight: 700;
        }

        .user-info h4 {
            color: var(--white);
            font-size: 0.95rem;
            margin-bottom: 0.25rem;
        }

        .user-info p {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.8rem;
        }

        .nav-menu {
            list-style: none;
        }

        .nav-item {
            margin-bottom: 0.5rem;
        }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            border-radius: 10px;
            transition: all 0.3s;
            font-size: 0.95rem;
        }

        .nav-link:hover,
        .nav-link.active {
            background: rgba(255, 255, 255, 0.15);
            color: var(--white);
        }

        .nav-link i {
            font-size: 1.25rem;
            width: 24px;
        }

        .logout-btn {
            margin-top: 2rem;
            width: 100%;
            padding: 1rem;
            background: rgba(239, 68, 68, 0.2);
            color: var(--white);
            border: 1px solid rgba(239, 68, 68, 0.3);
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
        }

        .logout-btn:hover {
            background: var(--danger);
        }

        /* Main Content */
        .main-content {
            margin-left: 280px;
            padding: 2rem;
            min-height: 100vh;
        }

        .header {
            background: var(--white);
            padding: 1.5rem 2rem;
            border-radius: 16px;
            margin-bottom: 2rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-title h1 {
            font-size: 1.75rem;
            color: var(--primary);
            font-weight: 800;
            margin-bottom: 0.25rem;
        }

        .header-title p {
            color: var(--gray-600);
            font-size: 0.95rem;
        }

        .header-actions {
            display: flex;
            gap: 1rem;
        }

        .header-btn {
            padding: 0.75rem 1.5rem;
            background: var(--primary);
            color: var(--white);
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s;
            text-decoration: none;
        }

        .header-btn:hover {
            background: var(--secondary);
            transform: translateY(-2px);
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: var(--white);
            padding: 1.75rem;
            border-radius: 16px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            transition: all 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: var(--white);
        }

        .stat-icon.blue {
            background: linear-gradient(135deg, var(--secondary), var(--accent));
        }

        .stat-icon.green {
            background: linear-gradient(135deg, #059669, var(--success));
        }

        .stat-icon.orange {
            background: linear-gradient(135deg, #d97706, var(--gold));
        }

        .stat-icon.red {
            background: linear-gradient(135deg, #dc2626, var(--danger));
        }

        .stat-trend {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            font-size: 0.85rem;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-weight: 600;
        }

        .stat-trend.up {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }

        .stat-trend.down {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 800;
            color: var(--primary);
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: var(--gray-600);
            font-size: 0.9rem;
            font-weight: 500;
        }

        /* Content Grid */
        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .card {
            background: var(--white);
            padding: 2rem;
            border-radius: 16px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--gray-200);
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--primary);
        }

        .card-action {
            color: var(--secondary);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: color 0.3s;
        }

        .card-action:hover {
            color: var(--accent);
        }

        /* Table */
        .table-container {
            overflow-x: auto;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table thead {
            background: var(--gray-50);
        }

        .data-table th {
            padding: 1rem;
            text-align: left;
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--gray-600);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .data-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--gray-200);
            font-size: 0.9rem;
            color: var(--gray-900);
        }

        .data-table tr:hover {
            background: var(--gray-50);
        }

        .badge {
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.375rem;
        }

        .badge.success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }

        .badge.warning {
            background: rgba(245, 158, 11, 0.1);
            color: var(--warning);
        }

        .badge.danger {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
        }

        .badge.info {
            background: rgba(59, 130, 246, 0.1);
            color: var(--info);
        }

        .action-btns {
            display: flex;
            gap: 0.5rem;
        }

        .action-btn {
            width: 32px;
            height: 32px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
            font-size: 0.9rem;
        }

        .action-btn.edit {
            background: rgba(59, 130, 246, 0.1);
            color: var(--info);
        }

        .action-btn.delete {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
        }

        .action-btn:hover {
            transform: scale(1.1);
        }

        /* Activity List */
        .activity-list {
            list-style: none;
        }

        .activity-item {
            display: flex;
            gap: 1rem;
            padding: 1rem 0;
            border-bottom: 1px solid var(--gray-200);
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .activity-icon.blue {
            background: rgba(59, 130, 246, 0.1);
            color: var(--info);
        }

        .activity-icon.green {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }

        .activity-icon.orange {
            background: rgba(245, 158, 11, 0.1);
            color: var(--warning);
        }

        .activity-content h4 {
            font-size: 0.9rem;
            color: var(--primary);
            margin-bottom: 0.25rem;
        }

        .activity-content p {
            font-size: 0.85rem;
            color: var(--gray-600);
        }

        .activity-time {
            font-size: 0.8rem;
            color: var(--gray-600);
            margin-left: auto;
            flex-shrink: 0;
        }

        @media (max-width: 1200px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .content-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .main-content {
                margin-left: 0;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .header {
                flex-direction: column;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="logo-section">
            <div class="logo-icon">
                <i class="fas fa-hospital-symbol"></i>
            </div>
            <div class="logo-text">
                <h3>Clinique Excellence</h3>
                <p>Admin Panel</p>
            </div>
        </div>

        <div class="user-profile">
            <div class="user-avatar">AD</div>
            <div class="user-info">
                <h4>Administrateur</h4>
                <p>admin@clinique.ma</p>
            </div>
        </div>

        <nav>
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="#" class="nav-link active">
                        <i class="fas fa-chart-line"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="departements.jsp" class="nav-link">
                        <i class="fas fa-building"></i>
                        <span>Départements</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="docteurs.jsp" class="nav-link">
                        <i class="fas fa-user-md"></i>
                        <span>Docteurs</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="patients.jsp" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Patients</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="salles.jsp" class="nav-link">
                        <i class="fas fa-door-open"></i>
                        <span>Salles</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="consultations.jsp" class="nav-link">
                        <i class="fas fa-calendar-check"></i>
                        <span>Consultations</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="statistiques.jsp" class="nav-link">
                        <i class="fas fa-chart-pie"></i>
                        <span>Statistiques</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="parametres.jsp" class="nav-link">
                        <i class="fas fa-cog"></i>
                        <span>Paramètres</span>
                    </a>
                </li>
            </ul>
        </nav>

        <button class="logout-btn" onclick="location.href='LogoutServlet'">
            <i class="fas fa-sign-out-alt"></i>
            Déconnexion
        </button>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Header -->
        <header class="header">
            <div class="header-title">
                <h1>Tableau de Bord</h1>
                <p>Bienvenue sur votre panneau d'administration</p>
            </div>
            <div class="header-actions">
                <button class="header-btn" onclick="location.href='ajouterDocteur.jsp'">
                    <i class="fas fa-plus"></i>
                    Nouveau Docteur
                </button>
            </div>
        </header>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon blue">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-trend up">
                        <i class="fas fa-arrow-up"></i>
                        12%
                    </div>
                </div>
                <div class="stat-value">1,245</div>
                <div class="stat-label">Total Patients</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon green">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="stat-trend up">
                        <i class="fas fa-arrow-up"></i>
                        8%
                    </div>
                </div>
                <div class="stat-value">48</div>
                <div class="stat-label">Docteurs Actifs</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon orange">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="stat-trend up">
                        <i class="fas fa-arrow-up"></i>
                        25%
                    </div>
                </div>
                <div class="stat-value">324</div>
                <div class="stat-label">Consultations</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon red">
                        <i class="fas fa-door-open"></i>
                    </div>
                    <div class="stat-trend down">
                        <i class="fas fa-arrow-down"></i>
                        3%
                    </div>
                </div>
                <div class="stat-value">85%</div>
                <div class="stat-label">Taux d'occupation</div>
            </div>
        </div>

        <!-- Content Grid -->
        <div class="content-grid">
            <!-- Recent Consultations -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Consultations Récentes</h3>
                    <a href="consultations.jsp" class="card-action">
                        Voir tout <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Patient</th>
                                <th>Docteur</th>
                                <th>Date</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Ahmed Benali</td>
                                <td>Dr. Sara Alami</td>
                                <td>15 Oct 2025, 14:30</td>
                                <td><span class="badge success"><i class="fas fa-check"></i> Validée</span></td>
                                <td>
                                    <div class="action-btns">
                                        <button class="action-btn edit"><i class="fas fa-eye"></i></button>
                                        <button class="action-btn delete"><i class="fas fa-trash"></i></button>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>Fatima Zahra</td>
                                <td>Dr. Mohammed Tazi</td>
                                <td>15 Oct 2025, 15:00</td>
                                <td><span class="badge warning"><i class="fas fa-clock"></i> Réservée</span></td>
                                <td>
                                    <div class="action-btns">
                                        <button class="action-btn edit"><i class="fas fa-eye"></i></button>
                                        <button class="action-btn delete"><i class="fas fa-trash"></i></button>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>Youssef Idrissi</td>
                                <td>Dr. Laila Benjelloun</td>
                                <td>15 Oct 2025, 16:00</td>
                                <td><span class="badge info"><i class="fas fa-check-double"></i> Terminée</span></td>
                                <td>
                                    <div class="action-btns">
                                        <button class="action-btn edit"><i class="fas fa-eye"></i></button>
                                        <button class="action-btn delete"><i class="fas fa-trash"></i></button>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>Amina Rahali</td>
                                <td>Dr. Karim Fassi</td>
                                <td>14 Oct 2025, 10:30</td>
                                <td><span class="badge danger"><i class="fas fa-times"></i> Annulée</span></td>
                                <td>
                                    <div class="action-btns">
                                        <button class="action-btn edit"><i class="fas fa-eye"></i></button>
                                        <button class="action-btn delete"><i class="fas fa-trash"></i></button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Activité Récente</h3>
                </div>
                <ul class="activity-list">
                    <li class="activity-item">
                        <div class="activity-icon blue">
                            <i class="fas fa-user-plus"></i>
                        </div>
                        <div class="activity-content">
                            <h4>Nouveau Patient</h4>
                            <p>Hassan Amrani s'est inscrit</p>
                        </div>
                        <span class="activity-time">Il y a 5 min</span>
                    </li>
                    <li class="activity-item">
                        <div class="activity-icon green">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="activity-content">
                            <h4>Consultation Validée</h4>
                            <p>Dr. Sara Alami a validé une consultation</p>
                        </div>
                        <span class="activity-time">Il y a 15 min</span>
                    </li>
                    <li class="activity-item">
                        <div class="activity-icon orange">
                            <i class="fas fa-door-open"></i>
                        </div>
                        <div class="activity-content">
                            <h4>Nouvelle Salle</h4>
                            <p>Salle 305 a été ajoutée</p>
                        </div>
                        <span class="activity-time">Il y a 1 heure</span>
                    </li>
                    <li class="activity-item">
                        <div class="activity-icon blue">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <div class="activity-content">
                            <h4>Nouveau Docteur</h4>
                            <p>Dr. Khalid Senhaji a rejoint l'équipe</p>
                        </div>
                        <span class="activity-time">Il y a 3 heures</span>
                    </li>
                    <li class="activity-item">
                        <div class="activity-icon green">
                            <i class="fas fa-building"></i>
                        </div>
                        <div class="activity-content">
                            <h4>Département Mis à Jour</h4>
                            <p>Département Cardiologie modifié</p>
                        </div>
                        <span class="activity-time">Il y a 5 heures</span>
                    </li>
                </ul>
            </div>
        </div>
    </main>
</body>
</html>
