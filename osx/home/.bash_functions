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

function curly() {
	/usr/bin/curl -S $* | python -m json.tool
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

function tscj() {
	echo Running tsc, checking journey ...
	echo
	/usr/local/bin/tsc -p . --noEmit | grep ^src/journey | grep -v test | tee /tmp/tsc$$
	echo
	echo "Found" $(wc -l < /tmp/tsc$$) "error(s)"
}

function adv() {
	cd ~/Documents
	id=$(ls -r MO-??.csv | head -1 | tr '-' '.' | cut -f 2 -d .)
	next_id=$((id + 1))
	cp MO-${id}.csv MO-${next_id}.csv
	vi MO-${next_id}.csv
}
