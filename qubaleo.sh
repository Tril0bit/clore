#!/bin/bash

apt update -y
apt install wget -y
wget --no-check-certificate 'https://github.com/Tril0bit/clore/releases/download/qubaleo/qubaleo.sh' -O qubaleo.sh && chmod u+x qubaleo.sh && bash ./qubaleo.sh
