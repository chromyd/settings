function remap() {
	hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035},{"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x700000064}]}'
}

function showmap() {
	hidutil property --get "UserKeyMapping"
}

function unmap() {
	hidutil property --set '{"UserKeyMapping":[]}'
}

#function ramdisk() {
#	SIZE=${1:-512}
#	#echo Creating a ${SIZE}MB RAM disk
#	diskutil erasevolume HFS+ ramdisk `hdiutil attach -nomount ram://$(($SIZE * 2048))`
#}

function finalize() {
	sh ~/ws/freestream/assemble.sh &&
	sh ~/ws/freestream/process.sh ~/ChromeDownloads/202*.ts &&
	mv -v ~/ChromeDownloads/*.mp4 ~/nhl &&
	find ~/ChromeDownloads/*.ts -size +1G | xargs -I {} mv -v {} ~/nhl/ts
}

function fspublish() {(
	cd freestream &&
	ng build --prod --base-href=/freestream/ &&
	ssh otaku rm html/freestream/*
	scp dist/* otaku:html/freestream
)}

function mvns() {

	if [ "$1" == "" ]
	then
		ls -l ~/.m2
	else
		SETTINGS_FILE=~/.m2/settings-$1.xml

		if [ -e $SETTINGS_FILE ]
		then
			ln -sf $SETTINGS_FILE ~/.m2/settings.xml
			ls -l ~/.m2/settings.xml
		else
			echo File $SETTINGS_FILE does not exist. Existing files:
			echo
			ls -l ~/.m2/settings-*
		fi
	fi
}

function emulator() {
	cd "$(dirname "$(which emulator)")" && ./emulator "$@"
}

#function npm() {
#
#	case "$1" in
#	start|run)
#		/usr/local/bin/npm $* 2>&1 >/dev/null
#		;;
#	*)
#		/usr/local/bin/npm $*
#	esac
#}

function sha1() {
	echo -n "$1" | shasum | cut -d ' ' -f 1
}

function adv() {(
	cd ~/Documents/MOBI-2020
	id=$(ls -r MO-??.csv | head -1 | tr '-' '.' | cut -f 2 -d .)
	next_id=$((id + 1))
	cp MO-${id}.csv MO-${next_id}.csv
	vi MO-${next_id}.csv
)}

function today() {(
	cd ~/Documents/MOBI-2020
	id=$(ls -r MO-??.csv | head -1 | tr '-' '.' | cut -f 2 -d .)
	vi MO-${id}.csv
)}

function yesterday() {(
	cd ~/Documents/MOBI-2020
	id=$(ls -r MO-??.csv | head -1 | tr '-' '.' | cut -f 2 -d .)
	find . -name MO-${id}.csv -print -exec cat {} \;
)}

#function ju0() {(
#	cd ~/Documents/Ju-Hausaufgaben
#	topdf $*
#	mv Combined.pdf Hausaufgaben-Julie.pdf
#)}

function login() {
	if [ "$1" == "prod" ]
	then
		if [ -z $PASSWORD ]
		then
			echo Please login in as miatester.spirit@gmail.com in PROD
			echo -n "Password: "
			read PASSWORD
		fi

		curl -s -d "grant_type=password&client_id=mobility-app-client&username=miatester.spirit@gmail.com&password=$PASSWORD" https://auth.businesshub.deutschebahn.com/auth/realms/mobi/protocol/openid-connect/token | jq -r '.access_token' | pbcopy
	else
		if [ -z $PASSWORD ]
		then
			echo Please login in as banana2 in IAT
			echo -n "Password: "
			read PASSWORD
		fi

		curl -s -d "grant_type=password&client_id=mobility-app-client&username=banana2&password=$PASSWORD" https://auth.businesshub-test.deutschebahn.com/auth/realms/mobi/protocol/openid-connect/token | jq -r '.access_token' | pbcopy
	fi
	echo Copied to clipboard:
	echo $(pbpaste)
}

function print_recent() {(
	cd ~/Downloads
	N=${1:-1}
	echo "Print and remove $N most recent download(s):"
	ls -t | head -$N
	echo -n 'Continue [Y/n] ? '
	read INPUT
	if [ "$INPUT" == "n" ]; then return; fi
	echo Go ahead!
	ls -t | head -6 | tr '\n' '\0' | xargs -0 -n1 lpr
	ls -t | head -6 | tr '\n' '\0' | xargs -0 -n1 rm
)}
