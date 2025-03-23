#!/bin/bash

install_gui_extrapkg=""
install_gui_extrapkg_ok=""

install_gui_extrapkg_func() {
    export GUI_EXTRAPKG=$(dialog --stdout --title "Extra packages" --backtitle "${AUTHOR_T}" --inputbox "(split with comma):" ${WINDOW_H} ${WINDOW_W} | awk -F, '{for (i=1;i<=NF;i++)print $i}')
    install_gui_extrapkg=${GUI_EXTRAPKG}
    install_gui_extrapkg_ok="X"
    install_gui_menu_func
}