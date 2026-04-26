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

wget -q -O "$DEST" "$URL" 2>/dev/null

FILES=$(find /userdata/system/configs/emulationstation /usr/share/emulationstation \
    -name "es_systems*.cfg" 2>/dev/null)

for FILE in $FILES; do
    if grep -q "<n>ps3</n>" "$FILE"; then
        python3 - "$FILE" <<'PYEOF' 2>/dev/null
import sys
import xml.etree.ElementTree as ET

filepath = sys.argv[1]
tree = ET.parse(filepath)
root = tree.getroot()

changed = False
for system in root.findall('system'):
    name = system.find('name')
    if name is None or name.text != 'ps3':
        continue
    ext = system.find('extension')
    if ext and '.iso' not in ext.text:
        ext.text = ext.text.rstrip() + ' .iso'
        changed = True

if changed:
    tree.write(filepath, encoding='unicode', xml_declaration=False)
PYEOF
    fi
done

batocera-save-overlay 250 &>/dev/null

# Cores
ROXO='\033[0;35m'
ROXOB='\033[1;35m'
VERDE='\033[0;32m'
VERDEB='\033[1;32m'
LARANJA='\033[0;33m'
LARONJAB='\033[1;33m'
BRANCO='\033[1;37m'
RESET='\033[0m'
BOLD='\033[1m'

clear

# === PACMAN ANIMATION ===
TRACK="····················♥···············································"
TRACK_LEN=${#TRACK}

echo ""
echo -e "  ${ROXOB}♪ JC GAMES CLASSICOS 2026 FOR UP! ♪${RESET}"
echo ""

for i in $(seq 0 $((TRACK_LEN - 1))); do
    # Pacman abre/fecha boca
    if (( i % 2 == 0 )); then
        PAC="${LARONJAB}ᗧ${RESET}"
    else
        PAC="${LARONJAB}ᗣ${RESET}"
    fi

    # Trilha: dots antes e depois do pacman
    BEFORE="${TRACK:$i}"
    AFTER=""
    for j in $(seq 1 $i); do AFTER="${AFTER} "; done

    printf "\r  ${VERDE}${AFTER}${PAC}${ROXO}${BEFORE}${RESET}  "
    sleep 0.07
done

echo ""
echo ""
sleep 0.3

# === BARRA DE PROGRESSO ===
echo -e "  ${ROXOB}Finalizando instalacao...${RESET}"
echo ""

BAR=""
for i in $(seq 1 40); do
    BAR="${BAR}█"
    EMPTY=$(printf '%*s' $((40 - i)) '')
    PCT=$(( i * 100 / 40 ))
    printf "\r  ${LARANJA}[${VERDEB}%s${LARANJA}%s]${RESET} ${VERDEB}%d%%${RESET}" "$BAR" "$EMPTY" "$PCT"
    sleep 0.06
done

echo ""
sleep 0.4
clear

# === CREDITOS ===
echo ""
sleep 0.2
echo -e "${ROXOB}  ╔══════════════════════════════════════════╗${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║                                          ║${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║   ${VERDEB}✔  Instalacao concluida com sucesso!${ROXOB}   ║${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║                                          ║${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║   ${BRANCO}Seus jogos .iso de PS3 ja aparecem${ROXOB}     ║${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║   ${BRANCO}no EmulationStation e rodam no RPCS3.${ROXOB}  ║${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║                                          ║${RESET}"
sleep 0.3
echo -e "${ROXOB}  ╠══════════════════════════════════════════╣${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║                                          ║${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║   ${LARONJAB}★  Contribuir com o projeto:${ROXOB}           ║${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║   ${LARONJAB}PayPal: jcgamesclassicos@gmail.com${ROXOB}     ║${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║                                          ║${RESET}"
sleep 0.3
echo -e "${ROXOB}  ╠══════════════════════════════════════════╣${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║                                          ║${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║   ${VERDEB}@JCGAMESCLASSICOS${ROXOB}                      ║${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║   ${VERDEB}WhatsApp: 41 998205080${ROXOB}                 ║${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║                                          ║${RESET}"
sleep 0.2
echo -e "${ROXOB}  ╚══════════════════════════════════════════╝${RESET}"
echo ""

# Pacman passando embaixo dos creditos
for i in $(seq 0 44); do
    if (( i % 2 == 0 )); then PAC="${LARONJAB}ᗧ${RESET}"; else PAC="${LARONJAB}ᗣ${RESET}"; fi
    SPACES=$(printf '%*s' $i '')
    printf "\r  ${SPACES}${PAC}"
    sleep 0.06
done
echo ""
echo ""

# Contador regressivo
for i in $(seq 5 -1 1); do
    printf "\r  ${LARONJAB}Fechando em ${VERDEB}%2d${LARONJAB} segundos...  ${LARONJAB}ᗧ··${RESET}" "$i"
    sleep 1
done

echo ""
echo ""
