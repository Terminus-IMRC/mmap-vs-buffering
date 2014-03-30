#!/bin/sh
RESDIR=result
mkdir -p result

#for FILESIZE in 1 10 100 1000 10000 100000 1000000 10000000 100000000; do
for FILESIZE in 1000000000; do
	echo ">>>FILESIZE: $FILESIZE"
	make clean-db
	make db FILESIZE=$FILESIZE

	echo '>>>Testing mmap'
	make clean-mmap
	make mmap FILESIZE=$FILESIZE
	./mmap | tee $RESDIR/mmap-$FILESIZE

	echo '>>>Testing buf'
	BUFFERSIZE=1
	while test $BUFFERSIZE -le $FILESIZE; do
		echo ">>>>>>BUFFERSIZE: $BUFFERSIZE"
		make clean-buf
		make buf FILESIZE=$FILESIZE BUFFERSIZE=$BUFFERSIZE
		./buf | tee $RESDIR/buf-$FILESIZE-$BUFFERSIZE
		BUFFERSIZE=$((BUFFERSIZE*10))
	done
done
