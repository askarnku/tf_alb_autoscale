#!/bin/bash
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Hello, World" > /var/www/html/index.html

yum install stress -y