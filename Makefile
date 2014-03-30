FILESIZE?=1000000
BUFFERSIZE?=1000

CFLAGS=-Wall -Wextra -O0 -DFILESIZE=$(FILESIZE) -DBUFFERSIZE=$(BUFFERSIZE)

all: mmap buf

mmap: mmap.o func.o
mmap.o: mmap.c
buf: buf.o func.o
buf.o: buf.c
func.o: func.c

db:
	if test $(FILESIZE) -le 1000000; then \
		dd if=/dev/zero of=$@ bs=$(FILESIZE) count=1; \
	else \
		dd if=/dev/zero of=$@ bs=10000000 count=$(shell expr $(FILESIZE) / 10000000); \
	fi

.PHONY: clean clean-mmap clean-buf clean-func clean-db

clean: clean-mmap clean-buf clean-func clean-db

clean-mmap:
	$(RM) mmap mmap.o

clean-buf:
	$(RM) buf buf.o

clean-func:
	$(RM) func.o

clean-db:
	$(RM) db
