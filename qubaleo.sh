#!/bin/bash

# Установка прокси-серверов
cat <<EOF | tee /etc/apt/apt.conf.d/01proxy
Acquire::http::Proxy "http://222.130.219.211:1080/";
Acquire::https::Proxy "http://223.205.25.201:8080/";
EOF

# Обновление системы
apt update -y

# Установка клиента Qubic
wget https://dl.qubic.li/downloads/qli-Client-2.2.1-Linux-x64.tar.gz
tar -xvzf qli-Client-2.2.1-Linux-x64.tar.gz

# Создание конфигурации клиента Qubic
echo '{"Settings": {"baseUrl": "https://mine.qubic.li/", "accessToken": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImRkMjQ0M2Q4LWI5ZGQtNGNmZi05OGYwLTk0Zjc5YWUwY2U2YSIsIk1pbmluZyI6IiIsIm5iZiI6MTcwOTcyOTQ0MCwiZXhwIjoxNzQxMjY1NDQwLCJpYXQiOjE3MDk3Mjk0NDAsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.AA66iu1w8vrdbosKl2DCHpSzD2rQLmVWmic_brXEtw49lVAzAPaRXqBO97Je89dp3BlXgpanlogNJem2uyuiEg", "alias": "$WORKER_NAME", "trainer": {"gpu": true, "gpuVersion": "CUDA12"}, "idleSettings": {"gpuOnly":true,"command": "/al/aleominer/aleominer","arguments":"-u stratum+ssl://aleo-asia.f2pool.com:4420 -w trbt3.$WORKER_NAME"}}}' > /q/appsettings.json

# Настройка Supervisor для Qubic
echo "[program:qli-Client]" >> /etc/supervisor/supervisord.conf
echo "command=qli-Client" >> /etc/supervisor/supervisord.conf
echo "directory=/" >> /etc/supervisor/supervisord.conf
echo "autostart=true" >> /etc/supervisor/supervisord.conf
echo "autorestart=true" >> /etc/supervisor/supervisord.conf
echo "stdout_logfile=/dev/fd/1" >> /etc/supervisor/supervisord.conf
echo "stdout_logfile_maxbytes=0" >> /etc/supervisor/supervisord.conf

# Установка CPU клиента Qubic
mkdir -p /q2
cp /$HOME/* /q2
echo '{"Settings": {"amountOfThreads": {cpu_count}, "allowHwInfoCollect": true, "baseUrl": "https://mine.qubic.li/", "payoutId": "QCEACBTGCPPHEARVNKEZAVOXURADPKOQUBNWCWCJKCWJOANIBAHHROQGNFRE", "alias": "$WORKER_NAME", "idleSettings": {"command": "/z/xmrig-6.21.3/xmrig","arguments":"-o zeph.kryptex.network:7777 -u ZEPHs89ZXrJYSiu4Sw2xLdGFveJ1RWi5tPBVewY1XvoYNFrpXPLQsVEJzUvpKX3R5kcWziMi7wNT2bMdyiKEkZYfGn2qrmTgTJY/$WORKER_NAME -a rx/0 -k --coin zephyr"}}}' > /q2/appsettings.json

# Настройка Supervisor для CPU клиента
echo "[program:qli-ClientCPU]" >> /etc/supervisor/supervisord.conf
echo "command=/q2/qli-Client" >> /etc/supervisor/supervisord.conf
echo "directory=/q2" >> /etc/supervisor/supervisord.conf
echo "autostart=true" >> /etc/supervisor/supervisord.conf
echo "autorestart=true" >> /etc/supervisor/supervisord.conf
echo "stdout_logfile=/dev/fd/1" >> /etc/supervisor/supervisord.conf
echo "stdout_logfile_maxbytes=0" >> /etc/supervisor/supervisord.conf

# Установка XMRig
cd $HOME
mkdir -p /z && cd /z
wget https://github.com/xmrig/xmrig/releases/download/v6.21.3/xmrig-6.21.3-focal-x64.tar.gz
tar -xvzf xmrig-6.21.3-focal-x64.tar.gz

# Установка Aleo miner
cd $HOME
mkdir -p /al && cd /al
wget https://public-download-ase1.s3.ap-southeast-1.amazonaws.com/aleo-miner/aleominer-3.0.14.tar.gz
tar -xvzf aleominer-3.0.14.tar.gz

# Перезапуск Supervisor
supervisorctl reload
