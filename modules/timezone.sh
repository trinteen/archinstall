#!/bin/bash

install_gui_timezone=""
install_gui_timezone_ok=""

install_gui_timezone_func() {
	export TIMEZONE_LIST=$(find /usr/share/zoneinfo -type d -printf "%f\n" | sort | uniq > cache_timezone)
	export TIMEZONE_NAME=()
	while IFS= read -r line; do
		if [ -d "/usr/share/zoneinfo/${line}" ]; then
			export TIMEZONE_LIST2=$(find /usr/share/zoneinfo/${line} -type f -printf "%f\n" | sort | uniq > cache_timezone2)
			while IFS= read -r line2; do
				TIMEZONE_NAME+=("${line}/${line2} ${line}/${line2}")
			done < cache_timezone2
		fi
	done < cache_timezone
	export GUI_TIMEZONE=$(dialog --stdout --title "Timezone" --backtitle "${AUTHOR_T}" --menu "Select:" ${WINDOW_H} ${WINDOW_W} ${WINDOW_L} ${TIMEZONE_NAME[@]})
	install_gui_timezone=${GUI_TIMEZONE}
	install_gui_timezone_ok="X"
    rm cache_timezone
    rm cache_timezone2
	install_gui_menu_func "4"
}
