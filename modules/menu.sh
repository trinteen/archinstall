#!/bin/bash

install_gui_menu=""

install_gui_menu_func() {
    SPA=("$(echo " " | sed 's/ /\xc2\xa0/g')")
    export MENU=()
    MENU+=("1"  "$(echo "*Select drive               [${install_gui_drive_ok}]" | sed 's/ /\xc2\xa0/g')")
    MENU+=("2"  "$(echo "*Select mirrorlist          [${install_gui_mirrorlist_ok}]" | sed 's/ /\xc2\xa0/g')")
    MENU+=("3"  "$(echo "*Select timezone            [${install_gui_timezone_ok}]" | sed 's/ /\xc2\xa0/g')")
    MENU+=("4"  "$(echo "*Select language            [${install_gui_language_ok}]" | sed 's/ /\xc2\xa0/g')")
    MENU+=("5"  "$(echo "*Select keymap              [${install_gui_keymap_ok}]" | sed 's/ /\xc2\xa0/g')")
    MENU+=("6"  "$(echo "*Select CPU ucode           [${install_gui_cpu_ok}]" | sed 's/ /\xc2\xa0/g')")
    MENU+=("7"  "$(echo "*Select GPU                 [${install_gui_gpu_ok}]" | sed 's/ /\xc2\xa0/g')")
    MENU+=("8"  "$(echo "*Set hostname               [${install_gui_hostname_ok}]" | sed 's/ /\xc2\xa0/g')")
    MENU+=("9"  "$(echo "*Set ROOT password          [${install_gui_rootpwd_ok}]" | sed 's/ /\xc2\xa0/g')")
    MENU+=("10" "$(echo "*Create USER account        [${install_gui_user_ok}]" | sed 's/ /\xc2\xa0/g')")
    MENU+=("${SPA}"  "$(echo "==============================" | sed 's/=/\xc2\xa0/g')")
    MENU+=("11" "$(echo "Select Desktop              [${install_gui_ui_ok}]" | sed 's/ /\xc2\xa0/g')")
    MENU+=("12" "$(echo "Set EXTRA PACKAGES          [${install_gui_extrapkg_ok}]" | sed 's/ /\xc2\xa0/g')")
    MENU+=("13" "$(echo "Set AUR PACKAGES            [${install_gui_aurpkg_ok}]" | sed 's/ /\xc2\xa0/g')")
    MENU+=("14" "$(echo "Add more services           [${install_gui_services_ok}]" | sed 's/ /\xc2\xa0/g')")
    MENU+=("${SPA}"  "$(echo "==============================" | sed 's/=/\xc2\xa0/g')")
    MENU+=("L"  "$(echo "INSTALL (with profile file)    " | sed 's/ /\xc2\xa0/g')")

    if [ "${install_gui_drive_ok}" == "X" ] && \
       [ "${install_gui_mirrorlist_ok}" == "X" ] && \
       [ "${install_gui_timezone_ok}" == "X" ] && \
       [ "${install_gui_language_ok}" == "X" ] && \
       [ "${install_gui_keymap_ok}" == "X" ] && \
       [ "${install_gui_rootpwd_ok}" == "X" ] && \
       [ "${install_gui_user_ok}" == "X" ] && \
       [ "${install_gui_cpu_ok}" == "X" ] && \
       [ "${install_gui_gpu_ok}" == "X" ] && \
       [ "${install_gui_mirrorlist_ok}" == "X" ];then
        MENU+=("I"  "$(echo -e "INSTALL NOW" | sed 's/ /\xc2\xa0/g')")
    fi
    
    MENU+=("${SPA}"  "$(echo "==============================" | sed 's/=/\xc2\xa0/g')")
    MENU+=("E"  "$(echo "Custom size BOOT partition  [${install_gui_bootpar_ok}]" | sed 's/ /\xc2\xa0/g')")
    MENU+=("R"  "$(echo "Custom size SWAP partition  [${install_gui_swappar_ok}]" | sed 's/ /\xc2\xa0/g')")
    MENU+=("C"  "$(echo "Enable CachyOS Repo         [${install_gui_cachyos_ok}]" | sed 's/ /\xc2\xa0/g')")
    MENU+=("${SPA}"  "$(echo "==============================" | sed 's/=/\xc2\xa0/g')")

    MENU+=("X"  "$(echo "EXIT" | sed 's/ /\xc2\xa0/g')")
    export GUI_MENU=$(dialog --default-item "$1" --stdout --title "MAIN MENU" --backtitle "${AUTHOR_T}" --menu "(*=require) : " ${WINDOW_H} ${WINDOW_W} ${WINDOW_L} ${MENU[@]})
    install_gui_menu=${GUI_MENU}

    case ${GUI_MENU} in 
        1)
            install_gui_drive_func
            ;;
        2)
            install_gui_mirrorlist_func
            ;;
        3)
            install_gui_timezone_func
            ;;
        4)
            install_gui_language_func
            ;;
        5)
            install_gui_keymap_func
            ;;
        6)
            install_gui_cpu_func
            ;;
        7)
            install_gui_gpu_func
            ;;
        8)
            install_gui_hostname_func
            ;;
        9)
            install_gui_rootpwd_func
            ;;
        10)
            install_gui_user_func
            ;;
        11)
            install_gui_ui_func
            ;;
        12)
            install_gui_extrapkg_func
            ;;
        13)
            install_gui_aurpkg_func
            ;;
        14)
            install_gui_services_func
            ;;
        I)
            build_cfg;run_install
            ;;
        L)
            install_gui_loadprofile_func
            ;;
        E)
            install_gui_bootpar_func
            ;;
        R)
            install_gui_swappar_func
            ;;
        C)
            install_gui_cachyos_func
            ;;
        X)
            echo "Exit"; clear
            ;;
    esac
}