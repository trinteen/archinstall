#!/bin/bash
install_gui_loadprofile=""

if [ ! -d "./profiles" ];then
    mkdir "./profiles"
fi

install_gui_loadprofile_func() {
    WINDOW_W=100
    export GUI_LOADPROFILE=$(dialog --stdout --backtitle "${AUTHOR_T}" --title "Load profile (SPACE) = select" --fselect ./profiles/ ${WINDOW_H} ${WINDOW_W})
    install_gui_loadprofile="${GUI_LOADPROFILE}"    
    cp "${install_gui_loadprofile}" "./archinstall_setup_cfg.sh"
    WINDOW_W=0
    run_install
}