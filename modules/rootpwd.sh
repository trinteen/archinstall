#!/bin/bash

install_gui_rootpwd=""
install_gui_rootpwd_ok=""

install_gui_rootpwd_func() {
    export GUI_ROOTPWD=$(dialog --stdout --title "Password for ROOT user" --backtitle "${AUTHOR_T}" --passwordbox "Password :" ${WINDOW_H} ${WINDOW_W})
    if [ "${GUI_ROOTPWD}" == "" ];then
        install_gui_rootpwd="root"
    else
        install_gui_rootpwd=${GUI_ROOTPWD}
    fi
    install_gui_rootpwd_ok="X"
    install_gui_menu_func "10"
}