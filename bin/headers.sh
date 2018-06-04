#!/bin/sh
# Headers so you know what type of deployment you are doing

function welcomeHead() {
	echo "                 .__                                   "
	echo "__  _  __  ____  |  |    ____   ____    _____    ____  "
	echo "\ \/ \/ /_/ __ \ |  |  _/ ___\ /  _ \  /     \ _/ __ \ "
	echo " \     / \  ___/ |  |__\  \___(  <_> )|  Y Y  \\  ___/ "
	echo "  \/\_/   \___  >|____/ \___  >\____/ |__|_|  / \___  >"
	echo "              \/            \/              \/      \/ "
}

function deployHead() {
	echo "    .___               .__                  "
	echo "  __| _/ ____  ______  |  |    ____  ___.__."
	echo " / __ |_/ __ \ \____ \ |  |   /  _ \<   |  |"
	echo "/ /_/ |\  ___/ |  |_> >|  |__(  <_> )\___  |"
	echo "\____ | \___  >|   __/ |____/ \____/ / ____|"
	echo "     \/     \/ |__|                  \/     "
}

function syncHead() {
	echo "  ______ ___.__.  ____    ____  "
	echo " /  ___/<   |  | /    \ _/ ___\ "
	echo " \___ \  \___  ||   |  \\  \___ "
	echo "/____  > / ____||___|  / \___  >"
	echo "     \/  \/          \/      \/ "
}

function updateHead() {
	echo "                   .___         __           "
	echo " __ __ ______    __| _/_____  _/  |_   ____  "
	echo "|  |  \\____ \  / __ | \__  \ \   __\_/ __ \ "
	echo "|  |  /|  |_> >/ /_/ |  / __ \_|  |  \  ___/ "
	echo "|____/ |   __/ \____ | (____  /|__|   \___  >"
	echo "       |__|         \/      \/            \/ "
}