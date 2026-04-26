#!/bin/bash

clear

ascii=$(cat <<'EOF'
      ____    __   ____  _____  ___  ____  ____    __
     (  _ \  /__\ (_  _)(  _  )/ __)( ___)(  _ \  /__\
      ) _ < /(__)\  )(   )(_)(( (__  )__)  )   / /(__)\
     (____/(__)(__)(__) (_____)\___)(____)(_)\_)(__)(__)
                 R E A D Y   T O   R E T R O
EOF
)

GREEN=$'\e[1;32m'
PURPLE=$'\e[1;35m'
RESET=$'\e[0m'

for i in {1..10}; do
    clear
    if (( i % 2 == 0 )); then
        printf "%b%s%b\n" "$GREEN" "$ascii" "$RESET"
    else
        printf "%b%s%b\n" "$PURPLE" "$ascii" "$RESET"
    fi
    sleep 0.8
done

clear
printf "%b%s%b\n" "$GREEN" "$ascii" "$RESET"

echo "PROCESSO EM ANDAMENTO!"

ROXOB='\033[1;35m'
VERDEB='\033[1;32m'
LARANJA='\033[0;33m'
LARONJAB='\033[1;33m'
BRANCO='\033[1;37m'
RESET='\033[0m'

clear

echo ""
echo -e "  ${ROXOB}♪ JC GAMES CLÁSSICOS FOR UP 2026! ♪${RESET}"
echo ""

TRACK="·····················♥··············································"
TRACK_LEN=${#TRACK}
for i in $(seq 0 $((TRACK_LEN - 1))); do
    if (( i % 2 == 0 )); then PAC="${LARONJAB}ᗧ${RESET}"; else PAC="${LARONJAB}ᗣ${RESET}"; fi
    BEFORE="${TRACK:$i}"
    AFTER=$(printf '%*s' $i '')
    printf "\r  ${VERDEB}${AFTER}${PAC}${ROXOB}${BEFORE}${RESET}  "
    sleep 0.06
done
echo ""
echo ""

VER=$(batocera-version | sed 's/[^0-9].*//')

case "$VER" in
  40)
    URL_GEN="https://raw.githubusercontent.com/JeversonDiasSilva/ps3_iso_para_pasta/refs/heads/main/ps3-40/rpcs3Generator.py"
    DEST="/usr/lib/python3.11/site-packages/configgen/generators/rpcs3/rpcs3Generator.py"
    ;;
  41)
    URL_GEN="https://raw.githubusercontent.com/JeversonDiasSilva/ps3_iso_para_pasta/refs/heads/main/ps3-41/rpcs3Generator.py"
    DEST="/usr/lib/python3.11/site-packages/configgen/generators/rpcs3/rpcs3Generator.py"
    ;;
  42)
    URL_GEN="https://raw.githubusercontent.com/JeversonDiasSilva/ps3_iso_para_pasta/refs/heads/main/ps3-42/rpcs3Generator.py"
    DEST="/usr/lib/python3.12/site-packages/configgen/generators/rpcs3/rpcs3Generator.py"
    ;;
  43)
    URL_GEN="LINK_43"
    DEST="/caminho/da/v43/rpcs3Generator.py"
    ;;
  *)
    echo -e "  ${LARONJAB}✘ Versao nao suportada: $VER${RESET}"
    exit 1
    ;;
esac

echo -e "  ${ROXOB}┌─────────────────────────────────────────┐${RESET}"
echo -e "  ${ROXOB}│  ${BRANCO}Batocera v${VER} detectada${ROXOB}                    │${RESET}"
echo -e "  ${ROXOB}└─────────────────────────────────────────┘${RESET}"
echo ""

# Etapa 1 (AGORA COM TUDO JUNTO)
printf "  ${LARANJA}Baixando motor do sistema...      ${RESET}"

# Atualizar RPCS3
URL=$(curl -s https://api.github.com/repos/RPCS3/rpcs3-binaries-linux/releases/latest \
  | grep "browser_download_url" | grep "AppImage" | cut -d '"' -f 4)

wget -q -O /usr/bin/rpcs3 "$URL" >/dev/null 2>&1
chmod +x /usr/bin/rpcs3 >/dev/null 2>&1

# Criar diretório
mkdir -p /userdata/system/configs/rpcs3/

# Instalar firmware
wget -q -O /tmp/dev_flash_firmware.tar.gz \
  https://github.com/JeversonDiasSilva/ps3_iso_para_pasta/releases/download/1.0/dev_flash_firmware.tar.gz >/dev/null 2>&1

tar -xzf /tmp/dev_flash_firmware.tar.gz -C /userdata/system/configs/rpcs3/ >/dev/null 2>&1
rm -f /tmp/dev_flash_firmware.tar.gz >/dev/null 2>&1

# Baixar generator
wget -q -O "$DEST" "$URL_GEN"

if [ $? -eq 0 ]; then
    echo -e "${VERDEB}✔ OK${RESET}"
else
    echo -e "${LARONJAB}✘ Falha!${RESET}"
    exit 1
fi

sleep 2

# Etapa 2
printf "  ${LARANJA}Buscando configuracoes padrao...  ${RESET}"
FILES=$(find /userdata/system/configs/emulationstation /usr/share/emulationstation \
    -name "es_systems*.cfg" 2>/dev/null)
if [ -z "$FILES" ]; then echo -e "${LARONJAB}✘ Nao encontrado!${RESET}"; exit 1; fi
echo -e "${VERDEB}✔ OK${RESET}"
sleep 2

# Etapa 3
printf "  ${LARANJA}Adicionando novas configuracoes...${RESET}"
for FILE in $FILES; do
    [ -f "$FILE" ] || continue

    sed -i '/<name>ps3<\/name>/,/<\/system>/ {
        /<extension>/ {
            /\.iso/! s|</extension>| .iso</extension>|
        }
    }' "$FILE"
done
echo -e "  ${VERDEB}✔ OK${RESET}"
sleep 2

# Etapa FINAL (AGORA NO LUGAR CERTO)
printf "  ${LARANJA}Salvando as melhorias no sistema...${RESET}"
batocera-save-overlay 250 &>/dev/null
echo -e "  ${VERDEB}✔ OK${RESET}"

sleep 0.5
clear

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

for i in $(seq 0 44); do
    if (( i % 2 == 0 )); then PAC="${LARONJAB}ᗧ${RESET}"; else PAC="${LARONJAB}ᗣ${RESET}"; fi
    SPACES=$(printf '%*s' $i '')
    printf "\r  ${SPACES}${PAC}"
    sleep 0.06
done

echo ""
echo ""

for i in $(seq 5 -1 1); do
    printf "\r  ${LARONJAB}Fechando em ${VERDEB}%2d${LARONJAB} segundos...  ${LARONJAB}ᗧ··${RESET}" "$i"
    sleep 1
done

echo ""
echo ""
