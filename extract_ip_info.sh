#!/bin/bash

log_file="auth/log.txt"
output_file="auth/ip.txt"

mkdir -p auth

if [[ ! -f "$log_file" ]]; then
    echo "Log file not found: $log_file"
    exit 1
fi

# Estrae IP e User-Agent (assumendo un log strutturato tipo: IP|User-Agent)
ip=$(cut -d'|' -f1 "$log_file")
ua=$(cut -d'|' -f2- "$log_file")

# Richiesta info geolocalizzazione via ip-api.com (usa solo IP)
geo_info=$(curl -s "http://ip-api.com/json/$ip")

country=$(echo "$geo_info" | grep -oP '"country"\s*:\s*"\K[^"]+')
region=$(echo "$geo_info" | grep -oP '"regionName"\s*:\s*"\K[^"]+')
city=$(echo "$geo_info" | grep -oP '"city"\s*:\s*"\K[^"]+')
isp=$(echo "$geo_info" | grep -oP '"isp"\s*:\s*"\K[^"]+')

echo -e "[+] Victim IP   : $ip" > "$output_file"
echo -e "[+] User-Agent  : $ua" >> "$output_file"
echo -e "[+] Country     : $country" >> "$output_file"
echo -e "[+] Region      : $region" >> "$output_file"
echo -e "[+] City        : $city" >> "$output_file"
echo -e "[+] ISP         : $isp" >> "$output_file"

echo "[*] Info saved in: $output_file"
