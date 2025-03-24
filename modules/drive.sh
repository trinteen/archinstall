#!/bin/bash

install_gui_drive=""
install_gui_drive_ok=""

install_gui_drive_func() {
	export GUI_DRIVE=$(lsblk -n --output TYPE,KNAME,MODEL,SIZE | awk '$1=="disk"{print $2,$3$4}')
	export GUI_DRIVE=$(dialog --stdout --title "Drivers" --backtitle "${AUTHOR_T}" --menu "Install to :" ${WINDOW_H} ${WINDOW_W} ${WINDOW_L} ${GUI_DRIVE})
	export GUI_DRIVE=/dev/${GUI_DRIVE}
	install_gui_drive=${GUI_DRIVE}
	install_gui_drive_ok="X"
	install_gui_menu_func "2"
}