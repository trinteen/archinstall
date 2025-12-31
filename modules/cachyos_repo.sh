#/bin/bash

install_gui_cachyos_enable=""
install_gui_cachyos_ok=""

install_gui_cachyos_func() {
    if dialog --stdout --backtitle "${AUTHOR_T}" --title "Enable CachyOS Repo" --yesno "Set CachyOS Repo as default?" "5" "100";then
        install_gui_cachyos_enable="enable"
        install_gui_cachyos_ok="X"
    else
        install_gui_cachyos_enable=""
        install_gui_cachyos_ok="X"
    fi

    install_gui_menu_func
}