#!/bin/bash

install_gui_language=""
install_gui_language_ok=""

install_gui_language_func() {
    export LANGUAGE_NAME=$(cat /etc/locale.gen > cache_language)
    export LANGUAGE_MENU=()
    while IFS= read -r line; do
        if [[ ! "${line}" == *"# "* ]]; then
            if [[ ! ${#line} == 1 ]]; then
                if [[ "${line}" == *"UTF-8"* ]]; then
                    export LANGUAGE_NAME=$(echo "${line}" | sed -e "s/.UTF-8//g" -e "s/#//g")
                    LANGUAGE_MENU+=("${LANGUAGE_NAME} ${LANGUAGE_NAME}")
                fi
            fi
        fi
    done < cache_language
    export GUI_LANGUAGE=$(dialog --title "Languages" --backtitle "${AUTHOR_T}" --stdout --menu "Select :" ${WINDOW_H} ${WINDOW_W} ${WINDOW_L} ${LANGUAGE_MENU[@]})
    install_gui_language=${GUI_LANGUAGE}
    install_gui_language_ok="X"
    rm cache_language
    install_gui_menu_func
}