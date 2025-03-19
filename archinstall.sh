#!/bin/bash

# Archlinux Install script by Trinteen 2025

############################
# VARIABLES                #
############################

#=> Defines system drive:
export V_SYS_HD="/dev/sda"

#=> Defines partitions:
export V_BOOT_SIZE="512"
export V_SWAP_SIZE="8000"

#=> Defines county:
export V_COUNTRY="CZ"

#=> Defines timezone:
export V_TIMEZONE="Europe/Prague"

#=> Defines language system:
export V_LANGUAGE="cs_CZ"

#=> Defines keyboard layout:
export V_KEYMAP="cz"

#=> Defines hostname:
export V_HOSTNAME="archlinux"

#=> Defines ROOT password:
export V_ROOT_PWD="root"

#=> Defines user accont:
export V_USER_NAME="user"
export V_USER_PASS="user"

#=> Defines GUI desktop (kde, cinnamon, gnome, xfce, i3):
export V_GUI_SEL=""

#=> Defines extra packages:
export V_EXTRA_PKG="zip unzip unrar"

#=> Defines AUR packages (TESTING):
export V_AUR_PKG=("")

#=> Defines CPU microcode:
# intel = Intel CPUs
# amd   = AMD CPUs
export V_CPU_TYPE="intel"

#=> Defines GPU driver:
# amd           = ATI/AMD (open source)
# intel         = Intel (open source)
# nvidia-new    = Nvidia (Turing+)
# nvidia-open   = Nvidia (open source)
# nvidia        = Nvidia (proprietary)
# vm            = VMWare / VirtualBox
export V_GPU_SEL="intel"

#=> Enable my services:
export V_SERVICES_MY=("")

############################
# SCRIPT                   #
############################

#ERROR (logging)
error_log(){
    echo -e "\e[31mERROR: $1\e[0m" >&2
    echo "[$(date '+%d.%m.%Y %H:%M:%S')] ERROR: $1" >> errors.log
    exit 1
}

#=> CPU Microcode:
if [[ ${V_CPU_TYPE} == "intel" ]]; then
    export V_CPU_UCODE="intel-ucode"
else
    export V_CPU_UCODE="amd-ucode"
fi

#=> GPU Select:
if  [[ ${V_GPU_SEL} == "amd" ]]; then
    export V_GPU="libva-mesa-driver mesa vulkan-radeon xf86-video-amdgpu xf86-video-ati xorg-server xorg-xinit"
elif [[ ${V_GPU_SEL} == "intel" ]]; then
    export V_GPU="intel-media-driver libva-intel-driver mesa vulkan-intel xorg-server xorg-xinit"
elif [[ ${V_GPU_SEL} == "nvida-new" ]]; then
    export V_GPU="dkms nvidia-open nvidia-open-dkms xorg-server xorg-xinit"
elif [[ ${V_GPU_SEL} == "nvidia-open" ]]; then
    export V_GPU="libva-mesa-driver mesa xf86-video-nouveau xorg-server xorg-xinit"
elif [[ ${V_GPU_SEL} == "nvidia" ]]; then
    export V_GPU="dkms nvidia-dkms xorg-server xorg-xinit"
elif [[ ${V_GPU_SEL} == "vm" ]]; then
    export V_GPU="mesa xf86-video-vmware xorg-server xorg-xinit"
fi

#=> GUI Select:
if [[ ${V_GUI_SEL} == "kde" ]]; then
    export V_GUI="ark dolphin kate kitty plasma plasma-workspace kde-applications sddm"
    export V_SERVICES=("sddm.service ${V_SERVICES_MY}")
elif [[ ${V_GUI_SEL} == "cinnamon" ]]; then
    export V_GUI="blueman bluez-utils cinnamon cinnamon-translations engrampa gnome-keyring gnome-screenshot kitty gvfs-smb system-config-printer xdg-user-dirs-gtk xed lightdm lightdm-gtk-greeter"
    export V_SERVICES=("lightdm.sevice ${V_SERVICES_MY}")
elif [[ ${V_GUI_SEL} == "gnome" ]]; then
    export V_GUI="gnome gnome-tweaks gdm gnome-keyring gvfs gvfs-smb kitty"
    export V_SERVICES=("gdm.service ${V_SERVICES_MY}")
elif [[ ${V_GUI_SEL} == "xfce" ]]; then
    export V_GUI="gvfs xarchiver kitty xfce4 xfce4-goodies xfce4-screenshooter xfce4-screensaver xfce4-power-manager system-config-printer pavucontrol xfce4-places-plugin xfce4-mixer gnome-keyring lightdm lightdm-gtk-greeter"
    export V_SERVICES=("lightdm.sevice ${V_SERVICES_MY}")
elif [[ ${V_GUI_SEL} == "i3" ]]; then
    export V_GUI="kitty dmenu i3-wm i3blocks i3lock i3status xss-lock xterm lightdm lightdm-gtk-greeter"
    export V_SERVICES=("lightdm.sevice ${V_SERVICES_MY}")
fi

#=> Type drive:
if grep -q "nvme" <<< "${V_SYS_HD}"; then
    export V_SYS_HD_TYPE="p"
    export V_SYS_HD_TYPENAME="NVME"
else
    export V_SYS_HD_TYPE=""
    export V_SYS_HD_TYPENAME="SATA"
fi

#=> TimeDateCtl NTP:
echo "=> 1. NTP = Enabled"
timedatectl set-ntp true 2> /dev/null || error_log "Timedatectl ntp problem."

#=> Keyboard layout:
echo "=> 2. KEYMAP = ${V_KEYMAP}"
loadkeys ${V_KEYMAP} 2> /dev/null || error_log "Keymap problem."

#=> Initialization:
echo "=> 3. SETUP PARTITIONS = ${V_SYS_HD} [type:${V_SYS_HD_TYPENAME}]"

    #=> Help math partition:
    P_B_S=1
    P_B_E=$(($P_B_S+$V_BOOT_SIZE))
    P_S_S=$(($P_B_E))
    P_S_E=$(($P_S_S+$V_SWAP_SIZE))
    P_R_S=$(($P_S_E))

    #=> Clearing system drive:
    echo ":: Clearing system drive.."
    parted -s ${V_SYS_HD} mklabel GPT 2> /dev/null || error_log "Create drive: GPT problem."

    #=> Create EFI partition:
    echo ":: Create EFI partition"
    parted -s ${V_SYS_HD} mkpart primary fat32 ${P_B_S} ${P_B_E} 2> /dev/null || error_log "Create drive: EFI partition problem."
    parted -s ${V_SYS_HD} set 1 boot on 2> /dev/null || error_log "Create drive: EFI partition problem = set boot."

    #=> Create SWAP partition:
    echo ":: Create SWAP partition"
    parted -s ${V_SYS_HD} mkpart primary linux-swap ${P_S_S} ${P_S_E} 2> /dev/null || error_log "Create drive: SWAP partition problem."

    #=> Create ROOT partition:
    echo ":: Create ROOT partition"
    parted -s -- ${V_SYS_HD} mkpart primary ${V_ROOT_FS} ${P_R_S} -0 2> /dev/null || error_log "Create drive: ROOT partition problem."

    #=> Format partitions:
    echo ":: Format EFI partition"
    mkfs.fat -F 32 -n ARCH_EFI ${V_SYS_HD}${V_SYS_HD_TYPE}1 2> /dev/null || error_log "Create drive: Formating EFI partition problem."
    echo ":: Format ROOT partition"
    mkfs.btrfs -f -L ARCH_ROOT ${V_SYS_HD}${V_SYS_HD_TYPE}3 2> /dev/null || error_log "Create drive: Formating ROOT partition problem."

    #=> Activation SWAP:
    echo ":: Activation SWAP partition"
    mkswap ${V_SYS_HD}${V_SYS_HD_TYPE}2 || error_log "Create drive: Make SWAP problem."
    swapon ${V_SYS_HD}${V_SYS_HD_TYPE}2 || error_log "Create drive: Make SWAP (activate) problem."

#=> Mounting partitions:
echo "=> 4. MOUNTING PARTITIONS = ${V_SYS_HD} [type:${V_SYS_HD_TYPENAME}]"

    #=> Mount ROOT partition:
    echo ":: Mount ROOT partition to /mnt"
    mount ${V_SYS_HD}${V_SYS_HD_TYPE}3 /mnt || error_log "Mouting ROOT to /mnt problem."

    #=> Btrfs:
    btrfs sub create /mnt/@ || error_log "Create BTRFS (sub @) problem."
    btrfs sub create /mnt/@home || error_log "Create BTRFS (sub @home) problem."
    umount /mnt || error_log "Umounting /mnt problem."
    mount -o noatime,nodiratime,compress=zstd,space_cache=v2,ssd,subvol=@ ${V_SYS_HD}${V_SYS_HD_TYPE}3 /mnt || error_log "Mount (sub @) to /mnt problem."
    mkdir -p /mnt/home || error_log "Create @home dir to /mnt/home"
    mount -o noatime,nodiratime,compress=zstd,space_cache=v2,ssd,subvol=@home ${V_SYS_HD}${V_SYS_HD_TYPE}3 /mnt/home || error_log "Mount (sub @home) to /mnt/home problem."

    #=> Mount BOOT partition:
    echo ":: Mount BOOT partition to /mnt/boot"
    mkdir -p /mnt/boot || error_log "Mount BOOT partition (create dir problem)."
    mount ${V_SYS_HD}${V_SYS_HD_TYPE}1 /mnt/boot || error_log "Mount BOOT partition to /mnt/boot problem."

#=> Installing system:
echo "=> 5. INSTALLING NEW SYSTEM TO ${V_SYS_HD}"

    #=> Pacman setting before install:
    echo ":: Update mirrorlist for country: ${V_COUNTRY}"
    pacman --noconfirm --needed -Sy pacman-contrib || error_log "PACMAN install pacman.contrib problem."
    curl -s "https://archlinux.org/mirrorlist/?country=${V_COUNTRY}&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors - > /etc/pacman.d/mirrorlist || error_log "PACMAN generate mirrorlist problem."

    #=> Run pacstrap:
    echo ":: Downloading packages for NEW SYSTEM"
    pacstrap /mnt base btrfs-progs wget base-devel cups linux linux-headers linux-firmware nano git mc avahi samba smbclient gvfs gvfs-smb xorg fish networkmanager network-manager-applet efibootmgr wireless_tools wpa_supplicant os-prober mtools ${V_GPU} ${V_CPU_UCODE} ${V_GUI} || error_log "Install base system problem."

    #=> Generate new FSTAB:
    echo ":: Generate new FSTAB file"
    genfstab -p -U /mnt >> /mnt/etc/fstab 2> /dev/null || error_log "Generate FSTAB problem."

#=> Post settings in chroot:
echo "=> 6. Post-install chroot settings"

    #=> Set localtime:
    echo ":: Set localtime = ${V_TIMEZONE}"
    arch-chroot /mnt bash -c "ln -sf /usr/share/zoneinfo/${V_TIMEZONE} /etc/localtime && hwclock --systohc" 2> /dev/null || error_log "Set TIMEZONE problem."

    #=> Set language:
    echo ":: Set language = ${V_LANGUAGE}"
    arch-chroot /mnt bash -c "sed -i 's/#${V_LANGUAGE}.UTF-8 UTF-8/${V_LANGUAGE}.UTF-8 UTF-8/' /etc/locale.gen && locale-gen > /dev/null && echo 'LANG=${V_LANGUAGE}.UTF-8' > /etc/locale.conf && echo 'KEYMAP=${V_KEYMAP}' > /etc/vconsole.conf" 2> /dev/null || error_log "Set LANGUAGE problem."

    #=> Set hostname:
    echo ":: Set hostname = ${V_HOSTNAME}"
    arch-chroot /mnt bash -c "echo '${V_HOSTNAME}' > /etc/hostname && echo -e '\n127.0.0.1       localhost\n::1             localhost\n127.0.1.1       ${V_HOSTNAME}.localdomain ${V_HOSTNAME}' >> /etc/hosts" 2> /dev/null || error_log "Set HOSTNAME problem."

    #=> Set new ROOT password:
    echo ":: Set ROOT password = ${V_ROOT_PWD}"
    arch-chroot /mnt bash -c "echo 'root:'${V_ROOT_PWD}'' | chpasswd" 2> /dev/null || error_log "Set ROOT password problem."

    #=> Create user:
    echo ":: Create new user = ${V_USER_NAME}:${V_USER_PASS}"
    arch-chroot /mnt bash -c "useradd -m ${V_USER_NAME} && echo "${V_USER_NAME}:${V_USER_PASS}" | chpasswd && usermod -aG wheel,audio,video,optical,storage,games -s /usr/bin/fish ${V_USER_NAME}" 2> /dev/null || error_log "Create user problem."

    #=> Install sudo & setup:
    echo ":: Install SUDO and configure"
    arch-chroot /mnt bash -c "pacman -S --noconfirm sudo > /dev/null && echo -e '%wheel ALL=(ALL) ALL\nDefaults rootpw' > /etc/sudoers.d/99_wheel" 2> /dev/null || error_log "Install/Configuration SUDO problem."

    #=> Configuration X11:
    echo ":: Configuration X11"
    arch-chroot /mnt bash -c "echo -e 'Section \"InputClass\" \n Identifier \"system-keyboard\" \n MatchIsKeyboard \"on\" \n Option \"XkbLayout\" \"'${V_KEYMAP}'\" \n EndSection' > /etc/X11/xorg.conf.d/00-keyboard.conf" 2> /dev/null || error_log "Keyboard settings problem."

    #=> Set DHCP network:
    echo ":: Set DHCP for network"
    arch-chroot /mnt bash -c "sed 's/^# interface=/interface=eth0/' /etc/rc.conf > /etc/rc.conf" 2> /dev/null || error_log "Network settings problem."

    #=> Setup initial ramdisk environment
    echo ":: Setup initial ramdisk environment"
    arch-chroot /mnt bash -c "sed -i 's/filesystems fsck/btrfs filesystems/g' /etc/mkinitcpio.conf" 2> /dev/null || error_log "Change MKINITCPIO filesystem problem."
    arch-chroot /mnt bash -c "mkinitcpio -p linux" 2> /dev/null || error_log "Building MKINITCPIO problem."

    #=> Setup SystemD-Boot:
    echo ":: Configuration Systemd-boot"
    arch-chroot /mnt bash -c "bootctl --path=/boot install" 2> /dev/null || error_log "Install Systemd-Boot problem."
    arch-chroot /mnt bash -c "echo -e 'title Arch Linux' >> /boot/loader/entries/arch.conf" 2> /dev/null || error_log "Systemd-Boot configuration problem."
    arch-chroot /mnt bash -c "echo -e 'linux /vmlinuz-linux' >> /boot/loader/entries/arch.conf" 2> /dev/null || error_log "Systemd-Boot configuration problem."
    arch-chroot /mnt bash -c "echo -e 'initrd  /initramfs-linux.img' >> /boot/loader/entries/arch.conf" 2> /dev/null || error_log "Systemd-Boot configuration problem."
    UUID_DISK=$(blkid -s UUID -o value ${V_SYS_HD}${V_SYS_HD_TYPE}3)
    arch-chroot /mnt bash -c "echo -e 'options root=UUID=${UUID_DISK} rootflags=subvol=@ rw' >> /boot/loader/entries/arch.conf" 2> /dev/null || error_log "Systemd-Boot configuration problem."

    #=> Makepkg
    echo ":: Edit MAKEPKG"
    arch-chroot /mnt bash -c "sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/g' /etc/makepkg.conf" 2> /dev/null || error_log "MAKEPKG configuration problem."
    
    #=> Enabled multilib:
    if [ "$(uname -m)" = "x86_64" ];then
        echo ":: Enable MULTILIB repo in PACMAN"
        arch-chroot /mnt bash -c "echo -e '[multilib]\nInclude = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf" 2> /dev/null || error_log "PACMAN enable multilib repo problem."
    fi

    #=> Enable Chaotic-aur
    echo ":: Enable chaotic-aur repo"
    arch-chroot /mnt bash -c "pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com" 2> /dev/null || error_log "Chaotic-Aur enable keyring problem."
    arch-chroot /mnt bash -c "pacman-key --lsign-key 3056513887B78AEB" 2> /dev/null || error_log "Chaotic-Aur enable keyring problem."
    arch-chroot /mnt bash -c "pacman --noconfirm -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'" 2> /dev/null || error_log "Chaotic-Aur install problem."
    arch-chroot /mnt bash -c "echo -e '[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf" 2> /dev/null || error_log "Chaotic-Aur adding repo to PACMAN problem."

    #=> Paru AUR Helper
    echo ":: Install extra packages"
    arch-chroot /mnt bash -c "pacman --noconfirm --needed -Sy paru" 2> /dev/null || error_log "Install PARU problem."

    #=> Pacman config edit:
    echo ":: Pacman config edit"
    arch-chroot /mnt bash -c "sed -i 's/^#ParallelDownloads/ParallelDownloads/g' /etc/pacman.conf" 2> /dev/null || error_log "PACMAN configuration problem."
    arch-chroot /mnt bash -c "sed -i 's/^#Color/Color/g' /etc/pacman.conf" 2> /dev/null || error_log "PACMAN configuration problem."
    arch-chroot /mnt bash -c "sed -i 's/VerbosePkgLists/VerbosePkgLists\nILoveCandy/g' /etc/pacman.conf" 2> /dev/null || error_log "PACMAN configuration problem."
    arch-chroot /mnt bash -c "sed -i 's/^#VerbosePkgLists/VerbosePkgLists\n/g' /etc/pacman.conf" 2> /dev/null || error_log "PACMAN configuration problem."

    #=> Extra packages:
    echo ":: Install extra packages"
    arch-chroot /mnt bash -c "pacman --noconfirm --needed -Sy ${V_EXTRA_PKG}" 2> /dev/null || error_log "PACMAN install EXTRA PACKAGES problem."

    #=> Install AUR packages:
    echo ":: Install AUR packages"
    V_AUR_PKG+=("mkinitcpio-firmware")
    arch-chroot /mnt bash -c "echo -e 'root ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/root" 2> /dev/null || error_log "PARU nopasswd configuration for ROOT user problem."
    arch-chroot /mnt bash -c "echo -e '${V_USER_NAME} ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/${V_USER_NAME}" 2> /dev/null || error_log "PARU nopasswd configuration for NORMAL user problem." 
    for aur in ${V_AUR_PKG[@]}; do
        echo ${aur}
        arch-chroot -u ${V_USER_NAME} /mnt bash -c "paru --noconfirm --needed -S ${aur}" 2> /dev/null  || error_log "PARU install packages: ${aur} problem."
    done
    arch-chroot /mnt bash -c "rm -rf /etc/sudoers.d/root" 2> /dev/null || error_log "PARU nopasswd configuration for ROOT user (remove) problem."
    arch-chroot /mnt bash -c "rm -rf /etc/sudoers.d/${V_USER_NAME}" 2> /dev/null || error_log "PARU nopasswd configuration for NORMAL user (remove) problem."

    #=> Enable my services:
    echo ":: Enable services"
    for enable_services in ${V_SERVICES[@]}; do
        echo ${enable_services}
        arch-chroot /mnt bash -c "systemctl enable ${enable_services}" 2> /dev/null || error_log "Enable service ${enable_services} problem."
    done

    #=> Enable services:
    arch-chroot /mnt bash -c "systemctl enable NetworkManager.service" 2> /dev/null || error_log "Enable service NetworkManager problem."
    arch-chroot /mnt bash -c "systemctl enable cups.service" 2> /dev/null || error_log "Enable service CUPS problem."
    arch-chroot /mnt bash -c "systemctl enable avahi-daemon.service" 2> /dev/null || error_log "Enable service AVAHI-DEAMON problem."
    arch-chroot /mnt bash -c "systemctl enable smb.service" 2> /dev/null || error_log "Enable service SMB problem."
    
    #=> Exit chroot:
    arch-chroot /mnt bash -c "exit" || error_log "Not EXIT chroot problem."

#=> Umount disk & reboot system:
echo "=> 7. Umount ${V_SYS_HD} & reboot system..."
    
    #=> umount disk:
    umount -l /mnt 2> /dev/null || error_log "Umount All partition after instalation problem."

    #=> reboot system:
    sleep 10 && reboot || error_log "Script dont reboot system."
