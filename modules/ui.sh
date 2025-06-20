#!/bin/bash

install_gui_ui=""
install_gui_ui_ok=""

install_gui_ui_func() {
    export WM=()
    WM+=("awesome"  "$(echo "Awesome Window Manager" | sed 's/ /\xc2\xa0/g')")
    WM+=("bspwm"    "$(echo "Bspwm Window Manager" | sed 's/ /\xc2\xa0/g')")
    WM+=("budgie"   "$(echo "Budgie Desktop" | sed 's/ /\xc2\xa0/g')")
    WM+=("cinnamon" "$(echo "Cinnamon Desktop" | sed 's/ /\xc2\xa0/g')")
    WM+=("gnome"    "$(echo "Gnome Desktop" | sed 's/ /\xc2\xa0/g')")
    WM+=("hyprland" "$(echo "Hyperland Desktop" | sed 's/ /\xc2\xa0/g')")
    WM+=("i3"       "$(echo "i3 window manager" | sed 's/ /\xc2\xa0/g')")
    WM+=("kde"      "$(echo "KDE Plasma Desktop" | sed 's/ /\xc2\xa0/g')")
    WM+=("lxqt"     "$(echo "LXQT Desktop" | sed 's/ /\xc2\xa0/g')")
    WM+=("mate"     "$(echo "MATE Desktop" | sed 's/ /\xc2\xa0/g')")
    WM+=("qtile"    "$(echo "QTILE Window Manager" | sed 's/ /\xc2\xa0/g')")
    WM+=("sway"     "$(echo "SWAY Window Manager" | sed 's/ /\xc2\xa0/g')")
    WM+=("xfce"     "$(echo "XFCE Desktop" | sed 's/ /\xc2\xa0/g')")
    WM+=("xmonad"   "$(echo "XMONAD Window Manager" | sed 's/ /\xc2\xa0/g')")
    WM+=("none"     "$(echo "No desktop" | sed 's/ /\xc2\xa0/g')")
    export GUI_UI=$(dialog --stdout --backtitle "${AUTHOR_T}"  --title "Desktop UI" --menu "Select : " ${WINDOW_H} ${WINDOW_W} ${WINDOW_L} ${WM[@]})
    install_gui_ui=${GUI_UI}
    install_gui_ui_ok="X"
    install_gui_menu_func "12"
}