#!/bin/bash

VER=$(batocera-version | sed 's/[^0-9].*//')

case "$VER" in
  40)
    URL="https://raw.githubusercontent.com/JeversonDiasSilva/ps3_iso_para_pasta/refs/heads/main/ps3-40/rpcs3Generator.py"
    DEST="/usr/lib/python3.11/site-packages/configgen/generators/rpcs3/rpcs3Generator.py"
    ;;
  41)
    URL="https://raw.githubusercontent.com/JeversonDiasSilva/ps3_iso_para_pasta/refs/heads/main/ps3-41/rpcs3Generator.py"
    DEST="/usr/lib/python3.11/site-packages/configgen/generators/rpcs3/rpcs3Generator.py"
    ;;
  42)
    URL="https://raw.githubusercontent.com/JeversonDiasSilva/ps3_iso_para_pasta/refs/heads/main/ps3-42/rpcs3Generator.py"
    DEST="/usr/lib/python3.12/site-packages/configgen/generators/rpcs3/rpcs3Generator.py"
    ;;
  43)
    URL="LINK_43"
    DEST="/caminho/da/v43/rpcs3Generator.py"
    ;;
  *)
    echo "Versão não suportada: $VER"
    exit 1
    ;;
esac

echo "Baixando patch RPCS3..."
wget -q -O "$DEST" "$URL"

# ===============================
# Corrigir es_systems.cfg
# ===============================

FILES=$(find /userdata/system/configs/emulationstation /usr/share/emulationstation \
    -name "es_systems*.cfg" 2>/dev/null)

echo "Arquivos encontrados:"
echo "$FILES"
echo ""

for FILE in $FILES; do
    if grep -q "<name>ps3</name>" "$FILE"; then
        echo "Processando: $FILE"

        python3 - "$FILE" <<'PYEOF'
import sys
import xml.etree.ElementTree as ET

filepath = sys.argv[1]

try:
    tree = ET.parse(filepath)
    root = tree.getroot()
except Exception as e:
    print("Erro ao ler XML:", filepath, e)
    sys.exit(0)

changed = False

for system in root.findall('system'):
    name = system.find('name')
    if name is None or name.text != 'ps3':
        continue

    ext = system.find('extension')

    if ext is not None:
        current = (ext.text or "").strip()

        # evita duplicar
        if '.iso' not in current.split():
            ext.text = current + ' .iso'
            changed = True
            print("Adicionado .iso em:", filepath)

if changed:
    tree.write(filepath, encoding='unicode', xml_declaration=False)
else:
    print("Nenhuma alteração necessária:", filepath)
PYEOF

    else
        echo "PS3 não encontrado em: $FILE"
    fi
done

batocera-save-overlay 250 &>/dev/null

# ===============================
# VISUAL (mantive o seu)
# ===============================

ROXO='\033[0;35m'
ROXOB='\033[1;35m'
VERDE='\033[0;32m'
VERDEB='\033[1;32m'
LARANJA='\033[0;33m'
LARONJAB='\033[1;33m'
BRANCO='\033[1;37m'
RESET='\033[0m'

clear

echo ""
echo -e "  ${ROXOB}♪ JC GAMES CLASSICOS 2026 FOR UP! ♪${RESET}"
echo ""

echo -e "${VERDEB}✔ Script executado!${RESET}"
echo ""

sleep 1

echo -e "${ROXOB}✔ .ISO ativado para PS3 no EmulationStation${RESET}"
echo ""
