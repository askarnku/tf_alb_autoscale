#!/bin/bash

# Install Apache HTTP server
yum install -y httpd

# Start and enable the HTTP server
systemctl start httpd
systemctl enable httpd

# Install the stress tool
yum install stress -y

# Write the HTML content to the index.html file using a heredoc
cat <<EOL > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>It Worked!</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            color: #333;
        }

        .container {
            text-align: center;
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .container h1 {
            font-size: 2.5em;
            color: #4CAF50;
            margin-bottom: 10px;
        }

        .container p {
            font-size: 1.2em;
            margin-bottom: 20px;
        }

        .container .button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 1em;
            transition: background-color 0.3s ease;
        }

        .container .button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>It Worked!</h1>
        <p>Your operation was successful, and your ALB is serving pages!</p>
        <a href="#" class="button">Celebrate!</a>
    </div>
</body>
</html>
EOL
