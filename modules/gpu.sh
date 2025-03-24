#!/bin/bash

install_gui_gpu=""
install_gui_gpu_ok=""

install_gui_gpu_func() {
    export gpu=()
    gpu+=("amd"         "$(echo "ATI/AMD (open source)" | sed 's/ /\xc2\xa0/g')")
    gpu+=("intel"       "$(echo "Intel (open source)" | sed 's/ /\xc2\xa0/g')")
    gpu+=("nvidia-new"  "$(echo "Nvidia (Turing+)" | sed 's/ /\xc2\xa0/g')")
    gpu+=("nvidia-open" "$(echo "Nvidia (open source)" | sed 's/ /\xc2\xa0/g')")
    gpu+=("nvidia"      "$(echo "Nvidia (proprietary)" | sed 's/ /\xc2\xa0/g')")
    gpu+=("vm"          "$(echo "VMWare / VirtualBox" | sed 's/ /\xc2\xa0/g')")
    gpu+=("none"        "$(echo "No GPU drivers" | sed 's/ /\xc2\xa0/g')")
    export GUI_GPU=$(dialog --stdout --title "Graphic card" --backtitle "${AUTHOR_T}" --menu "Drivers : " ${WINDOW_H} ${WINDOW_W} ${WINDOW_L} ${gpu[@]})
    install_gui_gpu=${GUI_GPU}
    install_gui_gpu_ok="X"
    install_gui_menu_func "8"
}