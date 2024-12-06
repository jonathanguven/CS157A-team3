<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile - Grocery Gander Flea Market</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
    <style>
        :root {
            --primary-color: #4CAF50;
            --secondary-color: #FF9800;
            --background-color: #F5F5F5;
            --text-color: #333;
            --shadow-color: rgba(0, 0, 0, 0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--background-color);
            color: var(--text-color);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }

        .parallax-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('https://example.com/path/to/farmers-market-bg.jpg');
            background-size: cover;
            background-position: center;
            z-index: -1;
        }

        .content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
            position: relative;
            z-index: 1;
        }

        .profile-container {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(10px);
            padding: 2rem;
            border-radius: 20px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            border: 1px solid rgba(255, 255, 255, 0.18);
            width: 100%;
            max-width: 1200px;
            text-align: center;
            transition: all 0.3s ease;
        }

        .profile-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px 0 rgba(31, 38, 135, 0.45);
        }

        h2 {
            margin-bottom: 1.5rem;
            color: var(--primary-color);
            font-size: 2.5rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
        }

        .button-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }

        .icon-button {
            background-color: rgba(76, 175, 80, 0.1);
            border: none;
            border-radius: 15px;
            padding: 2rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: var(--primary-color);
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 4px 4px 8px rgba(0, 0, 0, 0.1), -4px -4px 8px rgba(255, 255, 255, 0.5);
        }

        .icon-button:hover {
            background-color: rgba(76, 175, 80, 0.2);
            transform: translateY(-5px);
            box-shadow: 6px 6px 12px rgba(0, 0, 0, 0.15), -6px -6px 12px rgba(255, 255, 255, 0.6);
        }

        .icon-button:active {
            transform: translateY(0);
            box-shadow: inset 2px 2px 5px rgba(0, 0, 0, 0.15), inset -2px -2px 5px rgba(255, 255, 255, 0.5);
        }

        .icon-button i {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .button-text {
            font-size: 1.2rem;
        }

        .tips-container {
            margin-top: 2rem;
            background-color: rgba(255, 255, 255, 0.5);
            padding: 1.5rem;
            border-radius: 15px;
            text-align: left;
        }

        .tips-container h3 {
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .tips-container ul {
            list-style-type: none;
        }

        .tips-container li {
            margin-bottom: 0.5rem;
            padding-left: 1.5rem;
            position: relative;
        }

        .tips-container li::before {
            content: "\f058";
            font-family: "Font Awesome 5 Free";
            font-weight: 900;
            position: absolute;
            left: 0;
            color: var(--secondary-color);
        }

        @media (max-width: 768px) {
            .button-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="parallax-bg"></div>
    <div class="content">
        <div class="profile-container">
            <h2>Welcome to Your Grocery Gander Flea Market Profile!</h2>

            <div class="button-container">
                <button class="icon-button" onclick="handleAddProduct()">
    <i class="fas fa-plus-circle"></i>
    <div class="button-text">Add New Product</div>
</button>


                <button class="icon-button" onclick="requestPermission()">
                    <i class="fas fa-user-check"></i>
                    <div class="button-text">Request Selling Permission</div>
                </button>

                <button class="icon-button" onclick="location.href='sellersRequest.jsp'">
                    <i class="fas fa-clipboard-list"></i>
                    <div class="button-text">Seller's Request</div>
                </button>

                <button class="icon-button" onclick="location.href='manageListings.jsp'">
                    <i class="fas fa-tasks"></i>
                    <div class="button-text">Manage Listings</div>
                </button>

                <button class="icon-button" onclick="location.href='adminReportDashboard.jsp'">
                    <i class="fas fa-chart-bar"></i>
                    <div class="button-text">Manage Reports</div>
                </button>
            </div>

            <div class="tips-container">
                <h3>Seller Tips</h3>
                <ul>
                    <li>Keep your product descriptions detailed and accurate to attract more buyers.</li>
                    <li>Regularly update your inventory to show only available items.</li>
                    <li>Respond promptly to buyer inquiries to maintain a good seller rating.</li>
                    <li>Use high-quality images to showcase your products effectively.</li>
                    <li>Price your items competitively by researching similar products in the market.</li>
                    <li>Offer bundle deals or discounts for bulk purchases to encourage larger sales.</li>
                    <li>Participate in seasonal events or themed markets to boost visibility.</li>
                </ul>
            </div>
        </div>
    </div>

    <script>
    function requestPermission() {
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "SellRequest", true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4 && xhr.status == 200) {
                alert(xhr.responseText);
            }
        };
        xhr.send();
    }

    function checkApproval(callback) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "checkApprovalServlet", true); // Use a servlet to handle the check
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                callback(xhr.responseText === "approved"); // Call the callback with the result
            }
        };
        xhr.send();
    }

    function handleAddProduct() {
        checkApproval(function(isApproved) {
            if (isApproved) {
                window.location.href = 'addProduct.jsp';
            } else {
                alert('You are not approved to add products. Please request selling permission.');
            }
        });
    }

    // Parallax effect
    window.addEventListener('scroll', () => {
        const scrolled = window.pageYOffset;
        const parallaxBg = document.querySelector('.parallax-bg');
        parallaxBg.style.transform = `translateY(${scrolled * 0.5}px)`;
    });
</script>

</body>
</html>

