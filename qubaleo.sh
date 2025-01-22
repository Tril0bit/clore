#!/bin/bash

# Установка прокси-серверов
cat <<EOF | tee /etc/apt/apt.conf.d/01proxy
Acquire::http::Proxy "http://222.130.219.211:1080/";
Acquire::https::Proxy "http://223.205.25.201:8080/";
EOF

# Обновление системы
apt update -y

# Установка клиента Qubic
mkdir -p /q && cd /q
wget -P /q https://dl.qubic.li/downloads/qli-Client-2.2.1-Linux-x64.tar.gz
tar -xvzf qli-Client-2.2.1-Linux-x64.tar.gz
chmod +x /q/qli-Client

# Создание конфигурации клиента Qubic
echo '{"Settings": {"baseUrl": "https://mine.qubic.li/", "accessToken": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImRkMjQ0M2Q4LWI5ZGQtNGNmZi05OGYwLTk0Zjc5YWUwY2U2YSIsIk1pbmluZyI6IiIsIm5iZiI6MTcwOTcyOTQ0MCwiZXhwIjoxNzQxMjY1NDQwLCJpYXQiOjE3MDk3Mjk0NDAsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.AA66iu1w8vrdbosKl2DCHpSzD2rQLmVWmic_brXEtw49lVAzAPaRXqBO97Je89dp3BlXgpanlogNJem2uyuiEg", "alias": "$WORKER_NAME", "trainer": {"gpu": true, "gpuVersion": "CUDA12"}, "idleSettings": {"gpuOnly":true,"command": "/al/aleominer/aleominer","arguments":"-u stratum+ssl://aleo-asia.f2pool.com:4420 -w trbt3.$WORKER_NAME"}}}' > /q/appsettings.json

# Настройка Supervisor для Qubic
echo "[program:qli-Client]" >> /etc/supervisor/supervisord.conf
echo "command=/q/qli-Client" >> /etc/supervisor/supervisord.conf
echo "directory=/q" >> /etc/supervisor/supervisord.conf
echo "autostart=true" >> /etc/supervisor/supervisord.conf
echo "autorestart=true" >> /etc/supervisor/supervisord.conf
echo "stdout_logfile=/dev/fd/1" >> /etc/supervisor/supervisord.conf
echo "stdout_logfile_maxbytes=0" >> /etc/supervisor/supervisord.conf

# Установка Aleo miner
cd ~
mkdir -p /al && cd /al
wget https://public-download-ase1.s3.ap-southeast-1.amazonaws.com/aleo-miner/aleominer-3.0.14.tar.gz
tar -xvzf aleominer-3.0.14.tar.gz

# Перезапуск Supervisor
supervisorctl reload
