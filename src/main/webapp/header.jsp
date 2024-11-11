
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grocery Gander</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f0f0;
        }

        .header {
            width: 100%;
            background-color: #4CAF50;
            padding: 0.25rem 0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        .logo {
            font-size: 2rem;
            font-weight: bold;
            color: white;
            display: flex;
            align-items: center;
            justify-content: flex-start; /* Ensure logo stays aligned to the left */
        }

        .logo svg {
            width: 20px;
            height: 20px;
            margin-left: 0.3rem;
        }

        .search-container {
            flex-grow: 2; /* Increase the flex-grow to expand the search bar */
            margin: 0 1rem;
        }

        .search-container form {
            display: flex;
            background-color: white;
            border-radius: 20px;
            overflow: hidden;
        }

        .search-container input {
            flex-grow: 1;
            padding: 0.5rem 1rem;
            border: none;
            font-size: 1rem;
        }

        .search-container button {
            padding: 0.5rem 1rem;
            background-color: #45a049;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 1rem;
        }

        .search-container button:hover {
            background-color: #3d8b3d;
        }

        .nav-links {
            display: flex;
            flex-shrink: 0;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            padding: 0.25rem 1rem;
            margin-left: 0.5rem;
            border-radius: 20px;
            transition: background-color 0.3s ease;
            font-size: 1.1rem; /* Increase font size for links */
        }

        .nav-links a:hover {
            background-color: rgba(255,255,255,0.2);
        }

        @media (max-width: 768px) {
            .nav {
                flex-direction: column;
                align-items: stretch;
                padding: 0.5rem;
            }

            .logo, .search-container, .nav-links {
                margin-bottom: 0.5rem;
            }

            .search-container {
                max-width: none;
                margin: 0.5rem 0;
            }

            .nav-links {
                justify-content: center;
            }

            .nav-links a {
                margin: 0.25rem;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <nav class="nav">
            <div class="logo">
                 <a href="home.jsp" style="text-decoration: none; color: white; display: flex; align-items: center;">
                    Grocery Gander
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M2.5 5.5L5 3.8a2.9 2.9 0 0 1 2-.8h10c.8 0 1.5.3 2 .8l2.5 1.7"/>
                        <path d="M2.5 14.5L5 16.2c.5.5 1.2.8 2 .8h10c.8 0 1.5-.3 2-.8l2.5-1.7"/>
                        <path d="M2.5 10h19"/>
                        <path d="M10 3.5v17"/>
                        <path d="M14 3.5v17"/>
                    </svg>
                </a>
            </div>
            <div class="search-container">
                <form action="search" method="get">
                    <input type="text" placeholder="Search for groceries..." name="query" aria-label="Search for groceries">
                    <button type="submit" aria-label="Submit search">Search</button>
                </form>
            </div>
            <div class="nav-links">
                <a href="login.jsp">Login</a>
				<a href="logout">Logout</a>
                <a href="Profile">Profile</a>
            </div>
        </nav>
    </header>
</body>
</html>
	