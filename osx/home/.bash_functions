function remap() {
	hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035},{"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x700000064}]}'
}

function showmap() {
	hidutil property --get "UserKeyMapping"
}

function unmap() {
	hidutil property --set '{"UserKeyMapping":[]}'
}

function emulator() {
	cd "$(dirname "$(which emulator)")" && ./emulator "$@"
}

function adv() {(
	cd ~/Documents/Team-Spirit-2021
	id=$(ls -r W??.csv | head -1 | sed 's/W/W./' | cut -f 2 -d .)
	next_id=$((id + 1))
	cp W${id}.csv W${next_id}.csv
	vi W${next_id}.csv
)}

function print_recent() {(
	cd ~/Downloads
	N=${1:-1}
	echo "Print and remove $N most recent download(s):"
	ls -t | head -$N
	echo -n 'Continue [Y/n] ? '
	read INPUT
	if [ "$INPUT" == "n" ]; then return; fi
	echo Printing...
	ls -t | head -$N | tr '\n' '\0' | xargs -0 -n1 lpr
	ls -t | head -$N | tr '\n' '\0' | xargs -0 -n1 rm
)}

function elfe() {
	echo RHp1SHA5blZQeA== | base64 -d | pbcopy
	echo ELFE password copied to clipboard
}

function wd() {
	ARG1=$1
	ARG=${ARG1:-1}
	WD=~/ws/$(head -n $ARG ~/.workdir | tail -n 1)
	if [ -z "$ARG1" ]
	then
		HIGHLIGHT_ON=$(tput bold)$(tput setaf 5)
		HIGHLIGHT_OFF=$(tput sgr0)
		awk -v highlight_on=$HIGHLIGHT_ON -v highlight_off=$HIGHLIGHT_OFF '{printf "%s%2d%s %s\n", highlight_on, NR, highlight_off, $0}' ~/.workdir
	fi
	echo "Changing dir to $ARG: $WD"
	cd $WD
	[ -f .autorun ] && echo Running .autorun && sh -x .autorun
}

function npmt() {
	node_modules/mocha/bin/mocha -r ts-node/register -g "$*"
}

function gl() {
	ID=""
	INPUT=$(pbpaste)
	APIKEY=$(cat ~/.google-api-key)
	if [ ! -z "$1" ]
	then
		ID="n=$1&"
	fi
	TRAILING=${INPUT#https://drive.google.com/file/d/}
	FILEID=${TRAILING%/*}
	if [[ $FILEID =~ ^[A-Za-z0-9]*$ ]]
	then
		URL="https://www.googleapis.com/drive/v3/files/$FILEID?${ID}alt=media&key=$APIKEY"
		echo $URL | pbcopy
		echo "URL copied to clipboard"
	else
		echo "Failed to extract FileID (got: $FILEID)"
	fi
}
