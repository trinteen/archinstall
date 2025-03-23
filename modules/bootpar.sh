#!/bin/bash

install_gui_bootpar="512"
install_gui_bootpar_ok=""

install_gui_bootpar_func() {
    export GUI_BOOTPAR=$(dialog --stdout --title "BOOT partition" --backtitle "${AUTHOR_T}" --inputbox "Size (MB) :" ${WINDOW_H} ${WINDOW_W} ${install_gui_bootpar})
    install_gui_bootpar="${GUI_BOOTPAR}"
    install_gui_bootpar_ok="X"
    install_gui_menu_func
}