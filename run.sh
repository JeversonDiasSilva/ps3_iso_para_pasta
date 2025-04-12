#!/bin/bash
# Curitiba, 12 de Abril de 2025
# Editor: Jeverson Dias da Silva - Youtube/@JCGAMESCLASSICOS

# Cores para mensagem
GREEN_BOLD="\033[1;32m"
RESET="\033[0m"

# Baixar o arquivo XPS3 para /usr/bin, tornar executável
curl -sL https://raw.githubusercontent.com/JeversonDiasSilva/ps3_iso_para_pasta/main/XPS3 -o /usr/bin/XPS3 > /dev/null 2>&1
chmod +x /usr/bin/XPS3 > /dev/null 2>&1
clear
# Substituir mimeapps.list
rm -f /userdata/system/.config/mimeapps.list > /dev/null 2>&1
curl -sL https://raw.githubusercontent.com/JeversonDiasSilva/ps3_iso_para_pasta/main/mimeapps.list -o /userdata/system/.config/mimeapps.list > /dev/null 2>&1
clear
# Substituir ou adicionar o userapp desktop
DESKTOP_PATH="/userdata/system/.local/share/applications/userapp-XPS3-BFGL42.desktop"
rm -f "$DESKTOP_PATH" > /dev/null 2>&1
curl -sL https://raw.githubusercontent.com/JeversonDiasSilva/ps3_iso_para_pasta/main/userapp-XPS3-BFGL42.desktop -o "$DESKTOP_PATH" > /dev/null 2>&1
clear
# Mensagem de atualização
echo -e "${GREEN_BOLD}Baixando atualização para o sistema Sony PlayStation 3 \"ps3\"${RESET}"
sleep 5
# Salvar overlay no Batocera
batocera-save-overlay > /dev/null 2>&1
