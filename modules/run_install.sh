run_install(){
    if [ -f "./archinstall_setup_cfg.sh" ]; then
        information "Run instalation" "Instalation with file is starting now?" 5 100
        source "./archinstall_setup_cfg.sh"
        source "./scripts/archinstall_test.sh"
    else
        install_gui_menu_func
    fi
}