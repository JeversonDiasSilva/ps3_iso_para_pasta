#!/bin/bash
# Curitiba 12 de Abril de 2025
# Editor Jeverson Dias da Silva...........Youtube/@JCGAMESCLASSICOS


echo 'Baixando atualização para o sistema Sony PlayStation 3 "ps3"'

# Baixar o arquivo, ocultando a saída
curl -L https://raw.githubusercontent.com/JeversonDiasSilva/ps3_iso_para_pasta/main/XPS3 -o /usr/bin/XPS3 > /dev/null 2>&1

# Tornar executável, ocultando a saída
chmod +x /usr/bin/XPS3 > /dev/null 2>&1

# Salvar overlay no Batocera
batocera-save-overlay > /dev/null 2>&1

