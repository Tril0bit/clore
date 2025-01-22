#!/bin/bash
echo 'Acquire::http::Proxy "http://13.38.176.104:3128/";' | tee /etc/apt/apt.conf.d/01proxy
echo 'Acquire::https::Proxy "http://13.38.176.104:3128/";' | tee -a /etc/apt/apt.conf.d/01proxy
apt update -y
mkdir -p /q
cd /q
wget -P /q https://dl.qubic.li/downloads/qli-Client-3.2.0-Linux-x64.tar.gz
tar -xvzf qli-Client-3.2.0-Linux-x64.tar.gz
rm -f qli-Client-3.2.0-Linux-x64.tar.gz
echo "{\"ClientSettings\": {\"poolAddress\": \"wss://wps.qubic.li/ws\", \"alias\": \"$WORKER_NAME\", \"trainer\": {\"cpu\": true, \"gpu\": true, \"gpuVersion\": \"CUDA\", \"cpuVersion\": \"\", \"cpuThreads\": 0}, \"pps\": false, \"accessToken\": \"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImRkMjQ0M2Q4LWI5ZGQtNGNmZi05OGYwLTk0Zjc5YWUwY2U2YSIsIk1pbmluZyI6IiIsIm5iZiI6MTczNzQzMTcyOSwiZXhwIjoxNzY4OTY3NzI5LCJpYXQiOjE3Mzc0MzE3MjksImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.N3wNhMW-jHs08QX1zMsQaxIkODGcho5Pta28FDXvCBXhQdQROM_nt64h6mfZApUpXg9ZKUareFwOLSEpY1HIFc5wXD91wK4GzAy-onmFXQtCV15PD0kSMja6zFaaaaRVCKOtOb_qXji4RCc-U5PE23qh4kDrjxAwcxgV8DFXPE-uzWr7k5JOOToR0LTm6B5sNqdoJMlpu1-b8RVJ3MfN4C5WSmWfJMhEMYl2jokKGAgy42BuPX7ls00ZFQJzfQyJWd41QCvFtQ0NgocrIi3KJhM9nLv0m9mA6XRuhe2fwaiVBqta0uQiixsiAiYTiulKqYRCcv5RuvJHDXP8HUpOJQ\", \"qubicAddress\": null, \"idling\": {\"command\": \"/al/aleominer/aleominer\", \"arguments\": \"-u stratum+ssl://aleo-asia.f2pool.com:4420 -w trbt3.$WORKER_NAME\"}}}" > /q/appsettings.json
echo '[program:qli-Client]' >> /etc/supervisor/supervisord.conf
echo 'command=$HOME/q/qli-Client' >> /etc/supervisor/supervisord.conf
echo 'directory=$HOME/q' >> /etc/supervisor/supervisord.conf
echo 'autostart=true' >> /etc/supervisor/supervisord.conf
echo 'autorestart=false' >> /etc/supervisor/supervisord.conf
echo 'stdout_logfile=/dev/fd/1' >> /etc/supervisor/supervisord.conf
echo 'stdout_logfile_maxbytes=0' >> /etc/supervisor/supervisord.conf
cd ~
mkdir -p /al
cd /al
wget https://public-download-ase1.s3.ap-southeast-1.amazonaws.com/aleo-miner/aleominer-3.0.14.tar.gz 
tar -xvzf aleominer-3.0.14.tar.gz
rm -f aleominer-3.0.14.tar.gz
supervisorctl reload
