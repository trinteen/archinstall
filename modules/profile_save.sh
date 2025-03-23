#!/bin/bash

install_gui_saverofile=""
install_gui_saveprofile_ok=""

if [ ! -d "./profiles" ];then
    mkdir "./profiles"
fi

install_gui_saveprofile_func() {
    #build_cfg
    DATE=$(date +%Y%m%dT%H%M%S)
    NAME_FILE=$(echo "archinstall_${DATE}")
    export GUI_SAVEPROFILE=$(dialog --stdout --title "Profiles" --backtitle "${AUTHOR_T}" --inputbox "Save profile" ${WINDOW_H} ${WINDOW_W} "${NAME_FILE}")
    install_gui_saveprofile="${GUI_SAVEPROFILE}"
    install_gui_saveprofile_ok="X"
    if [ -f "./archinstall_setup_cfg.sh" ];then
        TXT=$(cat ./archinstall_setup_cfg.sh)
        FOOTER=$(echo "#\n# Generate archinstall script - ${install_gui_saveprofile}\n#")
        echo -e "${TXT}${FOOTER}" > ./profiles/${install_gui_saveprofile}.sh
    fi
    install_gui_menu_func
}