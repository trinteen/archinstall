#!/bin/bash

install_gui_keymap=""
install_gui_keymap_ok=""

install_gui_keymap_func() {
    export KEYMAP_NAME=$(localectl list-keymaps | less > cache_keymap)
    export KEYMAP_MENU=()
    while IFS= read -r line; do
        if [[ ${#line} == 2 ]] || \
           [[ ${line} == *"-qwert"* ]];then
            LANGUAGE_MENU+=("${line} ${line}")
        fi
    done < cache_keymap
    export GUI_KEYMAP=$(dialog --title "Keymap" --backtitle "${AUTHOR_T}" --stdout --menu "Select :" ${WINDOW_H} ${WINDOW_W} ${WINDOW_L} ${LANGUAGE_MENU[@]})
    install_gui_keymap=${GUI_KEYMAP}
    install_gui_keymap_ok="X"
    rm cache_keymap
    install_gui_menu_func "6"
}