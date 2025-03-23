#!/bin/bash

install_gui_swappar="8000"
install_gui_swappar_ok=""

install_gui_swappar_func() {
    export GUI_SWAPPAR=$(dialog --stdout --title "SWAP partition" --backtitle "${AUTHOR_T}" --inputbox "Size (MB):" ${WINDOW_H} ${WINDOW_W} ${install_gui_swappar})
    install_gui_swappar="${GUI_SWAPPAR}"
    install_gui_swappar_ok="X"
    install_gui_menu_func
}