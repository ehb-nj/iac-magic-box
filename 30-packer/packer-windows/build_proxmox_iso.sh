#!/bin/bash

# transform files into iso, because proxmox only accept iso and no floppy A:\
echo "[+] Build iso winserver2016 with cloudinit"
mkisofs -J -l -R -V "autounatend CD" -iso-level 4 -o ./iso/Autounattend_winserver2016_cloudinit.iso answer_files/2016_proxmox_cloudinit
sha_winserv2016=$(sha256sum ./iso/Autounattend_winserver2016_cloudinit.iso|cut -d ' ' -f1)
echo "[+] update windows_server2016_proxmox_cloudinit.pkvars.hcl"
sed -i.bak "s/autounattend_checksum = \"sha256:.*\"/autounattend_checksum = \"sha256:$sha_winserv2016\"/g" windows_server2016_proxmox_cloudinit.pkvars.hcl

echo "[+] Build iso winserver2019 with cloudinit"
mkisofs -J -l -R -V "autounatend CD" -iso-level 4 -o ./iso/Autounattend_winserver2019_cloudinit.iso answer_files/2019_proxmox_cloudinit
sha_winserv2019=$(sha256sum ./iso/Autounattend_winserver2019_cloudinit.iso|cut -d ' ' -f1)
echo "[+] update windows_server2019_proxmox_cloudinit.pkvars.hcl"
sed -i.bak "s/autounattend_checksum = \"sha256:.*\"/autounattend_checksum = \"sha256:$sha_winserv2019\"/g" windows_server2019_proxmox_cloudinit.pkvars.hcl

echo "[+] Build iso winserver2022 with cloudinit"
mkisofs -J -l -R -V "autounatend CD" -iso-level 4 -o ./iso/Autounattend_winserver2022_cloudinit.iso answer_files/2022_proxmox_cloudinit
sha_winserv2022=$(sha256sum ./iso/Autounattend_winserver2022_cloudinit.iso|cut -d ' ' -f1)
echo "[+] update windows_server2022_proxmox_cloudinit.pkvars.hcl"
sed -i.bak "s/autounattend_checksum = \"sha256:.*\"/autounattend_checksum = \"sha256:$sha_winserv2022\"/g" windows_server2022_proxmox_cloudinit.pkvars.hcl

echo "[+] Build iso win10 with cloudinit"
mkisofs -J -l -R -V "autounatend CD" -iso-level 4 -o ./iso/Autounattend_win10_cloudinit.iso answer_files/10_proxmox_cloudinit
sha_win10=$(sha256sum ./iso/Autounattend_win10_cloudinit.iso|cut -d ' ' -f1)
echo "[+] update windows_10_proxmox_cloudinit.pkvars.hcl"
sed -i.bak "s/autounattend_checksum = \"sha256:.*\"/autounattend_checksum = \"sha256:$sha_win10\"/g" windows_10_proxmox_cloudinit.pkvars.hcl

echo "[+] Build iso win11 with cloudinit"
mkisofs -J -l -R -V "autounatend CD" -iso-level 4 -o ./iso/Autounattend_win11_cloudinit.iso answer_files/11_proxmox_cloudinit
sha_win11=$(sha256sum ./iso/Autounattend_win11_cloudinit.iso|cut -d ' ' -f1)
echo "[+] update windows_11_proxmox_cloudinit.pkvars.hcl"
sed -i.bak "s/autounattend_checksum = \"sha256:.*\"/autounattend_checksum = \"sha256:$sha_win11\"/g" windows_11_proxmox_cloudinit.pkvars.hcl

echo "[+] Build iso for scripts"
mkisofs -J -l -R -V "scripts CD" -iso-level 4 -o ./iso/scripts_withcloudinit.iso scripts
sha_scripts=$(sha256sum ./iso/scripts_withcloudinit.iso|cut -d ' ' -f1)
echo "[+] update all file *.hcl"
find . -type f -name "*proxmox_cloudinit*.pkvars.hcl" -print0 | xargs -0 sed -i.bak "s/scripts_checksum      = \"sha256:.*\"/scripts_checksum      = \"sha256:$sha_scripts\"/g"

# echo "scripts_withcloudinit.iso"
# sha256sum ./iso/scripts_withcloudinit.iso
