ap_setup_bash() {
	# Download bash source code
	ap_bash_version='5.1.16'
	cd "${HOME}/Download"
	curl -LO "https://mirror.downloadvn.com/gnu/bash/bash-${ap_bash_version}.tar.gz"
	tar -zxf "bash-${ap_bash_version}.tar.gz"

	# Install bash
	export AP_VENDORS_BASH_DIR="${HOME}/scripto-data/software/bash/bash-${ap_bash_version}"
	cd "bash-${ap_bash_version}"
	./configure --prefix="${AP_VENDORS_BASH_DIR}"
	make install

	sudo echo "${AP_VENDORS_BASH_DIR}/bin/bash" >>/etc/shells
	chsh -s "${AP_VENDORS_BASH_DIR}/bin/bash"
}

# @#bashsn $$ measure execution time
TIMEFORMAT="It took [%R] seconds to execute this script"
time {
	# Install essential and required apps
	echo "Installing essential and required apps"

	sudo apt update
	sudo apt install -y software-properties-common

	sudo add-apt-repository -y ppa:git-core/ppa
	sudo apt update
	sudo apt install -y git wget curl vim ssh

	# If current bash version < 5.x then uncomment the below lines to install bash
	# ap_setup_bash()

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
		ap_prj_scripto="ap-scripto-core-pub-sc108"
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

		# SC21
		ap_prj_scripts_main="ap-scripto-ubuntu7-sc21"
		export AP_PRJ_SCRIPTS_MAIN_DIR="${AP_GH_P29_DIR}/${ap_prj_scripts_main}"
		cd "${AP_GH_P29_DIR}"
		echo "git clone [git@github.com:pnphuong29/${ap_prj_scripts_main}.git]"
		git clone "git@github.com:pnphuong29/${ap_prj_scripts_main}.git"

		rm -rf "${HOME}/scripto-main"
		ln -s "${AP_PRJ_SCRIPTS_MAIN_DIR}" ~/scripto-main

		# Update ~/.bashrc
		if ! grep scripto-main ~/.bashrc &>/dev/null; then
			echo "" >>~/.bashrc
			echo 'echo "Execute [~/.bashrc]"' >>~/.bashrc
			echo "time source ~/scripto-main/ap_master.sh" >>~/.bashrc
		fi

		# Setup apps
		echo "Installing vendors"
		source ~/scripto-main/ap_master.sh
		apcreatedirstructdesktop
	fi
}
