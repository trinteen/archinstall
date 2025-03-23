#!/bin/bash

install_gui_mirrorlist=""
install_gui_mirrorlist_ok=""

install_gui_mirrorlist_func() {
	export MIRRORLIST_NAME=$(curl -s https://archlinux.org/mirrorlist/ | grep -Eo "<option.*(</option>|>)" | sed "s/<[^>]\+>//g" | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//' > cache_mirrorlist)
	export MIRRORLIST_NAME=()
	export MIRRORLIST_MENU=()
	while IFS= read -r line; do
		export FIX_STR=$(echo "${line}" | sed 's/ /\xc2\xa0/g')
		MIRRORLIST_NAME+=("${FIX_STR}")
	done < cache_mirrorlist
	export MIRRORLIST_ID=$(curl -s https://archlinux.org/mirrorlist/ | grep -Eo "<option.*(</option>|>)" | sed -n -e "s/^.*value=['\"]\(.*\)['\"].*/\1/p")
	export MIRRORLIST_ID=(${MIRRORLIST_ID})
	for i in ${!MIRRORLIST_ID[@]}; do
		MIRRORLIST_MENU+=("${MIRRORLIST_ID[$i]} ${MIRRORLIST_NAME[$i]}")
	done
	export GUI_MIRRORLIST=$(dialog --stdout --title "Archlinux mirrorlist" --backtitle "${AUTHOR_T}" --menu "Select county :" ${WINDOW_H} ${WINDOW_W} ${WINDOW_L} ${MIRRORLIST_MENU[@]})
	install_gui_mirrorlist=${GUI_MIRRORLIST}
	install_gui_mirrorlist_ok="X"
	rm cache_mirrorlist
	install_gui_menu_func
}