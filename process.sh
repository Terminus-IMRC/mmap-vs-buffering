#!/bin/sh
RESDIR=result
RESNMAP=result-mmap.txt
RESBUF_BASE=result-buf

cd $RESDIR

echo '#FILESIZE end-start[sec]' >$RESNMAP
for f in mmap-*; do
	FILESIZE=$(echo $f | cut -d- -f2)
	echo -n "$FILESIZE " >>$RESNMAP
	cut -d: -f2 <$f | tr -s '\n' ' ' | awk '{print $2 - $1}' >>$RESNMAP
done

ID="$(uuid)"
for f in buf-*-*; do
	echo f: $f
	FILESIZE=$(echo $f | cut -d- -f2)
	BUFFERSIZE=$(echo $f | cut -d- -f3)
	OUTF=$RESBUF_BASE-$BUFFERSIZE.txt
	if ! test "$(eval echo \$leg_$BUFFERSIZE)" = "$ID"; then
		echo reg
		echo "#FILESIZE end-start[sec]" >$OUTF
		eval leg_$BUFFERSIZE=$ID
	fi
	echo -n "$FILESIZE " >>$OUTF
	cut -d: -f2 <$f | tr -s '\n' ' ' | awk '{print $2 - $1}' >>$OUTF
done
