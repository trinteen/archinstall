#!/bin/bash

install_gui_cpu=""
install_gui_cpu_ok=""

install_gui_cpu_func() {
    export cpu=()
    cpu+=("intel"   "$(echo "Intel CPUs" | sed 's/ /\xc2\xa0/g')")
    cpu+=("amd"     "$(echo "AMD CPUs" | sed 's/ /\xc2\xa0/g')")
    export GUI_CPU=$(dialog --stdout --title "Ucode for CPUs" --backtitle "${AUTHOR_T}" --menu "CPU drivers : " ${WINDOW_H} ${WINDOW_W} ${WINDOW_L} ${cpu[@]})
    install_gui_cpu=${GUI_CPU}
    install_gui_cpu_ok="X"
    install_gui_menu_func "7"
}