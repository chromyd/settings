function remap() {
	hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035},{"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x700000064}]}'
}

function showmap() {
	hidutil property --get "UserKeyMapping"
}

function unmap() {
	hidutil property --set '{"UserKeyMapping":[]}'
}

function ramdisk() {
	SIZE=${1:-512}
	#echo Creating a ${SIZE}MB RAM disk
	diskutil erasevolume HFS+ ramdisk `hdiutil attach -nomount ram://$(($SIZE * 2048))`
}

function finalize() {
	sh ~/ws/freestream/finalize.sh $*
	mv -v ~/ChromeDownloads/*.mp4 ~/nhl
	find ~/ChromeDownloads/*.ts -size +1G | xargs -I {} mv -v {} ~/nhl/ts
}

function finalize2() {
	for file in $*
	do
		echo Doing $file...
		time sh ~/tmp/finalize.sh $file > $file.ocr
	done
}

function ocr() {
	if [ $# != 3 ]
	then
		echo 'Usage: ocr FILE FROM LENGTH' >&2
		return
	fi	

	local FILE=$1
	local FROM=$2
	
	echo "Analyzing $FILE from $2 for $3 seconds" > raw-ocr-$$
	echo "Analyzing $FILE from $2 for $3 seconds"
	local IDX=0
	while [ $IDX -lt $3 ]
	do
		echo ">>> Pos: $((IDX + FROM))" >> raw-ocr-$$
		ffmpeg -nostdin -v fatal -ss $((IDX + FROM)) -i $FILE -vframes 1 -f image2 - |
		#tesseract stdin stdout -c tessedit_char_whitelist=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789:-  2>> errors >> raw-ocr-$$
		tesseract --oem 1 --psm 11 stdin stdout 2>> errors >> raw-ocr-$$
		echo -n "$((IDX + 1)) "
		let 'IDX += 1'
	done
	grep -v '^$' raw-ocr-$$ | perl -ne '
if (/Pos: (\S+)/) {
	$p=$1;
}
else {
	print "$p: $_";
}' > ${FILE%.ts}.ocr && rm raw-ocr-$$
	echo Done
}

function srt() {
	for FILE in $*
	do
		SRT_FILE=${FILE%.ts}.srt
		test -e $SRT_FILE || ffmpeg -f lavfi -i movie=$FILE[out+subcc] -map 0:1 $SRT_FILE
	done
}

function report() {
	for f in $*
	do
		BASENAME=$(basename $f)
		BASE=${BASENAME%%.srt}
		perl -n ~/tmp/mins.pl < ~/nhl/ts/$BASE.silence.txt > $BASE.report
		cat $f >> $BASE.report
	done
	less *.report
}

function grab() {
	POS=$1
	FILE=${2:-*.ts}

	if [ "$POS" == "" -o ! -e $(echo $FILE | tr -d ' ') ]
	then
		echo Usage: grab POS [FILE]
		echo
		echo "    POS  -- can be in any ffmpeg supported format, eg. 46:57 or 2817"
		echo "    FILE -- the filename (must not contain spaces), defaults to *.ts:" *.ts
		return
	fi
	ffmpeg -ss $POS -i $FILE -vframes 1 -y image.jpeg && open image.jpeg
}

function curl() {
	/usr/bin/curl -S $* | python -m json.tool
}

function fspublish() {(
	cd freestream &&
	ng build --prod --base-href=/freestream/ &&
	ssh otaku rm html/freestream/*
	scp dist/* otaku:html/freestream
)}
