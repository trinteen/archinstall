#!/bin/bash

install_gui_hostname="archlinux"
install_gui_hostname_ok=""

install_gui_hostname_func() {
    export GUI_HOSTNAME=$(dialog --stdout --title "Hostname" --backtitle "${AUTHOR_T}" --inputbox "Enter :" ${WINDOW_H} ${WINDOW_W} ${install_gui_hostname})
    install_gui_hostname=${GUI_HOSTNAME}
    install_gui_hostname_ok="X"
    install_gui_menu_func "9"
}