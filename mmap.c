#include <stdio.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>

#include <sys/time.h>

void func(int8_t);

int main()
{
	int fd;
	int8_t *map;
	long int i;
	struct timeval start, end;

	fd=open("db", O_RDWR, S_IRUSR | S_IWUSR);
	if(fd==-1){
		perror("open");
		exit(EXIT_FAILURE);
	}

	map=mmap(NULL, FILESIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	if(map==MAP_FAILED){
		perror("mmap");
		exit(EXIT_FAILURE);
	}

	gettimeofday(&start, NULL);
	for(i=0; i<FILESIZE; i+=1)
		func(map[i]);
	gettimeofday(&end, NULL);

	if(munmap(map, FILESIZE)==-1){
		perror("munmap");
		exit(EXIT_FAILURE);
	}

	if(close(fd)==-1){
		perror("close");
		exit(EXIT_FAILURE);
	}

	printf("start: %ld.%06ld\n", start.tv_sec, start.tv_usec);
	printf("end: %ld.%06ld\n", end.tv_sec, end.tv_usec);

	return 0;
}
