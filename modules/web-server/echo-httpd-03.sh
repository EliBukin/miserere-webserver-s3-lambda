#!/bin/bash
echo "<p>vini vidi vici
</p>" > index.html
sudo chmod 777 /index.html
nohup busybox httpd -f -p 8080 &
