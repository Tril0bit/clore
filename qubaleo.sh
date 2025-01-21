#!/bin/bash

# Установка прокси для APT
cat <<EOF | tee /etc/apt/apt.conf.d/01proxy
Acquire::http::Proxy "http://222.130.219.211:1080/";
Acquire::https::Proxy "http://223.205.25.201:8080/";
EOF

# Обновление списка пакетов
apt update -y

# Создание и настройка клиентских директорий
mkdir -p /q && cd /q
wget -P /q https://dl.qubic.li/downloads/qli-Client-2.2.1-Linux-x64.tar.gz

tar -xvzf qli-Client-2.2.1-Linux-x64.tar.gz

cat <<EOF > /q/appsettings.json
{"Settings": {"baseUrl": "https://mine.qubic.li/", "accessToken": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImRkMjQ0M2Q4LWI5ZGQtNGNmZi05OGYwLTk0Zjc5YWUwY2U2YSIsIk1pbmluZyI6IiIsIm5iZiI6MTcwOTcyOTQ0MCwiZXhwIjoxNzQxMjY1NDQwLCJpYXQiOjE3MDk3Mjk0NDAsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.AA66iu1w8vrdbosKl2DCHpSzD2rQLmVWmic_brXEtw49lVAzAPaRXqBO97Je89dp3BlXgpanlogNJem2uyuiEg", "alias": "r_MixedGPUs_{id}", "trainer": {"gpu": true, "gpuVersion": "CUDA12"}, "idleSettings": {"gpuOnly":true,"command": "/al/aleominer/aleominer","arguments":"-u stratum+ssl://aleo-asia.f2pool.com:4420 -w trbt3.rMixedGPUn{id}"}}}}
EOF

# Конфигурация Supervisor для GPU клиента
cat <<EOF >> /etc/supervisor/supervisord.conf
[program:qli-Client]
command=/q/qli-Client
directory=/q
autostart=true
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
EOF

# Создание и настройка второго клиента
mkdir -p /q2
cp /q/* /q2

cat <<EOF > /q2/appsettings.json
{"Settings": {"amountOfThreads": 0, "allowHwInfoCollect": true, "baseUrl": "https://mine.qubic.li/", "payoutId": "QCEACBTGCPPHEARVNKEZAVOXURADPKOQUBNWCWCJKCWJOANIBAHHROQGNFRE", "alias": "r_{id}", "idleSettings": {"command": "/z/SRBMiner-Multi-2-6-7/SRBMiner-MULTI","arguments":"--disable-gpu --algorithm verushash  --pool stratum+tcp://ru.vipor.net:5040 --wallet RARgd3pjGRMtbNPLidAaahVLLoCXkgBJrr.r_{id}"}}}}
EOF

# Конфигурация Supervisor для CPU клиента
cat <<EOF >> /etc/supervisor/supervisord.conf
[program:qli-ClientCPU]
command=/q2/qli-Client
directory=/q2
autostart=true
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
EOF

# Установка и разархивация майнеров
cd ~
mkdir -p /z && cd /z
wget -O SRBMiner-Multi-2-6-7-Linux.tar.gz https://github.com/doktor83/SRBMiner-Multi/releases/download/2.6.7/SRBMiner-Multi-2-6-7-Linux.tar.gz
tar -vxf SRBMiner-Multi-2-6-7-Linux.tar.gz

mkdir -p /al && cd /al
wget https://public-download-ase1.s3.ap-southeast-1.amazonaws.com/aleo-miner/aleominer-3.0.14.tar.gz
tar -xvzf aleominer-3.0.14.tar.gz

supervisorctl reload
