#!/bin/bash

install_gui_aurpkg=""
install_gui_aurpkg_ok=""

install_gui_aurpkg_func() {
    export GUI_AURPKG=$(dialog --stdout --title "AUR Packages" --backtitle "${AUTHOR_T}" --inputbox "(split with comma) :" ${WINDOW_H} ${WINDOW_W} | awk -F, '{for (i=1;i<=NF;i++)print $i}')
    install_gui_aurpkg=${GUI_AURPKG}
    install_gui_aurpkg_ok="X"
    install_gui_menu_func "14"
}