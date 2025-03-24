#!/bin/bash

install_gui_user=""
install_gui_pass=""
install_gui_user_ok=""

install_gui_user_func() {
    export GUI_USER_NAME=$(dialog --stdout --title "Create USER accont" --backtitle "${AUTHOR_T}" --inputbox "Username :" ${WINDOW_H} ${WINDOW_W})
    export GUI_USER_PASS=$(dialog --stdout --title "Create USER accont" --backtitle "${AUTHOR_T}" --passwordbox "Password :" ${WINDOW_H} ${WINDOW_W})
    if [ "${GUI_USER_NAME}" == "" ] || [ "${GUI_USER_PASS}" == "" ];then
        install_gui_user="user"
        install_gui_pass="user"
    else
        install_gui_user="${GUI_USER_NAME}"
        install_gui_pass="${GUI_USER_PASS}"
    fi
    install_gui_user_ok="X"
    install_gui_menu_func "11"
}