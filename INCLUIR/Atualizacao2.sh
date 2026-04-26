#!/bin/bash

ROXOB='\033[1;35m'
VERDEB='\033[1;32m'
LARANJA='\033[0;33m'
LARONJAB='\033[1;33m'
BRANCO='\033[1;37m'
RESET='\033[0m'

clear

# Etapa 1 - Atualizar RPCS3
printf "  ${LARANJA}Atualizando RPCS3...              ${RESET}"
URL=$(curl -s https://api.github.com/repos/RPCS3/rpcs3-binaries-linux/releases/latest \
  | grep "browser_download_url" | grep "AppImage" | cut -d '"' -f 4)
wget -q -O /usr/bin/rpcs3 "$URL" 2>/dev/null
chmod +x /usr/bin/rpcs3
echo -e "${VERDEB}✔ OK${RESET}"
sleep 2

# Etapa 2 - Instalar firmware
printf "  ${LARANJA}Instalando firmware PS3...        ${RESET}"
wget -q -O /tmp/dev_flash_firmware.tar.gz \
  https://github.com/JeversonDiasSilva/ps3_iso_para_pasta/releases/download/1.0/dev_flash_firmware.tar.gz 2>/dev/null
tar -xzf /tmp/dev_flash_firmware.tar.gz -C /userdata/system/configs/rpcs3/ 2>/dev/null
rm -f /tmp/dev_flash_firmware.tar.gz
echo -e "${VERDEB}✔ OK${RESET}"
sleep 2

# Etapa 3 - Salvar overlay
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
echo -e "${ROXOB}  ║   ${VERDEB}✔  Atualizacao concluida com sucesso!${ROXOB}  ║${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║                                          ║${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║   ${BRANCO}RPCS3 e firmware PS3 atualizados${ROXOB}      ║${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║   ${BRANCO}e prontos para uso!${ROXOB}                   ║${RESET}"
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
echo -e "${ROXOB}  ║   ${VERDEB}@JCGAMESCLASSICOS${ROXOB}                        ║${RESET}"
sleep 0.2
echo -e "${ROXOB}  ║   ${VERDEB}WhatsApp: 41 998205080${ROXOB}                   ║${RESET}"
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

for i in $(seq 15 -1 1); do
    printf "\r  ${LARONJAB}Fechando em ${VERDEB}%2d${LARONJAB} segundos...  ${LARONJAB}ᗧ··${RESET}" "$i"
    sleep 1
done

echo ""
echo ""
