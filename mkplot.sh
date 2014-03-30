#!/bin/sh
RESDIR=result
sed "s/XXX/$RESDIR/g" <<'END'
#!/usr/bin/env gnuplot
system("rm -f result.png")

#set terminal pngcairo size 480,640
set terminal pngcairo size 1024,768 font "Courier Bold,17"
set output "result.png"

set key left top
set grid
set log xy

set format xy "10^%L"

set xlabel "filesize [bytes]"
set ylabel "end-start [sec]"

set title "time of simple-I/O by using mmap() and bufering"

plot \
END

for f in $RESDIR/result-buf-*.txt; do
	BUFFERSIZE=$(echo $f | cut -d- -f3 | cut -d. -f1)
	echo "	\"$f\" using 1:2 title \"buffering(buffersize=10^$(python2 -c "import math; print int(math.log10($BUFFERSIZE))"))\" with linespoints, \\"
done

sed "s/XXX/$RESDIR/g" <<'END'
	"XXX/result-mmap.txt" using 1:2 title "mmap" lw 3 with linespoints
END
