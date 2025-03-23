#!/bin/bash

#=> Size window:
#===============
AUTHOR_T="(c)2025 TRINTEEN - ArchLinux Install Script"
WINDOW_H=0
WINDOW_W=0
WINDOW_L=0

#=> Modules:
#===========
source "./modules/info.sh"
source "./modules/menu.sh"
source "./modules/drive.sh"
source "./modules/mirrorlist.sh"
source "./modules/timezone.sh"
source "./modules/language.sh"
source "./modules/keymap.sh"
source "./modules/hostname.sh"
source "./modules/rootpwd.sh"
source "./modules/user.sh"
source "./modules/ui.sh"
source "./modules/extra_pkg.sh"
source "./modules/aur_pkg.sh"
source "./modules/cpu.sh"
source "./modules/gpu.sh"
source "./modules/services.sh"
source "./modules/profile_load.sh"
source "./modules/build_cfg.sh"
source "./modules/bootpar.sh"
source "./modules/swappar.sh"
source "./modules/run_install.sh"

#=> Start:
#=========
install_gui_menu_func