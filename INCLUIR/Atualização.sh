#!/bin/bash
# Baixar a versão mais recente
URL=$(curl -s https://api.github.com/repos/RPCS3/rpcs3-binaries-linux/releases/latest \
  | grep "browser_download_url" | grep "AppImage" | cut -d '"' -f 4)

wget --show-progress -O /usr/bin/rpcs3 "$URL"

chmod +x /usr/bin/rpcs3

# Instalar firmwares
wget -q -O --show-progress -O /tmp/dev_flash_firmware.tar.gz   https://github.com/JeversonDiasSilva/ps3_iso_para_pasta/releases/download/1.0/dev_flash_firmware.tar.gz
tar -xzf /tmp/dev_flash_firmware.tar.gz -C /userdata/system/configs/rpcs3/ > /dev/null 2>&1


######
## batocera-save-overlay 250
