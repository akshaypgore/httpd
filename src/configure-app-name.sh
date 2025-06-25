#!/usr/bin/bash
echo "Hello from $1 app" > /usr/local/apache2/htdocs/index.html
httpd-foreground