TIMEFORMAT="It took [%R] seconds to execute this script"
time {
    # Install homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Install essential and required apps
    echo "Installing essential and required apps"
    brew install bash git curl wget

    # Configure ssh
    echo "Configuring ssh"
    mkdir -p ~/.ssh
    touch ~/.ssh/config

    mkdir -p ~/secrets
    touch ~/secrets/ap_pnphuong29.key.priv
    chmod 600 ~/secrets/*

    if [ ! -f ~/secrets/ap_pnphuong29.key.priv ]; then
        echo "You should configure [~/.ssh/config] file and add private key to clone repos"
    else
        export AP_GH_P29_DIR="${HOME}/scripto-data/projects/github.com/pnphuong29"
        mkdir -p "${AP_GH_P29_DIR}"

        # SC108
        ap_prj_scripto="ap-scripto-pub-core-sc108"
        export AP_PRJ_SC108_DIR="${AP_GH_P29_DIR}/${ap_prj_scripto}"
        cd "${AP_GH_P29_DIR}"
        echo "git clone [git@github.com:pnphuong29/${ap_prj_scripto}.git]"
        git clone "git@github.com:pnphuong29/${ap_prj_scripto}.git"

        rm -rf "${HOME}/scripto"
        ln -s "${AP_PRJ_SC108_DIR}" ~/scripto

        # SC1
        ap_prj_scripts_share="ap-scripto-share-sc1"
        export AP_PRJ_SC1_DIR="${AP_GH_P29_DIR}/${ap_prj_scripts_share}"
        cd "${AP_GH_P29_DIR}"
        echo "git clone [git@github.com:pnphuong29/${ap_prj_scripts_share}.git]"
        git clone "git@github.com:pnphuong29/${ap_prj_scripts_share}.git"

        rm -rf "${HOME}/scripto-share"
        ln -s "${AP_PRJ_SC1_DIR}" ~/scripto-share

        # SC28
        ap_prj_scripts_common="ap-scripto-common-sc28"
        export AP_PRJ_SC28_DIR="${AP_GH_P29_DIR}/${ap_prj_scripts_common}"
        cd "${AP_GH_P29_DIR}"
        echo "git clone [git@github.com:pnphuong29/${ap_prj_scripts_common}.git]"
        git clone "git@github.com:pnphuong29/${ap_prj_scripts_common}.git"

        rm -rf "${HOME}/scripto-common"
        ln -s "${AP_PRJ_SC28_DIR}" ~/scripto-common

        # SC7
        ap_prj_scripts_main="ap-scripto-macos-sc7"
        export AP_PRJ_SCRIPTS_MAIN_DIR="${AP_GH_P29_DIR}/${ap_prj_scripts_main}"
        cd "${AP_GH_P29_DIR}"
        echo "git clone [git@github.com:pnphuong29/${ap_prj_scripts_main}.git]"
        git clone "git@github.com:pnphuong29/${ap_prj_scripts_main}.git"

        rm -rf "${HOME}/scripto-main"
        ln -s "${AP_PRJ_SCRIPTS_MAIN_DIR}" ~/scripto-main

        # Update ~/.profile
        if ! grep scripto-main ~/.profile &>/dev/null; then
            echo "" >>~/.profile
            echo 'echo "Execute [~/.profile]"' >>~/.profile
            echo "time source ~/scripto-main/ap_master.sh" >>~/.profile
        fi

        # Setup apps
        echo "Installing vendors"
        source ~/scripto-main/ap_master.sh
        apcreatedirstructdesktop
    fi
}
