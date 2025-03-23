information() {
    if dialog --stdout --backtitle "${AUTHOR_T}" --title "$1" --yesno "$2" "$3" "$4";then
        continue
    else
        install_gui_menu_func
    fi
}