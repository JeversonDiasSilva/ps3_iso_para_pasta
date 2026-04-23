#!/bin/bash


VER=$(batocera-version | sed 's/[^0-9].*//')

case "$VER" in
  40)
    URL="https://raw.githubusercontent.com/JeversonDiasSilva/ps3_iso_para_pasta/refs/heads/main/ps3-40/rpcs3Generator.py"
    DEST="/caminho/da/v40/rpcs3Generator.py"
    ;;
  41)
    URL="LINK_41"
    DEST="/caminho/da/v41/rpcs3Generator.py"
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

echo "Versão detectada: $VER"
echo "Destino: $DEST"

wget -q -O "$DEST" "$URL"

if [ $? -eq 0 ]; then
  echo "Download concluído!"
else
  echo "Erro no download!"
fi

# Procura e atualiza es_systems*.cfg adicionando .iso para o sistema ps3

FILES=$(find /userdata/system/configs/emulationstation /usr/share/emulationstation \
    -name "es_systems*.cfg" 2>/dev/null)

if [ -z "$FILES" ]; then
    echo "Nenhum arquivo es_systems*.cfg encontrado."
    exit 1
fi

for FILE in $FILES; do
    echo "Verificando: $FILE"

    # Checa se tem o bloco do ps3
    if ! grep -q "<name>ps3</name>" "$FILE"; then
        echo "  -> Sem bloco ps3, pulando."
        continue
    fi

    # Checa se .iso já está presente na tag <extension> do bloco ps3
    # Usa python para fazer a edição com segurança no XML
    python3 - "$FILE" <<'PYEOF'
import sys
import xml.etree.ElementTree as ET

filepath = sys.argv[1]

# Preservar formatação original o máximo possível
with open(filepath, 'r') as f:
    content = f.read()

tree = ET.parse(filepath)
root = tree.getroot()

changed = False
for system in root.findall('system'):
    name = system.find('name')
    if name is None or name.text != 'ps3':
        continue
    ext = system.find('extension')
    if ext is None:
        print(f"  -> Bloco ps3 sem tag <extension>, pulando.")
        continue
    if '.iso' in ext.text:
        print(f"  -> .iso já presente, nada a fazer.")
    else:
        ext.text = ext.text.rstrip() + ' .iso'
        changed = True
        print(f"  -> .iso adicionado: {ext.text}")

if changed:
    tree.write(filepath, encoding='unicode', xml_declaration=False)
    print(f"  -> Arquivo salvo.")
PYEOF

done

echo ""
echo "Concluído."

batocera-save-overlay 250
