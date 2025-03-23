#!/bin/bash

install_gui_services=""
install_gui_services_ok=""

install_gui_services_func() {
    export GUI_SERVICES=$(dialog --stdout --title "Custom services" --backtitle "${AUTHOR_T}" --inputbox "Names services (split with comma) :" ${WINDOW_H} ${WINDOW_W} | awk -F, '{for (i=1;i<=NF;i++)print $i}')
    install_gui_services=${GUI_SERVICES}
    install_gui_services_ok="X"
    install_gui_menu_func
}